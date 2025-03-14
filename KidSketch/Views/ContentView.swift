//
//  ContentView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 12/03/25.
//

import SwiftUI

struct ContentView: View {
    // List of letters
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    
    // Dictionary for required strokes
    let requiredStrokes: [Character: Int] = [
        "A": 3, "B": 2, "C": 1, "D": 2, "E": 4, "F": 3, "G": 2, "H": 3, "I": 3,
        "J": 1, "K": 3, "L": 2, "M": 4, "N": 3, "O": 1, "P": 2, "Q": 2, "R": 2,
        "S": 1, "T": 2, "U": 1, "V": 2, "W": 4, "X": 2, "Y": 3, "Z": 3
    ]
    
    // Canvas states & triggers
    @State private var currentLetterIndex = 0
    @State private var practiceStrokeCount = 0
    @State private var finalStrokeCount = 0
    @State private var resetPracticeCanvas = false
    @State private var resetFinalCanvas = false
    @State private var isFinalCanvasUnlocked = false
    
    // Alert states
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertIsCorrect = false // Distinguish correct vs. incorrect
    
    // Current letter
    var currentLetter: Character {
        letters[currentLetterIndex]
    }
    
    // Required strokes
    var maxStrokes: Int {
        requiredStrokes[currentLetter] ?? 1
    }
    
    // Background letter image
    var practiceImageName: String {
        "\(currentLetter)"
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Example background
                Image("grass")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.7,
                           height: geometry.size.height * 0.35)
                    .offset(x: 60, y: 500)
                
                // ================== LEFT (Practice) ==================
                VStack {
                    HStack {
                        Text("Strokes: \(practiceStrokeCount)/\(maxStrokes)")
                        Spacer()
                        Button("Reset") {
                            // Clear only the practice side
                            practiceStrokeCount = 0
                            resetPracticeCanvas.toggle()
                            // Also lock final again
                            isFinalCanvasUnlocked = false
                        }
                        .padding()
                    }
                    .frame(width: geometry.size.width * 0.4)
                    
                    ZStack {
                        Image(practiceImageName)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.6)
                            .frame(width: geometry.size.width * 0.4,
                                   height: geometry.size.height * 0.6)
                        
                        PracticeCanvas(
                            strokeCount: $practiceStrokeCount,
                            maxStrokes: maxStrokes,
                            resetCanvasTrigger: $resetPracticeCanvas
                        ) {
                            print("[ContentView] Practice complete -> unlock final")
                            isFinalCanvasUnlocked = true
                        }
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.height * 0.6)
                    }
//                    .border(Color.gray, width: 1)
                }
                .offset(x: -150, y: 80)
                
                // ================== RIGHT (Final) ==================
                VStack {
                    ZStack {
                        Image("canvas")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.55,
                                   height: geometry.size.height * 0.6)
                        
                        FinalCanvas(
                            strokeCount: $finalStrokeCount,
                            maxStrokes: maxStrokes,
                            resetCanvasTrigger: $resetFinalCanvas,
                            isCanvasUnlocked: isFinalCanvasUnlocked,
                            onClassify: { drawnImage in
                                print("[ContentView] onClassify triggered -> classify")
                                classifyDrawing(drawnImage, useVision: false) { detectedLetter in
                                    DispatchQueue.main.async {
                                        validateLetter(detectedLetter)
                                    }
                                }
                            }
                        )
                        .frame(width: geometry.size.width * 0.37,
                               height: geometry.size.height * 0.32)
                        .offset(x: -12, y: 140)
                    }
                    
                    // Strokes + Retry / Skip
                    HStack {
                        Text("Strokes: \(finalStrokeCount)/\(maxStrokes)")
                        Spacer()
                        Button("Retry") {
                            finalStrokeCount = 0
                            resetFinalCanvas.toggle()
                        }
                        Spacer()
                        Button("Skip") {
                            // Always treat skip as correct => next letter
                            goToNextLetter()
                        }
                    }
                    .frame(width: geometry.size.width * 0.37)
                    .offset(x: -20, y: 60)
                }
                .offset(x: 430, y: 80)
            }
            .padding()
            .onAppear {
                print("[ContentView] Appeared with letter: \(currentLetter)")
            }
            // The classification Alert
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {
                    // Always clear the canvases
                    clearCanvases()
                    
                    // If correct => also move to next letter
                    if alertIsCorrect {
                        goToNextLetter()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Validate recognized letter
    func validateLetter(_ detectedLetter: String?) {
        guard let detected = detectedLetter else {
            // Could not recognize
            showCustomAlert(
                title: "No Letter Recognized",
                message: "Detected: None\nExpected: \(currentLetter)",
                isCorrect: false
            )
            return
        }
        
        print("[ContentView] recognized: \(detected), expected: \(currentLetter)")
        
        if detected == String(currentLetter), finalStrokeCount == maxStrokes {
            // CORRECT
            showCustomAlert(
                title: "Correct!",
                message: "Detected: \(detected)\nExpected: \(currentLetter)",
                isCorrect: true
            )
        }
        else if finalStrokeCount == maxStrokes {
            // INCORRECT
            showCustomAlert(
                title: "Incorrect!",
                message: "Detected: \(detected)\nExpected: \(currentLetter)",
                isCorrect: false
            )
        }
        else {
            // Exceeded strokes
            showCustomAlert(
                title: "Max Strokes Reached",
                message: "Detected: \(detected)\nExpected: \(currentLetter)",
                isCorrect: false
            )
        }
    }
    
    // Show an alert
    func showCustomAlert(title: String, message: String, isCorrect: Bool) {
        alertTitle = title
        alertMessage = message
        alertIsCorrect = isCorrect
        showAlert = true
    }
    
    // MARK: - Move on to next letter
    func goToNextLetter() {
        if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
            print("[ContentView] Next letter -> \(currentLetter)")
        } else {
            // Reached end
            print("[ContentView] Completed all letters!")
        }
    }
    
    // MARK: - Clear both canvases after each attempt
    func clearCanvases() {
        // 1) Zero out stroke counts
        practiceStrokeCount = 0
        finalStrokeCount = 0

        // 2) Unlock or relock the final canvas as needed
        isFinalCanvasUnlocked = false

        // 3) Explicitly set triggers to true
        resetPracticeCanvas = true
        resetFinalCanvas = true
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
