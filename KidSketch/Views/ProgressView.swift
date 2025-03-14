//
//  ProgressView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 14/03/25.
//

import SwiftUI

struct ProgressView: View {

    let uniqueCorrectLetters: Int      // number of unique letters the user got right
    let totalAttempts: Int             // total attempts (correct + incorrect)
    let correctAttempts: Int
    let incorrectAttempts: Int
    
    
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
                
                HStack{
                    
                    VStack(spacing: 20) {
                        // Title
                        VStack{
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
                            
                            HStack{
                                Image("progress")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                                
                                Text("Unique Correct Letters: ")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#38bdff"))
                                
                                ForEach(0..<uniqueCorrectLetters, id: \.self) { index in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            HStack{
                                Image("progress")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                                Text("Total Attempts: ")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#38bdff"))
                                
                                ForEach(0..<totalAttempts, id: \.self) { index in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            HStack{
                                Image("progress")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                                Text("Correct Attempts: ")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#38bdff"))
                                
                                ForEach(0..<correctAttempts, id: \.self) { index in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            HStack{
                                Image("progress")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                                Text("Incorrect Attempts: ")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#38bdff"))
                                
                                ForEach(0..<incorrectAttempts, id: \.self) { index in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ProgressView(
        uniqueCorrectLetters: 3,
        totalAttempts: 10,
        correctAttempts: 6,
        incorrectAttempts: 4
    )
}
