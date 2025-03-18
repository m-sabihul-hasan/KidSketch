//
//  ProgressView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 14/03/25.
//

import SwiftUI

struct ProgressView: View {
    
    let letter: Character
    let totalAttempts: Int             // total attempts (correct + incorrect)
    let correctAttempts: Int
    let incorrectAttempts: Int
    let onDismiss: () -> Void
    let onGoToLetterMenu: () -> Void


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // EXAMPLE BACKGROUND
                Image("cloudy_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea()
                    .opacity(0.5)
                
                Image("grass")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.7,
                           height: geometry.size.height * 0.35)
                    .offset(x: -90, y: 400)
                
                Image("giraffe")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height)
                    .offset(x: 420, y: 120)
                
                HStack {
                    VStack(spacing: 20) {
                        // Title
                        VStack {
                            Text("Progress")
                                .font(.custom("Arial", size: 90))
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#38bdff"))
                                .shadow(color: Color.black.opacity(0.4), radius: 4, x: 2, y: 2)
                                .padding(.bottom, 3)
                            
                            Text("TRACKER")
                                .font(.custom("Arial", size: 40))
                                .foregroundColor(Color(hex: "#38bdff"))
                                .shadow(color: Color.black.opacity(0.4), radius: 3, x: 1, y: 1)
                                .padding(.bottom, 2)
                        }
                        .offset(x: geometry.size.height * 0.3, y: 10)
                        
                        // Show the stats
                        VStack(alignment: .leading) {
                            HStack {
                                Image("\(letter)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width * 0.015, height: geometry.size.height * 0.15)
                                
                                Image("giraffehead")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width * 0.06, height: geometry.size.height * 0.15)
                                    .padding(.horizontal, 20)
                                
                                Text("Total Attempts: ")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#38bdff"))
                                
                                ForEach(0..<totalAttempts, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding(.horizontal, 30)
                            
                            HStack {
                                Image("\(letter)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width * 0.015, height: geometry.size.height * 0.15)
                                
                                Image("giraffehead")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width * 0.06, height: geometry.size.height * 0.15)
                                    .padding(.horizontal, 20)
                                
                                Text("Correct Attempts: ")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#38bdff"))
                                
                                ForEach(0..<correctAttempts, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding(.horizontal, 30)

                            
                            HStack {
                                Image("\(letter)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width * 0.015, height: geometry.size.height * 0.15)
                                
                                Image("giraffehead")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width * 0.06, height: geometry.size.height * 0.15)
                                    .padding(.horizontal, 20)
                                
                                Text("Incorrect Attempts: ")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#38bdff"))
                                
                                ForEach(0..<incorrectAttempts, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding(.horizontal, 30)

                        }
                        .padding()
                        
                        Button(action: {
                            onDismiss()
                        }) {
                            Text("Continue")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 200, height: 50)
                                .background(Color(hex: "#38bdff"))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        .padding(.top, 20)
                        
                        Button(action: {
                            onGoToLetterMenu()
                        }) {
                            Text("Go to Letter Menu")
                                .font(.title2)
                                .bold()
                                .padding()
                                .frame(maxWidth: 250, maxHeight: 50)
                                .background(Color(hex: "#ff6f00"))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        .padding(.top, 20)

                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    ProgressView(
        letter: "A",
        totalAttempts: 5,
        correctAttempts: 3,
        incorrectAttempts: 2,
        onDismiss: {},
        onGoToLetterMenu: {}

    )
}
