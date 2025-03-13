////
////  HomeView.swift
////  KidSketch
////
////  Created by Muhammad Sabihul Hasan on 27/02/25.
////
//
//
//import SwiftUI
//
//struct HomeView: View {
//    var body: some View {
//        NavigationStack {
//            GeometryReader { geometry in
//                ZStack {
//                    Color(hex: "#38bdff")
//                        .edgesIgnoringSafeArea(.all)
//                    
//                    VStack {
//                        Spacer()
//                        
//                        Image("home")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
//                        
//                        Text("KidSketch")
//                            .font(.custom("Arial", size: 50))
//                            .bold()
//                            .foregroundColor(Color(hex: "#ffe500"))
//                        
//                        Text("APP")
//                            .font(.custom("Arial", size: 30))
//                            .bold()
//                            .foregroundColor(Color(hex: "#ffe500"))
//                        
//                        Spacer()
//                        
//                        NavigationLink(destination: LearnOptionsView()) {
//                            Text("Let’s Start")
//                                .font(.custom("Arial", size: 30))
//                                .fontWeight(.bold)
//                                .padding()
//                                .frame(maxWidth: 300, maxHeight: 70)
//                                .background(Color(hex: "#ffe500"))
//                                .foregroundColor(.black)
//                                .cornerRadius(30)
//                        }
//                        
//                        Spacer()
//                    }
//                }
//            }
//        }
//        .onAppear {
//            // Lock orientation to portrait when HomeView appears
//            AppDelegate.lockOrientation(.portrait)
//        }
//        .onDisappear {
//            // Unlock orientation when navigating away from HomeView
//            AppDelegate.unlockOrientation()
//        }
//    }
//    
//}
//
//#Preview {
//    HomeView()
//}
