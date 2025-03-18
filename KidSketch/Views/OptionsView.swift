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
                    Color(hex: "#ffffff")
                        .edgesIgnoringSafeArea(.all)
                    
                    Image("bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: 80)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer() // Push the rectangle to the bottom
                        Rectangle()
                            .fill(Color(hex: "#38bdff"))
                            .frame(height: 80) // Adjust height as needed
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    
                    VStack {
                        HStack {
                            
                            Spacer()
                            
                            Image("abc")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.3)
                                .offset(x: -40,
                                        y: -40)
                            
                            Spacer()
                            
                            Image("giraffe")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.2)
                                .offset(x: geometry.size.width * 0.03,
                                        y: geometry.size.height * 0.15)
                            
                            Spacer()
                        }
                        VStack(alignment: .leading){
                        
                            Text("Let's")
                                .font(.custom("Arial", size: 50))
                                .foregroundColor(Color(hex: "#ffffff"))
                            
                            Text("LEARN")
                                .font(.custom("Arial", size: 50))
                                .bold()
                                .foregroundColor(Color(hex: "#ffffff"))
                        }
                        .offset(x: -360, y: -10)
                        
                        Spacer()
                        
                        Image("kids")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.2)
                            .offset(x: geometry.size.width * -0.44,
                                    y: geometry.size.height * 0.02)
                        
                        VStack{
                            NavigationLink(destination:
                                            LetterMenuView()
                            )
                            {
                                Text("Letters")
                                    .font(.custom("Arial", size: 30))
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: geometry.size.width * 0.3, maxHeight: geometry.size.height * 0.06)
                                    .background(Color(hex: "#ffe500"))
                                    .foregroundColor(.black)
                                    .cornerRadius(30)
                                    .offset(y: geometry.size.height * -0.02)
                            }
                            
                            
                        }
                        .offset(y: geometry.size.height * -0.08)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OptionsView()
}
