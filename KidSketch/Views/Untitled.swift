//
//import SwiftUI
//import CoreML
//import Vision
//import UIKit
//
//struct ContentView: View {
////    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
//    let letters = Array("AC")
//    let requiredStrokes: [Character: Int] = [
//        "A": 3, "B": 2, "C": 1, "D": 2, "E": 4, "F": 3, "G": 2, "H": 3, "I": 3,
//        "J": 1, "K": 3, "L": 2, "M": 4, "N": 3, "O": 1, "P": 2, "Q": 2, "R": 2,
//        "S": 1, "T": 2, "U": 1, "V": 2, "W": 4, "X": 2, "Y": 3, "Z": 3
//    ]
//
//    // Tracking progress stats
//    @State private var uniqueCorrectLetters = Set<Character>()
//    @State private var totalAttempts = 0
//    @State private var correctAttempts = 0
//    @State private var incorrectAttempts = 0
//
//    // Canvas state
//    @State private var currentLetterIndex = 0
//    @State private var practiceStrokeCount = 0
//    @State private var finalStrokeCount = 0
//    @State private var resetPracticeCanvas = false
//    @State private var resetFinalCanvas = false
//    @State private var isFinalCanvasUnlocked = false
//
//    // Alert & Progress Tracking
//    @State private var showAlert = false
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var alertIsCorrect = false
//    @State private var showProgressTracker = false  // **New State: Show Progress View**
//    
//    var currentLetter: Character {
//        letters[currentLetterIndex]
//    }
//    var maxStrokes: Int {
//        requiredStrokes[currentLetter] ?? 1
//    }
//    var practiceImageName: String {
//        "\(currentLetter)"
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Image("grass")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: geometry.size.width * 0.7,
//                           height: geometry.size.height * 0.35)
//                    .offset(x: 60, y: 500)
//                
//                VStack {
//                    HStack {
//                        Text("Strokes: \(practiceStrokeCount)/\(maxStrokes)")
//                        Spacer()
//                        Button("Reset") {
//                            practiceStrokeCount = 0
//                            resetPracticeCanvas = true
//                            isFinalCanvasUnlocked = false
//                        }
//                        .padding()
//                    }
//                    .frame(width: geometry.size.width * 0.4)
//                    
//                    ZStack {
//                        Image(practiceImageName)
//                            .resizable()
//                            .scaledToFill()
//                            .opacity(0.6)
//                            .frame(width: geometry.size.width * 0.4,
//                                   height: geometry.size.height * 0.6)
//                        
//                        PracticeCanvas(
//                            strokeCount: $practiceStrokeCount,
//                            maxStrokes: maxStrokes,
//                            resetCanvasTrigger: $resetPracticeCanvas
//                        ) {
//                            isFinalCanvasUnlocked = true
//                        }
//                        .frame(width: geometry.size.width * 0.4,
//                               height: geometry.size.height * 0.6)
//                    }
////                    .border(Color.gray, width: 1)
//                }
//                .offset(x: -150, y: 80)
//
//                VStack {
//                    ZStack {
//                        Image("canvas")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: geometry.size.width * 0.55,
//                                   height: geometry.size.height * 0.6)
//                        
//                        FinalCanvas(
//                            strokeCount: $finalStrokeCount,
//                            maxStrokes: maxStrokes,
//                            resetCanvasTrigger: $resetFinalCanvas,
//                            isCanvasUnlocked: isFinalCanvasUnlocked,
//                            onClassify: { drawnImage in
//                                classifyDrawing(drawnImage, useVision: false) { detectedLetter in
//                                    DispatchQueue.main.async {
//                                        validateLetter(detectedLetter)
//                                    }
//                                }
//                            }
//                        )
//                        .frame(width: geometry.size.width * 0.37,
//                               height: geometry.size.height * 0.32)
//                        .offset(x: -12, y: 140)
//                    }
//                    
//                    HStack {
//                        Text("Strokes: \(finalStrokeCount)/\(maxStrokes)")
//                        Spacer()
//                        Button("Retry") {
//                            finalStrokeCount = 0
//                            resetFinalCanvas = true
//                        }
//                        Spacer()
//                        Button("Skip") {
//                            goToNextLetter()
//                        }
//                    }
//                    .frame(width: geometry.size.width * 0.37)
//                    .offset(x: -20, y: 60)
//                }
//                .offset(x: 430, y: 80)
//            }
//            .padding()
//            .alert(alertTitle, isPresented: $showAlert) {
//                Button("OK") {
//                    clearCanvases()
//                    if alertIsCorrect {
//                        goToNextLetter()
//                    }
//                }
//            } message: {
//                Text(alertMessage)
//            }
//            .fullScreenCover(isPresented: $showProgressTracker) {
//                ProgressView(
//                    uniqueCorrectLetters: uniqueCorrectLetters.count,
//                    totalAttempts: totalAttempts,
//                    correctAttempts: correctAttempts,
//                    incorrectAttempts: incorrectAttempts
//                )
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//    }
//    
//    func validateLetter(_ detectedLetter: String?) {
//        totalAttempts += 1
//        
//        guard let detected = detectedLetter else {
//            incorrectAttempts += 1
//            showCustomAlert(title: "No Letter Recognized",
//                            message: "Detected: None\nExpected: \(currentLetter)",
//                            isCorrect: false)
//            return
//        }
//        
//        if detected == String(currentLetter), finalStrokeCount == maxStrokes {
//            correctAttempts += 1
//            uniqueCorrectLetters.insert(currentLetter)  // Track unique correct letters
//            showCustomAlert(title: "Correct!",
//                            message: "Detected: \(detected)\nExpected: \(currentLetter)",
//                            isCorrect: true)
//        } else {
//            incorrectAttempts += 1
//            showCustomAlert(title: "Incorrect!",
//                            message: "Detected: \(detected)\nExpected: \(currentLetter)",
//                            isCorrect: false)
//        }
//    }
//
//    func showCustomAlert(title: String, message: String, isCorrect: Bool) {
//        alertTitle = title
//        alertMessage = message
//        alertIsCorrect = isCorrect
//        showAlert = true
//    }
//
//    func goToNextLetter() {
//        if currentLetterIndex < letters.count - 1 {
//            currentLetterIndex += 1
//        } else {
//            showProgressTracker = true  // **Trigger Progress Tracker when all letters are done**
//        }
//        clearCanvases()
//    }
//
//    func clearCanvases() {
//        practiceStrokeCount = 0
//        finalStrokeCount = 0
//        resetPracticeCanvas = true
//        resetFinalCanvas = true
//        isFinalCanvasUnlocked = false
//    }
//}
//
//struct FinalCanvas: View {
//    @Binding var strokeCount: Int
//    let maxStrokes: Int
//    @Binding var resetCanvasTrigger: Bool
//
//    // Whether user can draw or not
//    let isCanvasUnlocked: Bool
//
//    // Called when user has drawn the required strokes in final canvas
//    let onClassify: (UIImage) -> Void
//
//    @State private var strokes: [[CGPoint]] = [[]]
//
//    var body: some View {
//        ZStack {
//            // If locked, show a semi-transparent overlay
//            if !isCanvasUnlocked {
//                Color.gray.opacity(0.3)
//                    .overlay(Text("Locked").font(.title))
//            }
//
//            // If unlocked, let user draw
//            if isCanvasUnlocked {
//                Color.white
//                    .gesture(
//                        DragGesture(minimumDistance: 0)
//                            .onChanged { value in
//                                if strokeCount < maxStrokes {
//                                    strokes[strokes.count - 1].append(value.location)
//                                }
//                            }
//                            .onEnded { _ in
//                                if strokeCount < maxStrokes {
//                                    strokes.append([])
//                                    strokeCount += 1
//                                    print("[FinalCanvas] Stroke ended. strokeCount = \(strokeCount)")
//
//                                    // If we have reached required strokes, classify
//                                    if strokeCount == maxStrokes {
//                                        let image = renderDrawing()
//                                        onClassify(image)
//                                    }
//                                }
//                            }
//                    )
//            }
//
//            // Draw strokes
//            ForEach(strokes, id: \.self) { stroke in
//                Path { path in
//                    if let firstPoint = stroke.first {
//                        path.move(to: firstPoint)
//                        for point in stroke.dropFirst() {
//                            path.addLine(to: point)
//                        }
//                    }
//                }
//                .stroke(Color.black, lineWidth: 25)
//            }
//        }
//        .onChange(of: resetCanvasTrigger) {
//            if resetCanvasTrigger {
//                print("[Canvas] Clearing strokes.")
//                strokes = [[]]
//                
//                // Optionally set back to false to watch for the next time we set it to true
//                // e.g.:
//                DispatchQueue.main.async {
//                    resetCanvasTrigger = false
//                }
//            }
//        }
//    }
//
//    func renderDrawing() -> UIImage {
//        print("[FinalCanvas] renderDrawing -> generating UIImage")
//        let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
//        return renderer.image { ctx in
//            UIColor.white.setFill()
//            ctx.fill(UIScreen.main.bounds)
//            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//            ctx.cgContext.setLineWidth(6)
//
//            for stroke in strokes {
//                if let first = stroke.first {
//                    ctx.cgContext.move(to: first)
//                    for point in stroke.dropFirst() {
//                        ctx.cgContext.addLine(to: point)
//                    }
//                    ctx.cgContext.strokePath()
//                }
//            }
//        }
//    }
//}
//
//// MARK: - (OPTIONAL) CLASSIFICATION (Use Vision or ML model)
//func classifyDrawing(
//    _ image: UIImage,
//    useVision: Bool,
//    completion: @escaping (String?) -> Void
//) {
//    if useVision {
//        // =============== VISION OCR PATH ===============
//        print("[classifyDrawing] Using Vision OCR for detection...")
//
//        let request = VNRecognizeTextRequest { request, error in
//            if let error = error {
//                print("[classifyDrawing] ⚠️ Vision error: \(error)")
//                completion(nil)
//                return
//            }
//            guard
//                let observations = request.results as? [VNRecognizedTextObservation],
//                let firstObs = observations.first,
//                let topCandidate = firstObs.topCandidates(1).first
//            else {
//                print("[classifyDrawing] ⚠️ No recognized text found (Vision).")
//                completion(nil)
//                return
//            }
//            print("[classifyDrawing] Vision found text: \(topCandidate.string)")
//            completion(topCandidate.string)
//        }
//
//        // Vision OCR settings
//        request.recognitionLevel = .accurate
//        request.usesLanguageCorrection = false
//        request.recognitionLanguages = ["en"] // or ["en-US"]
//
//        guard let cgImage = image.cgImage else {
//            print("[classifyDrawing] ⚠️ Could not get CGImage for Vision.")
//            completion(nil)
//            return
//        }
//
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try handler.perform([request])
//            } catch {
//                print("[classifyDrawing] ⚠️ Error performing Vision request: \(error)")
//                completion(nil)
//            }
//        }
//
//    } else {
//        // =============== CUSTOM .MLMODEL PATH ===============
//        print("[classifyDrawing] Using custom HandwritingModel for detection...")
//
//        let config = MLModelConfiguration()
//        do {
//            // Load with init(configuration:)
//            let handwritingMLModel = try HandwritingModel(configuration: config)
//            let visionModel = try VNCoreMLModel(for: handwritingMLModel.model)
//
//            // Create a VNCoreMLRequest
//            let request = VNCoreMLRequest(model: visionModel) { request, error in
//                if let error = error {
//                    print("[classifyDrawing] ⚠️ CoreML request error: \(error)")
//                    completion(nil)
//                    return
//                }
//                guard
//                    let results = request.results as? [VNClassificationObservation],
//                    let topResult = results.first
//                else {
//                    print("[classifyDrawing] ⚠️ No classification result (CoreML).")
//                    completion(nil)
//                    return
//                }
//                print("[classifyDrawing] .mlmodel recognized: \(topResult.identifier) (confidence \(topResult.confidence))")
//                completion(topResult.identifier)
//            }
//
//            // Convert UIImage -> CIImage
//            guard let ciImage = CIImage(image: image) else {
//                print("[classifyDrawing] ⚠️ Failed to convert UIImage -> CIImage.")
//                completion(nil)
//                return
//            }
//
//            let handler = VNImageRequestHandler(ciImage: ciImage)
//            DispatchQueue.global(qos: .userInitiated).async {
//                do {
//                    try handler.perform([request])
//                } catch {
//                    print("[classifyDrawing] ⚠️ Error performing CoreML request: \(error)")
//                    completion(nil)
//                }
//            }
//
//        } catch {
//            print("[classifyDrawing] ⚠️ Failed to load HandwritingModel with configuration: \(error)")
//            completion(nil)
//        }
//    }
//}
