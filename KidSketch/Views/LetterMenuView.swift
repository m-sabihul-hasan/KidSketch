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

    var onLetterSelected: ((Character) -> Void)?

    var body: some View {
        NavigationStack {
            ZStack {
                VStack
                {
                    Spacer()
                    Rectangle()
                        .fill(Color(hex: "#38bdff"))
                        .frame(height: 80) // Adjust height as needed
                }
                .ignoresSafeArea()

                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 7) {
                        ForEach(letters, id: \.self) { letter in
                            Button(action: {
                                selectedLetter = letter
                                navigateToContent = true
                                onLetterSelected?(letter)
                            }) {
                                ZStack {
                                    Image("\(letter)")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .padding(.vertical, 25)
//                                        .border(Color.black, width: 2)
                                    
                                    if selectedLetter == letter {
                                        Color.yellow.opacity(0.8) // Highlight selected letter
                                            .frame(width: 75, height: 70)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .offset(y: -25)
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $navigateToContent) {
                if let selectedLetter = selectedLetter {
                    ContentView(selectedLetter: selectedLetter) // Pass selected letter
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LetterMenuView { selectedLetter in
        print("Selected Letter: \(selectedLetter)")
    }
}
