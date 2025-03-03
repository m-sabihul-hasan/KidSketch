////
////  LetterDrawingView.swift
////  KidSketch
////
////  Created by Muhammad Sabihul Hasan on 03/03/25.
////
//
//import SwiftUI
//import PencilKit
//
//struct LetterDrawingView: View {
//    let correctLetter: String // Correct letter to validate
//    
//    @State private var drawnText: String = ""
//    @State private var showAlert = false
//    @State private var canvasView = PKCanvasView()
//    
//    var body: some View {
//        NavigationStack {
//            GeometryReader { geometry in
//                VStack {
//                    HStack {
//                        Image(correctLetter) // Placeholder for letter image
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.5)
//                        
//                        ZStack {
//                            Color.white
//                                .frame(width: 300, height: 200)
//                                .cornerRadius(10)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.gray, lineWidth: 3) // Visible outline
//                                )
//                                .overlay(
//                                    ScribbleTextField(text: $drawnText, onTextChange: checkLetter)
//                                        .frame(width: 280, height: 180)
//                                        .background(Color.white)
//                                )
//                        }
//                    }
//                    
//                    Button(action: {
//                        checkLetter(drawnText)
//                    }) {
//                        Text("Submit")
//                            .font(.title)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .alert(isPresented: $showAlert) {
//                        Alert(title: Text("Incorrect!"), message: Text("Try again."), dismissButton: .default(Text("OK")))
//                    }
//                }
//            }
//        }
//        .onAppear {
//            AppDelegate.lockOrientation(.landscape)
//        }
//        .onDisappear {
//            AppDelegate.unlockOrientation()
//        }
//    }
//    
//    func checkLetter(_ input: String) {
//        if input.trimmingCharacters(in: .whitespacesAndNewlines) == correctLetter {
//            print("Correct letter drawn!")
//            // Proceed to next step or unlock navigation
//        } else {
//            showAlert = true
//            drawnText = ""
//        }
//    }
//}
//
//// MARK: - Scribble Text Field
//struct ScribbleTextField: UIViewRepresentable {
//    @Binding var text: String
//    var onTextChange: (String) -> Void // Callback function for text validation
//    
//    func makeUIView(context: Context) -> UITextField {
//        let textField = UITextField()
//        textField.backgroundColor = .clear
//        textField.textAlignment = .center
//        textField.font = UIFont.systemFont(ofSize: 50)
//        textField.allowsEditingTextAttributes = true
//        textField.tintColor = .clear // Hide cursor
//        textField.inputView = UIView() // Disable keyboard
//        textField.delegate = context.coordinator
//        textField.becomeFirstResponder() // Activate Scribble
//        return textField
//    }
//    
//    func updateUIView(_ uiView: UITextField, context: Context) {
//        uiView.text = text
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, UITextFieldDelegate {
//        var parent: ScribbleTextField
//
//        init(_ parent: ScribbleTextField) {
//            self.parent = parent
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            // Ensure only a single character is allowed
//            guard string.count <= 1 else { return false }
//            
//            DispatchQueue.main.async {
//                self.parent.text = string.uppercased()
//                self.parent.onTextChange(self.parent.text) // Call validation function immediately
//            }
//            return false
//        }
//    }
//}
//
//#Preview {
//    LetterDrawingView(correctLetter: "A")
//}
