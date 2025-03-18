//
//  FinalCanvas.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 12/03/25.
//

import SwiftUI
import Vision
import UIKit
import CoreImage

struct FinalCanvas: View {
    @Binding var strokeCount: Int
    let maxStrokes: Int
    @Binding var resetCanvasTrigger: Bool

    let isCanvasUnlocked: Bool
    let onClassify: (UIImage) -> Void

    @State private var strokes: [[CGPoint]] = [[]]
    @State private var processedImage: UIImage?

    var body: some View {
        VStack {
            ZStack {
                if !isCanvasUnlocked {
                    Color.gray.opacity(0.3)
                        .overlay(Text("Locked").font(.title))
                }

                if isCanvasUnlocked {
                    Color.white
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if strokeCount < maxStrokes {
                                        strokes[strokes.count - 1].append(value.location)
                                    }
                                }
                                .onEnded { _ in
                                    if strokeCount < maxStrokes {
                                        strokes.append([])
                                        strokeCount += 1

                                        if strokeCount == maxStrokes {
                                            let image = renderDrawing()
                                            processedImage = preprocessImage(image)
                                            onClassify(processedImage ?? image)
                                        }
                                    }
                                }
                        )
                }

                ForEach(strokes, id: \.self) { stroke in
                    Path { path in
                        if let firstPoint = stroke.first {
                            path.move(to: firstPoint)
                            for point in stroke.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                    }
                    .stroke(Color.black, lineWidth: 20)
                }
            }
///
//            if let image = processedImage {
//                Button("Preview Processed Image") {
//                    showImagePreview(image: image)
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
        }
        .onChange(of: resetCanvasTrigger) {
            if resetCanvasTrigger {
                print("[Canvas] Clearing strokes.")
                strokes = [[]]
                
                // Optionally set back to false to watch for the next time we set it to true
                // e.g.:
                DispatchQueue.main.async {
                    resetCanvasTrigger = false
                }
            }
        }
    }

    func renderDrawing() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
        return renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(UIScreen.main.bounds)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(6)

            for stroke in strokes {
                if let first = stroke.first {
                    ctx.cgContext.move(to: first)
                    for point in stroke.dropFirst() {
                        ctx.cgContext.addLine(to: point)
                    }
                    ctx.cgContext.strokePath()
                }
            }
        }
    }
}

func showImagePreview(image: UIImage) {
    print("[Preview] Displaying preprocessed image.")

    let previewVC = UIViewController()
    previewVC.view.backgroundColor = .white

    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.frame = previewVC.view.frame
    previewVC.view.addSubview(imageView)

    let closeButton = UIButton(frame: CGRect(x: 20, y: 40, width: 80, height: 40))
    closeButton.setTitle("Close", for: .normal)
    closeButton.backgroundColor = .black
    closeButton.setTitleColor(.white, for: .normal)
    closeButton.addTarget(previewVC, action: #selector(UIViewController.dismiss), for: .touchUpInside)
    previewVC.view.addSubview(closeButton)

    // Use UIWindowScene for iOS 15+
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = scene.windows.first {
        window.rootViewController?.present(previewVC, animated: true)
    } else {
        print("[Preview] ⚠️ Unable to find UIWindowScene.")
    }
}

func preprocessImage(_ image: UIImage) -> UIImage? {
    print("[Preprocessing] Converting image to grayscale and thickening strokes...")

    guard let ciImage = CIImage(image: image) else {
        print("[Preprocessing] ⚠️ Failed to convert UIImage to CIImage.")
        return nil
    }

    let context = CIContext(options: nil)

    // Convert to grayscale
    let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono")
    grayscaleFilter?.setValue(ciImage, forKey: kCIInputImageKey)

    // Increase contrast
    let contrastFilter = CIFilter(name: "CIColorControls")
    contrastFilter?.setValue(grayscaleFilter?.outputImage, forKey: kCIInputImageKey)
    contrastFilter?.setValue(1.5, forKey: "inputContrast")
    contrastFilter?.setValue(0.2, forKey: "inputBrightness") // Slightly brighten

    guard let outputImage = contrastFilter?.outputImage,
          let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
        print("[Preprocessing] ⚠️ Failed to process image.")
        return nil
    }

    let finalImage = UIImage(cgImage: cgImage)
    print("[Preprocessing] ✅ Image successfully processed with thicker strokes.")
    return finalImage
}


func classifyDrawing(_ image: UIImage, useVision: Bool, completion: @escaping ([String: Float]?) -> Void) {
    let processedImage = preprocessImage(image) ?? image // Use the processed version

    if useVision {
        print("[classifyDrawing] Using Vision OCR with preprocessed image...")

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("[classifyDrawing] ⚠️ Vision error: \(error)")
                completion(nil)
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("[classifyDrawing] ⚠️ No recognized text found (Vision).")
                completion(nil)
                return
            }

            var predictions: [String: Float] = [:]
            
            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    predictions[topCandidate.string] = observation.confidence
                }
            }

            if let highest = predictions.max(by: { $0.value < $1.value }) {
                print("[classifyDrawing] ✅ Highest Prediction: \(highest.key) (confidence \(highest.value))")
            }

            completion(predictions.isEmpty ? nil : predictions)
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        request.recognitionLanguages = ["en"]

        guard let cgImage = processedImage.cgImage else {
            print("[classifyDrawing] ⚠️ Could not get CGImage for Vision.")
            completion(nil)
            return
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("[classifyDrawing] ⚠️ Error performing Vision request: \(error)")
                completion(nil)
            }
        }

    } else {
        print("[classifyDrawing] Using CoreML handwriting model...")

        let config = MLModelConfiguration()
        do {
            let handwritingMLModel = try HandwritingModel(configuration: config)
            let visionModel = try VNCoreMLModel(for: handwritingMLModel.model)

            let request = VNCoreMLRequest(model: visionModel) { request, error in
                if let error = error {
                    print("[classifyDrawing] ⚠️ CoreML request error: \(error)")
                    completion(nil)
                    return
                }

                guard let results = request.results as? [VNClassificationObservation] else {
                    print("[classifyDrawing] ⚠️ No classification result (CoreML).")
                    completion(nil)
                    return
                }

                var predictions: [String: Float] = [:]
                
                for result in results {
                    predictions[result.identifier] = result.confidence
                }

                if let highest = predictions.max(by: { $0.value < $1.value }) {
                    print("[classifyDrawing] ✅ Highest Prediction: \(highest.key) (confidence \(highest.value))")
                }

                completion(predictions.isEmpty ? nil : predictions)
            }

            guard let ciImage = CIImage(image: processedImage) else {
                print("[classifyDrawing] ⚠️ Failed to convert UIImage -> CIImage.")
                completion(nil)
                return
            }

            let handler = VNImageRequestHandler(ciImage: ciImage)
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("[classifyDrawing] ⚠️ Error performing CoreML request: \(error)")
                    completion(nil)
                }
            }

        } catch {
            print("[classifyDrawing] ⚠️ Failed to load HandwritingModel: \(error)")
            completion(nil)
        }
    }
}
