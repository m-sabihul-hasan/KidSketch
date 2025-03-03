//
//  LetterDrawView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 03/03/25.
//

import SwiftUI
import PencilKit

struct LetterDrawView: View {
    @State private var currentLetterIndex = 0
    @State private var canvasView = PKCanvasView()
    @State private var isCompleted = false
    @State private var showWellDone = false
    @State private var penColor: Color = .red
    @State private var brushThickness: CGFloat = 20

    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    // Dictionary defining required strokes for each letter
    let requiredStrokes: [Character: Int] = [
        "A": 3, "B": 2, "C": 1, "D": 2, "E": 4, "F": 3, "G": 2, "H": 3, "I": 3,
        "J": 1, "K": 3, "L": 2, "M": 4, "N": 3, "O": 1, "P": 2, "Q": 2, "R": 2,
        "S": 1, "T": 2, "U": 1, "V": 2, "W": 4, "X": 2, "Y": 3, "Z": 3
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(hex: "#ffffff").ignoresSafeArea()

                    VStack {
                        HStack {
                            Image(String(letters[currentLetterIndex])) // Placeholder for letter image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: geometry.size.width * 0.35)

                            ZStack {
                                Image("canvas")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: geometry.size.width * 0.55, maxHeight: geometry.size.height * 0.3)
                                    .offset(y: geometry.size.height * -0.1)

                                CanvasView(
                                    canvasView: $canvasView,
                                    penColor: penColor,
                                    brushThickness: brushThickness,
                                    onComplete: completeTracing,
                                    requiredStrokes: requiredStrokes[letters[currentLetterIndex], default: 2] // Default 2 strokes if missing
                                )
                                .frame(maxWidth: geometry.size.width * 0.34, maxHeight: geometry.size.height * 0.3)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.white)
                                        .shadow(radius: 10)
                                )
                                .offset(x: geometry.size.width * -0.01, y: geometry.size.height * 0.07)
                            }
                        }
                        .offset(y: geometry.size.height * -0.065)

                        HStack {
                            Text("Brush Size")
                            Slider(value: $brushThickness, in: 5...50)
                        }
                        .padding()

                        HStack {
                            Text("Color")
                            ColorPicker("Pick Color", selection: $penColor)
                        }
                        .padding()

                        Image("grass")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.33)
                            .offset(x: geometry.size.width * -0.05 ,y: geometry.size.height * -0.5)
                    }

                    if showWellDone {
                        VStack {
                            Text("🎉 Well Done! 🎉")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(.yellow)
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .cornerRadius(10)
                                .transition(.scale)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                nextLetter()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            AppDelegate.lockOrientation(.landscape)
        }
        .onDisappear {
            AppDelegate.unlockOrientation()
        }
        .navigationBarBackButtonHidden(true)
    }

    func nextLetter() {
        if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
            resetCanvas()
        }
        showWellDone = false
    }

    func resetCanvas() {
        canvasView.drawing = PKDrawing()
        isCompleted = false
    }

    func completeTracing() {
        isCompleted = true
        showWellDone = true
    }
}

// MARK: - Canvas View with Custom Strokes
struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var penColor: Color
    var brushThickness: CGFloat
    var onComplete: () -> Void
    var requiredStrokes: Int

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.isUserInteractionEnabled = true
        canvasView.backgroundColor = .clear

        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        }

        canvasView.tool = PKInkingTool(.marker, color: penColor.toUIColor(), width: brushThickness)
        canvasView.delegate = context.coordinator
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = PKInkingTool(.marker, color: penColor.toUIColor(), width: brushThickness)
        context.coordinator.requiredStrokes = requiredStrokes // Ensure stroke count updates dynamically
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, requiredStrokes: requiredStrokes)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView
        @Published var requiredStrokes: Int

        init(_ parent: CanvasView, requiredStrokes: Int) {
            self.parent = parent
            self.requiredStrokes = requiredStrokes
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            if checkCompletion(canvasView.drawing) {
                DispatchQueue.main.async {
                    self.parent.onComplete()
                }
            }
        }

        func checkCompletion(_ drawing: PKDrawing) -> Bool {
            return drawing.strokes.count >= requiredStrokes
        }
    }
}

// MARK: - Color Extension
extension Color {
    func toUIColor() -> UIColor {
        return UIColor(self)
    }
}

#Preview {
    LetterDrawView()
}
