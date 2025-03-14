//
//  LaunchScreenView.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 12/03/25.
//

import SwiftUI

struct LaunchScreenView: View {
    // Control the giraffe’s vertical offset for the pop-up animation
    @State private var giraffeOffset: CGFloat = 500

    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Color(hex: "#38bdff")
                    .ignoresSafeArea()
                
                Image("clouds")
                    .resizable()
                    .scaledToFit()
                    .offset(x: -10, y: -200)
                
                Image("hellogiraffe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width)
                    .offset(y: giraffeOffset)
                    .onAppear {
                        // Animate the giraffe upward
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.5)) {
                            giraffeOffset = 120
                        }
                    }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
