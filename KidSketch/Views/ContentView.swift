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
    
    // Dictionary of required strokes per letter
    let requiredStrokes: [Character: Int] = [
        "A": 3, "B": 2, "C": 1, "D": 2, "E": 4, "F": 3, "G": 2, "H": 3, "I": 3,
        "J": 1, "K": 3, "L": 2, "M": 4, "N": 3, "O": 1, "P": 2, "Q": 2, "R": 2,
        "S": 1, "T": 2, "U": 1, "V": 2, "W": 4, "X": 2, "Y": 3, "Z": 3
    ]
    
    @State private var currentLetterIndex = 0
    @State private var feedbackMessage = ""
    
    // Left practice canvas stroke count
    @State private var practiceStrokeCount = 0
    // Right final canvas stroke count
    @State private var finalStrokeCount = 0
    
    // Left canvas reset trigger
    @State private var resetPracticeCanvas = false
    // Right canvas reset trigger
    @State private var resetFinalCanvas = false
    
    // Controls if the final canvas is locked/unlocked
    @State private var isFinalCanvasUnlocked = false
    
    var currentLetter: Character {
        letters[currentLetterIndex]
    }
    
    // Required strokes for the current letter
    var maxStrokes: Int {
        requiredStrokes[currentLetter] ?? 1
    }
    
    // Change this to match your actual images, e.g. "A", "B", etc.
    var practiceImageName: String {
        return "\(currentLetter)" // A default image in Assets
    }
    
    var body: some View {
        GeometryReader { geometry in
            // The total available width in this container:
            let containerWidth = geometry.size.width
            let containerHeight = geometry.size.height
            
            // 1) Decide a fraction of the screen width for the canvas
            let desiredWidth = containerWidth * 0.4 // 40% of screen width
            
            // 2) For a 3:4 aspect ratio: height = width * (4/3)
            // but ensure it doesn't exceed containerHeight
            let aspectRatio: CGFloat = 3.0 / 4.0
            let desiredHeight = desiredWidth * (4.0 / 3.0)
            
            // 3) If that desiredHeight is bigger than containerHeight,
            //    clamp it so it fits. Then recalc width to match ratio.
            let finalHeight = min(desiredHeight, containerHeight * 0.7)
            let finalWidth = finalHeight * aspectRatio
            
            ZStack {
                Image("grass")
                    .resizable()
                    .scaledToFill()
                    .frame(width: finalWidth, height: finalHeight * 0.5)
                    .offset(x: -50,y: 410)
                
                HStack {
                    // ============ LEFT SIDE: PRACTICE CANVAS ============
                    Spacer()
                    VStack {
                        HStack {
                            
                            Text("Strokes: \(practiceStrokeCount)/\(maxStrokes)")
                            //                            .padding()
                            
                            Spacer()
                            
                            Button("Reset") {
                                resetPracticeCanvas.toggle()
                                practiceStrokeCount = 0
                                isFinalCanvasUnlocked = false
                            }
                            .padding()
                            
                        }
                        .frame(width: finalWidth)
                        
                        // The practice area has an image in the background
                        ZStack {
                            // Background image
                            Image(practiceImageName)
                                .resizable()
                                .scaledToFill()
                                .opacity(0.6)
                            // This ensures the image fits the same 300x400 region
                                .frame(width: finalWidth, height: finalHeight-50)
                            
                            PracticeCanvas(
                                strokeCount: $practiceStrokeCount,
                                maxStrokes: maxStrokes,
                                resetCanvasTrigger: $resetPracticeCanvas
                            ) {
                                print("[ContentView] Practice complete -> unlock final")
                                isFinalCanvasUnlocked = true
                            }
                            // The canvas must have the SAME frame so it overlays the image perfectly
                            .frame(width: finalWidth, height: finalHeight-50)
                        }
//                        .border(Color.gray, width: 1)
                    }
                    
                    // ============ RIGHT SIDE: FINAL CANVAS (CLASSIFICATION) ============
                    
                    Spacer()
                    
                    VStack {
                        
                        ZStack {
                            
                            Image("canvas")
                                .resizable()
                                .scaledToFill()
                            // This ensures the image fits the same 300x400 region
                                .frame(width: finalWidth+200, height: finalHeight+100)
                            
                            FinalCanvas(
                                strokeCount: $finalStrokeCount,
                                maxStrokes: maxStrokes,
                                resetCanvasTrigger: $resetFinalCanvas,
                                isCanvasUnlocked: isFinalCanvasUnlocked, // locks/unlocks
                                onClassify: { drawnImage in
                                    print("[ContentView] onClassify triggered -> classify with ML or Vision")
                                    // Example classification with Vision or custom model:
                                    classifyDrawing(drawnImage, useVision: false) { detectedLetter in
                                        DispatchQueue.main.async {
                                            validateLetter(detectedLetter)
                                        }
                                    }
                                }
                            )
                            //                        .border(isFinalCanvasUnlocked ? Color.green : Color.red, width: 2)
                            .frame(width: finalWidth+20, height: finalHeight-300)
                            .offset(x:-11.5, y: 135)
                            
                        }
                        HStack {
                            Text("Strokes: \(finalStrokeCount)/\(maxStrokes)")
                            
                            Spacer()
                            
                            Button("Retry") {
                                finalStrokeCount = 0
                                resetFinalCanvas.toggle()
                            }
                            
                            Spacer()
                            
                            Button("Skip") {
                                goToNextLetter()
                            }
                        }
                        .frame(width: finalWidth)
                        .offset(x: -20, y: -30)
                        
                        Text(feedbackMessage)
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                            .onChange(of: feedbackMessage) { oldVal, newVal in
                                print("[ContentView] feedbackMessage changed from '\(oldVal)' to '\(newVal)'")
                            }
                    }
                    .offset(y:-20)
                    
                    Spacer()
                }
                
            }
            .padding()
            .onAppear {
                print("[ContentView] Appeared with letter: \(currentLetter)")
                
            }
        }
    }
    
    // Validate recognized letter vs. currentLetter
    func validateLetter(_ detectedLetter: String?) {
        guard let detected = detectedLetter else {
            feedbackMessage = "⚠️ Could not recognize any letter."
            return
        }
        
        let expected = String(currentLetter)
        print("[ContentView] recognized: \(detected), expected: \(expected)")
        
        if detected == expected && finalStrokeCount == maxStrokes {
            feedbackMessage = "✅ Correct! Moving to next letter..."
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                goToNextLetter()
            }
        } else if finalStrokeCount == maxStrokes {
            feedbackMessage = "❌ Incorrect! Try again."
        } else {
            feedbackMessage = "✋ You reached max strokes on the final canvas!"
        }
    }
    
    // Go to next letter
    func goToNextLetter() {
        if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
            print("[ContentView] Next letter -> \(currentLetter)")
        } else {
            feedbackMessage = "🎉 Completed all letters!"
            print("[ContentView] \(feedbackMessage)")
        }
        // Reset both canvases for the new letter
        practiceStrokeCount = 0
        finalStrokeCount = 0
        resetPracticeCanvas.toggle()
        resetFinalCanvas.toggle()
        isFinalCanvasUnlocked = false
        feedbackMessage = ""
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
