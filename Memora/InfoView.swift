//  InfoView.swift
//  Memora
//
//  Created by Bryant Martinez on 12/8/24.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss // Environment dismiss function to close the sheet
    
    var body: some View {
        VStack {
            Text("Creators of Memora")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("This application was created by:")
                .font(.title3)
                .foregroundColor(.gray)
                .padding(.bottom)

            Text("Alexis, Angel, Brandy, Bryant, and fill i the blank")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 20)

            Text("We hope you enjoy using Memora to manage your flashcards and learn effectively!")
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: {
                dismiss() // This will dismiss the sheet
            }) {
                Text("Close")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}


