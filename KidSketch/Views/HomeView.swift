//
//  HomeView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 27/02/25.
//


import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(hex: "#38bdff")
                        .ignoresSafeArea()
                    
                    VStack{
                        Image("giraffewithkids")
                            .resizable()
                            .scaledToFit()
                        // Adjust width so image fills roughly half the screen
                            .frame(width: geometry.size.width * 0.6)
                                                
                        Text("Dot to Dot")
                            .font(.custom("Arial", size: 70))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#ffe500"))
                            .shadow(color: Color.black.opacity(0.4), radius: 4, x: 2, y: 2)
                            .padding(.bottom, 3)
                        
                        Text("APP")
                            .font(.custom("Arial", size: 40))
                            .foregroundColor(Color(hex: "#ffe500"))
                            .shadow(color: Color.black.opacity(0.4), radius: 3, x: 1, y: 1)
                            .padding(.bottom, 20)
                        
                        NavigationLink(destination: OptionsView()) {
                            Text("Let’s Start")
                                .font(.custom("Arial", size: 40))
                                .fontWeight(.bold)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                                .background(Color(hex: "#ffe500"))
                                .foregroundColor(.black)
                                .cornerRadius(50)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
