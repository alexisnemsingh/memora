//
//  ContentView.swift
//  Memora
//
//  Created by Alexis Nemsingh on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // title
            Text("Memora")
                .font(.largeTitle)
                .padding(.top, 50)
            
            Spacer()
            
            // button that adds cards
            Button(action: {
                // adds cards
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            
            Text("Add Flashcards")
                .font(.title2)
                .padding(.top, 10)
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
