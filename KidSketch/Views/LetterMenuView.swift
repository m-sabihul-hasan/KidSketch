//
//  LetterMenuView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 18/03/25.
//


import SwiftUI

struct LetterMenuView: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    @State private var selectedLetter: Character? // Track selected letter
    @State private var navigateToContent = false // Controls navigation

    var body: some View {
        NavigationStack {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                    ForEach(letters, id: \.self) { letter in
                        Button(action: {
                            selectedLetter = letter
                            navigateToContent = true
                        }) {
                            ZStack {
                                Image("\(letter)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .padding(.vertical, 25)
                                    .border(Color.black, width: 2)

                                // Highlight selected letter
                                if selectedLetter == letter {
                                    Color.black.opacity(0.3) // Dim overlay
                                        .frame(width: 75, height: 70)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button styles
                    }
                }
                .padding()

                Spacer()

                Rectangle()
                    .fill(Color(hex: "#38bdff"))
                    .frame(height: 80) // Adjust height as needed
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $navigateToContent) {
                if let selectedLetter = selectedLetter {
                    ContentView(selectedLetter: selectedLetter) // ✅ Pass selected letter correctly
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    LetterMenuView()
}
