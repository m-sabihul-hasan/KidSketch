//
//  FinalCanvas.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 12/03/25.
//

import SwiftUI
import CoreML
import Vision
import UIKit

struct FinalCanvas: View {
    @Binding var strokeCount: Int
    let maxStrokes: Int
    @Binding var resetCanvasTrigger: Bool

    // Whether user can draw or not
    let isCanvasUnlocked: Bool

    // Called when user has drawn the required strokes in final canvas
    let onClassify: (UIImage) -> Void

    @State private var strokes: [[CGPoint]] = [[]]

    var body: some View {
        ZStack {
            // If locked, show a semi-transparent overlay
            if !isCanvasUnlocked {
                Color.gray.opacity(0.3)
                    .overlay(Text("Locked").font(.title))
            }

            // If unlocked, let user draw
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
                                    print("[FinalCanvas] Stroke ended. strokeCount = \(strokeCount)")

                                    // If we have reached required strokes, classify
                                    if strokeCount == maxStrokes {
                                        let image = renderDrawing()
                                        onClassify(image)
                                    }
                                }
                            }
                    )
            }

            // Draw strokes
            ForEach(strokes, id: \.self) { stroke in
                Path { path in
                    if let firstPoint = stroke.first {
                        path.move(to: firstPoint)
                        for point in stroke.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.black, lineWidth: 25)
            }
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
        print("[FinalCanvas] renderDrawing -> generating UIImage")
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

// MARK: - (OPTIONAL) CLASSIFICATION (Use Vision or ML model)
func classifyDrawing(
    _ image: UIImage,
    useVision: Bool,
    completion: @escaping (String?) -> Void
) {
    if useVision {
        // =============== VISION OCR PATH ===============
        print("[classifyDrawing] Using Vision OCR for detection...")

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("[classifyDrawing] ⚠️ Vision error: \(error)")
                completion(nil)
                return
            }
            guard
                let observations = request.results as? [VNRecognizedTextObservation],
                let firstObs = observations.first,
                let topCandidate = firstObs.topCandidates(1).first
            else {
                print("[classifyDrawing] ⚠️ No recognized text found (Vision).")
                completion(nil)
                return
            }
            print("[classifyDrawing] Vision found text: \(topCandidate.string)")
            completion(topCandidate.string)
        }

        // Vision OCR settings
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        request.recognitionLanguages = ["en"] // or ["en-US"]

        guard let cgImage = image.cgImage else {
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
        // =============== CUSTOM .MLMODEL PATH ===============
        print("[classifyDrawing] Using custom HandwritingModel for detection...")

        let config = MLModelConfiguration()
        do {
            // Load with init(configuration:)
            let handwritingMLModel = try HandwritingModel(configuration: config)
            let visionModel = try VNCoreMLModel(for: handwritingMLModel.model)

            // Create a VNCoreMLRequest
            let request = VNCoreMLRequest(model: visionModel) { request, error in
                if let error = error {
                    print("[classifyDrawing] ⚠️ CoreML request error: \(error)")
                    completion(nil)
                    return
                }
                guard
                    let results = request.results as? [VNClassificationObservation],
                    let topResult = results.first
                else {
                    print("[classifyDrawing] ⚠️ No classification result (CoreML).")
                    completion(nil)
                    return
                }
                print("[classifyDrawing] .mlmodel recognized: \(topResult.identifier) (confidence \(topResult.confidence))")
                completion(topResult.identifier)
            }

            // Convert UIImage -> CIImage
            guard let ciImage = CIImage(image: image) else {
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
            print("[classifyDrawing] ⚠️ Failed to load HandwritingModel with configuration: \(error)")
            completion(nil)
        }
    }
}
