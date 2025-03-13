//
//  VisionTextRecognizer.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 13/03/25.
//

//
//  VisionTextRecognizer.swift
//  YourHandwritingApp
//

import Vision
import UIKit

/// Uses Apple's built-in text recognition to identify a single letter in an image
func recognizeLetterUsingVisionOCR(_ image: UIImage, completion: @escaping (String?) -> Void) {
    print("[VisionTextRecognizer] Starting built-in OCR...")

    // Create a text recognition request
    let request = VNRecognizeTextRequest { request, error in
        if let error = error {
            print("[VisionTextRecognizer] ⚠️ Error: \(error)")
            completion(nil)
            return
        }
        guard let results = request.results as? [VNRecognizedTextObservation],
              let firstObservation = results.first,
              let topCandidate = firstObservation.topCandidates(1).first else {
            print("[VisionTextRecognizer] ⚠️ No recognized text found.")
            completion(nil)
            return
        }
        print("[VisionTextRecognizer] Found text: \(topCandidate.string)")
        completion(topCandidate.string)
    }

    // iOS built-in OCR tweaks:
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = false
    request.recognitionLanguages = ["en"] // or e.g., ["en-US"]

    // Convert UIImage -> CGImage
    guard let cgImage = image.cgImage else {
        print("[VisionTextRecognizer] ⚠️ Unable to convert UIImage to CGImage.")
        completion(nil)
        return
    }

    // Perform the text recognition request
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try handler.perform([request])
        } catch {
            print("[VisionTextRecognizer] ⚠️ Error performing text request: \(error)")
            completion(nil)
        }
    }
}
