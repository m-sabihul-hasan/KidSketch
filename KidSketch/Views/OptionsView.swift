//
//  OptionsView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 27/02/25.
//

import SwiftUI

struct OptionsView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // 1) White base + BG image
                    Color(hex: "#ffffff")
                        .ignoresSafeArea()

                    Image("bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                        .offset(y: -30)

                    ZStack {
                        Image("giraffewithletters")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.85)
                            .offset(x: -85, y: -30)

                        NavigationLink(destination: ContentView()) {
                            Text("Alphabets")
                                .font(.custom("Arial", size: 30))
                                .bold()
                                .padding(.horizontal, 40)
                                .padding(.vertical, 15)
                                .background(Color(hex: "#ffe500"))
                                .foregroundColor(.black)
                                .cornerRadius(30)

                        }
                        .offset(y: 120)
                    }
                    
                    VStack {
                        Spacer() // Push the rectangle to the bottom
                        Rectangle()
                            .fill(Color(hex: "#38bdff"))
                            .frame(height: 100) // Adjust height as needed
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OptionsView()
}
