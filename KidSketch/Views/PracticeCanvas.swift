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
        ZStack(alignment: .topLeading) {
            // Transparent color that captures touches
            Color.clear
                .contentShape(Rectangle())
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
                                print("[PracticeCanvas] Stroke ended. strokeCount = \(strokeCount)")

                                // If practice strokes are done, unlock final
                                if strokeCount == maxStrokes {
                                    onPracticeComplete()
                                }
                            }
                        }
                )

            // Draw each stroke
            ForEach(strokes, id: \.self) { stroke in
                Path { path in
                    if let firstPoint = stroke.first {
                        path.move(to: firstPoint)
                        for point in stroke.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                }
                // Customize color/width as needed
                .stroke(Color.red.opacity(0.7), lineWidth: 12)
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
}
