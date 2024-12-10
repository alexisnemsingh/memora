//
//  LandingPageView.swift
//  Memora
//
//  Created by Bryant Martinez on 12/9/24.
//

import SwiftUI

struct LandingPageView: View {
    @State private var isInfoSheetPresented = false // State to track if the Info sheet is shown
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    Text("Memora")
                        .font(.custom("AvenirNext-Bold", size: 50))
                        .foregroundColor(.black)
                        .padding(.top, 50)
                    
                    Image(.memora3) // Replace "logoName" with your image name from assets
                        .resizable() // Make the image resizable
                        .scaledToFit() // Maintain aspect ratio while fitting the container
                        .frame(width: 450, height: 500) // Adjust size as necessary
                        .padding(.top, 20) // Add some space at the top
                    
                    Spacer()
                    
                    // NavigationLink that navigates to the main content when the "Let's Learn" button is pressed
                    NavigationLink(destination: ContentView()) {
                        Text("Let's Learn")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20) // Spacing between buttons
                    
                    // "Info!" button that shows a sheet with creator details
                    Button(action: {
                        isInfoSheetPresented.toggle() // Toggle the state to show the sheet
                    }) {
                        Text("Info!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50) // Padding for the info button
                    
                }
            }
            .sheet(isPresented: $isInfoSheetPresented) {
                InfoView()
            }
        }
    }
}

