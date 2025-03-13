//
//  PracticeCanvas.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 13/03/25.
//

import SwiftUI

struct PracticeCanvas: View {
    @Binding var strokeCount: Int
    let maxStrokes: Int
    @Binding var resetCanvasTrigger: Bool

    let onPracticeComplete: () -> Void

    @State private var strokes: [[CGPoint]] = [[]]

    var body: some View {
        // 1) Make sure we have a known frame for the entire canvas
        //    so the user can draw anywhere inside
        ZStack(alignment: .topLeading) {
            // 2) Transparent color that captures touches
            Color.clear
                .contentShape(Rectangle()) // So the gesture knows the shape
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
                                print("[PracticeCanvas] stroke ended. strokeCount = \(strokeCount)")

                                if strokeCount == maxStrokes {
                                    onPracticeComplete()
                                }
                            }
                        }
                )

            // 3) Draw each stroke
            ForEach(strokes, id: \.self) { stroke in
                Path { path in
                    if let firstPoint = stroke.first {
                        path.move(to: firstPoint)
                        for point in stroke.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.red.opacity(0.7), lineWidth: 12)
            }
        }
        .onChange(of: resetCanvasTrigger) {
            if resetCanvasTrigger {
                print("[DrawingCanvas] resetCanvasTrigger → clearing strokes.")
                strokes = [[]]
            }
        }
    }
}
