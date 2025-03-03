//
//  LetterView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 03/03/25.
//

import SwiftUI
import AVFoundation

struct LetterView: View {
    @State private var currentLetterIndex = 0
    @State private var drawnText: String = ""
    @State private var showAlert = false
    @State private var isCompleted = false
    
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(hex: "#ffffff")
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack(spacing: 50) {
                            Image(String(letters[currentLetterIndex])) // Placeholder for letter image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.33, height: geometry.size.height * 0.5)
                            
                            ZStack {
                                Image("canvas")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                                    .offset(y: geometry.size.width * -0.06)
                                    
                                    ScribbleTextField(text: $drawnText, correctLetter: String(letters[currentLetterIndex]), onComplete: completeTracing)
                                        .frame(width: geometry.size.width * 0.33, height: geometry.size.height * 0.275)
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 3) // Visible outline
                                        )
                                        .offset(x: geometry.size.width * -0.01, y: geometry.size.width * 0.05)
                            }
                        }
                        .offset(y: geometry.size.width * 0.1)
                        
                        Image("grass") // Placeholder for letter image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.25)
                            .offset(y: geometry.size.width * 0.13)
                        
                        
                    }
                    
                    if isCompleted {
                        Text("🎉 Well Done! 🎉")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .transition(.scale)
                            .animation(.spring(), value: isCompleted)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Incorrect!"),
                          message: Text("Try again."),
                          dismissButton: .default(Text("OK")))
                }
            }
        }
        .onAppear {
            // Lock orientation to portrait when HomeView appears
            AppDelegate.lockOrientation(.landscape)
        }
        .onDisappear {
            // Unlock orientation when navigating away from HomeView
            AppDelegate.unlockOrientation()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func previousLetter() {
        if currentLetterIndex > 0 {
            currentLetterIndex -= 1
            resetText()
        }
    }
    
    func nextLetter() {
        if !isCompleted {
            showAlert = true
        } else if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
            resetText()
        }
    }
    
    func resetText() {
        drawnText = ""
        isCompleted = false
    }
    
    func completeTracing() {
        isCompleted = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

// 📌 **Custom ScribbleTextField for Apple Scribble**
struct ScribbleTextField: UIViewRepresentable {
    @Binding var text: String
    let correctLetter: String
    let onComplete: () -> Void

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()

        // 🔹 Basic Configurations
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        textField.textColor = .black
        textField.tintColor = .clear // Hide cursor

        // 🔹 Disable Keyboard
        textField.inputView = UIView()

        // 🔹 Disable System Toolbars (Copy, Paste, etc.)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.smartQuotesType = .no
        textField.smartDashesType = .no
        textField.smartInsertDeleteType = .no

        // 🔹 Prevent Selection, Cut, Copy, Paste
        textField.isUserInteractionEnabled = true
        textField.addGestureRecognizer(UILongPressGestureRecognizer(target: nil, action: nil)) // Disable long-press
        textField.delegate = context.coordinator

        // 🟢 Force Scribble Activation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            textField.becomeFirstResponder()
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if !uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder() // Ensure it stays focused
            }
        }
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: ScribbleTextField

        init(_ parent: ScribbleTextField) {
            self.parent = parent
        }

        @objc func textDidChange(_ textField: UITextField) {
            DispatchQueue.main.async {
                let detectedText = textField.text ?? ""
                self.parent.text = detectedText
                print("Detected: \(detectedText)") // Debugging output

                if detectedText.count >= 1 {
                    // 🕒 Delay recognition by 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.validateInput(detectedText)
                    }
                }
            }
        }

        func validateInput(_ input: String) {
            let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if trimmedInput == parent.correctLetter.uppercased() {
                parent.onComplete()
            }
        }

        // 🔹 Allow the Field to be Focused
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return true // 🟢 Enable focus for Scribble input
        }
    }
}

// 📌 **Color Extension**
extension Color {
    func toUIColor() -> UIColor {
        return UIColor(self)
    }
}

#Preview {
    LetterView()
}

