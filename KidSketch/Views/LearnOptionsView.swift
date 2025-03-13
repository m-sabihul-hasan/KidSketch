////
////  LearnOptionsView.swift
////  KidSketch
////
////  Created by Muhammad Sabihul Hasan on 27/02/25.
////
//
//import SwiftUI
//
//struct LearnOptionsView: View {
//    var body: some View {
//        NavigationStack {
//            GeometryReader { geometry in
//                ZStack {
//                    Color(hex: "#ffffff")
//                        .edgesIgnoringSafeArea(.all)
//                    
//                    Image("bg")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geometry.size.width, height: geometry.size.height)
//                        .edgesIgnoringSafeArea(.all)
//                    
//                    VStack {
//                        
//                        HStack {
//                            Spacer()
//                            
//                            Image("abc")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
//                                .offset(x: geometry.size.width * -0.05,
//                                        y: geometry.size.height * -0.03)
//                            
//                            
//                            Image("giraffe")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
//                                .offset(x: geometry.size.width * 0.03,
//                                        y: geometry.size.height * 0.08)
//                            
//                            Spacer()
//                        }
//                        
//                        VStack
//                        {
//                            HStack
//                            {
//                                Text("Let's")
//                                    .font(.custom("Arial", size: 50))
//                                    .bold()
//                                    .foregroundColor(Color(hex: "#ffffff"))
//                                
//                                Spacer()
//                                
//                            }
//                            HStack
//                            {
//                                
//                                Text("LEARN")
//                                    .font(.custom("Arial", size: 50))
//                                    .bold()
//                                    .foregroundColor(Color(hex: "#ffffff"))
//                                Spacer()
//                                
//                            }
//                        }
//                        .offset(x: geometry.size.width * 0.03,
//                                y: geometry.size.height * 0.07)
//                        
//                        Spacer()
//                        
//                        Image("kids")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
//                            .offset(x: geometry.size.width * -0.425,
//                                    y: geometry.size.height * 0.1)
//                        
//                        VStack{
//                            NavigationLink(destination:
//                                            LetterDrawView()
//                            )
//                            {
//                                Text("Letters")
//                                    .font(.custom("Arial", size: 30))
//                                    .bold()
//                                    .padding()
//                                    .frame(maxWidth: geometry.size.width * 0.3, maxHeight: geometry.size.height * 0.06)
//                                    .background(Color(hex: "#ffe500"))
//                                    .foregroundColor(.black)
//                                    .cornerRadius(30)
//                                    .offset(y: geometry.size.height * -0.02)
//                            }
//                            
////                            NavigationLink(destination: ContentView()) {
////                                Text("Numbers")
////                                    .font(.custom("Arial", size: 30))
////                                    .bold()
////                                    .padding()
////                                    .frame(maxWidth: geometry.size.width * 0.3, maxHeight: geometry.size.height * 0.06)
////                                    .background(Color(hex: "#ffe500"))
////                                    .foregroundColor(.black)
////                                    .cornerRadius(30)
////                                    .offset(y: geometry.size.height * 0.02)
////                            }
//                        }
//                        .offset(y: geometry.size.height * -0.08)
//                        
//                        Spacer()
//                    }
//                }
//            }
//            .onAppear {
//                AppDelegate.lockOrientation(.portrait)
//            }
//            .onDisappear {
//                AppDelegate.unlockOrientation()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//#Preview {
//    LearnOptionsView()
//}
