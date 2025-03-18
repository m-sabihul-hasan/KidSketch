////
////  HelperFunctions.swift
////  KidSketch
////
////  Created by Muhammad Sabihul Hasan on 18/03/25.
////
//
//import Foundation
//import Vision
//import CoreML
//import UIKit
//
//// ✅ Main Classification Function
//func classifyDrawing(_ image: UIImage, useVision: Bool, completion: @escaping ([String: Float]?) -> Void) {
//    let processedImage = preprocessImage(image) ?? image // Use preprocessed image
//
//    // 🔹 Define a DispatchGroup to synchronize multiple classification methods
//    let dispatchGroup = DispatchGroup()
//    
//    var predictions: [String: Float] = [:]
//
//    // 🔹 Use Vision OCR
//    if useVision {
//        dispatchGroup.enter()
//        classifyWithVisionOCR(processedImage) { visionResults in
//            if let visionResults = visionResults {
//                predictions.merge(visionResults) { (_, new) in new } // Merge predictions
//            }
//            dispatchGroup.leave()
//        }
//    }
//
//    // 🔹 Use CoreML Handwriting Model
//    dispatchGroup.enter()
//    classifyWithCoreML(processedImage) { coreMLResults in
//        if let coreMLResults = coreMLResults {
//            predictions.merge(coreMLResults) { (_, new) in new } // Merge predictions
//        }
//        dispatchGroup.leave()
//    }
//
//    // 🔹 Use External API (e.g., Scribble or Custom API)
//    dispatchGroup.enter()
//    classifyWithAPI(processedImage) { apiResults in
//        if let apiResults = apiResults {
//            predictions.merge(apiResults) { (_, new) in new } // Merge predictions
//        }
//        dispatchGroup.leave()
//    }
//
//    // ✅ Return final merged predictions after all methods complete
//    dispatchGroup.notify(queue: .main) {
//        completion(predictions.isEmpty ? nil : predictions)
//    }
//}
//
//// ✅ Vision OCR Function
//func classifyWithVisionOCR(_ image: UIImage, completion: @escaping ([String: Float]?) -> Void) {
//    print("[Vision OCR] Processing Image...")
//
//    let request = VNRecognizeTextRequest { request, error in
//        if let error = error {
//            print("[Vision OCR] ⚠️ Error: \(error)")
//            completion(nil)
//            return
//        }
//        guard let observations = request.results as? [VNRecognizedTextObservation] else {
//            print("[Vision OCR] ⚠️ No text recognized.")
//            completion(nil)
//            return
//        }
//        
//        var results: [String: Float] = [:]
//        for observation in observations {
//            if let topCandidate = observation.topCandidates(1).first {
//                results[topCandidate.string] = Float(observation.confidence)
//            }
//        }
//        
//        completion(results.isEmpty ? nil : results)
//    }
//
//    request.recognitionLevel = .accurate
//    request.usesLanguageCorrection = false
//    request.recognitionLanguages = ["en"]
//
//    guard let cgImage = image.cgImage else {
//        print("[Vision OCR] ⚠️ Could not get CGImage.")
//        completion(nil)
//        return
//    }
//
//    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//    DispatchQueue.global(qos: .userInitiated).async {
//        do {
//            try handler.perform([request])
//        } catch {
//            print("[Vision OCR] ⚠️ Error performing Vision request: \(error)")
//            completion(nil)
//        }
//    }
//}
//
//// ✅ CoreML Handwriting Model Function
//func classifyWithCoreML(_ image: UIImage, completion: @escaping ([String: Float]?) -> Void) {
//    print("[CoreML] Processing Image with Handwriting Model...")
//
//    let config = MLModelConfiguration()
//    do {
//        let handwritingMLModel = try HandwritingModel(configuration: config)
//        let visionModel = try VNCoreMLModel(for: handwritingMLModel.model)
//
//        let request = VNCoreMLRequest(model: visionModel) { request, error in
//            if let error = error {
//                print("[CoreML] ⚠️ Error: \(error)")
//                completion(nil)
//                return
//            }
//            guard let results = request.results as? [VNClassificationObservation] else {
//                print("[CoreML] ⚠️ No classification result.")
//                completion(nil)
//                return
//            }
//
//            var predictions: [String: Float] = [:]
//            for result in results {
//                predictions[result.identifier] = result.confidence
//            }
//
//            completion(predictions.isEmpty ? nil : predictions)
//        }
//
//        guard let ciImage = CIImage(image: image) else {
//            print("[CoreML] ⚠️ Could not convert UIImage to CIImage.")
//            completion(nil)
//            return
//        }
//
//        let handler = VNImageRequestHandler(ciImage: ciImage)
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try handler.perform([request])
//            } catch {
//                print("[CoreML] ⚠️ Error performing CoreML request: \(error)")
//                completion(nil)
//            }
//        }
//
//    } catch {
//        print("[CoreML] ⚠️ Failed to load HandwritingModel: \(error)")
//        completion(nil)
//    }
//}
//
//// ✅ External API Classification (Scribble or Custom API)
//func classifyWithAPI(_ image: UIImage, completion: @escaping ([String: Float]?) -> Void) {
//    print("[API] Sending image to external classification API...")
//
//    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//        print("[API] ⚠️ Failed to convert image to JPEG data.")
//        completion(nil)
//        return
//    }
//
//    let url = URL(string: "https://your-api-endpoint.com/classify")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    let jsonBody: [String: Any] = ["image": imageData.base64EncodedString()]
//
//    do {
//        request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
//    } catch {
//        print("[API] ⚠️ Error encoding JSON: \(error)")
//        completion(nil)
//        return
//    }
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data, error == nil else {
//            print("[API] ⚠️ Network or server error: \(error?.localizedDescription ?? "Unknown error")")
//            completion(nil)
//            return
//        }
//
//        do {
//            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//               let predictions = jsonResponse["predictions"] as? [String: Float] {
//                print("[API] ✅ Received classifications from API:", predictions)
//                completion(predictions)
//            } else {
//                print("[API] ⚠️ Unexpected response format.")
//                completion(nil)
//            }
//        } catch {
//            print("[API] ⚠️ JSON parsing error: \(error)")
//            completion(nil)
//        }
//    }
//
//    task.resume()
//}
//
////// ✅ Image Preprocessing Function
////func preprocessImage(_ image: UIImage) -> UIImage? {
////    print("[Preprocessing] Converting image to grayscale and adjusting contrast...")
////    
////    let ciImage = CIImage(image: image)
////    let filter = CIFilter(name: "CIColorControls")
////    filter?.setValue(ciImage, forKey: kCIInputImageKey)
////    filter?.setValue(0, forKey: kCIInputSaturationKey)
////    filter?.setValue(1.5, forKey: kCIInputContrastKey)
////
////    guard let outputImage = filter?.outputImage else {
////        print("[Preprocessing] ⚠️ Failed to process image.")
////        return nil
////    }
////
////    let context = CIContext()
////    guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
////        print("[Preprocessing] ⚠️ Could not create CGImage.")
////        return nil
////    }
////
////    return UIImage(cgImage: cgImage)
////}
