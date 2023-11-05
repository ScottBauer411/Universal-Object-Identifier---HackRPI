//
//  ContentView.swift
//  HackRPI
//
//  Created by Scott Bauer on 11/4/23.
//


import SwiftUI

struct ContentView: View {
    
    @State var image: Image? = nil
    @State var showCaptureImageView = false
    @State var classification = ""
    @State var isLoading = false
    @State var scaleEffect: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                // Centered Top Bar
                Text("Plant Classifier")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.white)
                    .padding(.top, 20)
                
                Spacer()
                
                // Image or Placeholder
                if let img = image {
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fill) // Make the image fill the circle
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10 * scaleEffect)
                        .transition(.slide)
                        .animation(.easeIn(duration: 0.5))
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                            withAnimation {
                                scaleEffect = pressing ? 1.1 : 1.0
                            }
                        }, perform: {})
                } else {
                    // Image Placeholder
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 250, height: 250)
                        .foregroundColor(Color("Placeholder"))
                        .overlay(
                            Text("No Image")
                                .foregroundColor(.gray)
                                .font(.headline)
                        )
                        .transition(.slide)
                        .animation(.easeIn(duration: 0.5))
                }
                
                Spacer()
                
                // Classification Result with Flashing Animation
                if !classification.isEmpty {
                    Text("It looks like a \(classification)!")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                        .transition(AnyTransition.opacity.animation(Animation.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true)))
                }
                
                // Choose Photo Button with Icon
                Button(action: {
                    withAnimation {
                        showCaptureImageView.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Choose a photo")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(8)
                }
                
                Spacer(minLength: 20)
                
            }.padding()
            
            if (showCaptureImageView) {
                CaptureImageView(isShown: $showCaptureImageView, image: $image, classification: $classification)
            }
            
            // Overlay for Loading State
            if isLoading {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Analyzing...")
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                .background(Color.white)
                .cornerRadius(15)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
