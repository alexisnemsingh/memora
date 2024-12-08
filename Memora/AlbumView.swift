//
//  AlbumView.swift
//  Memora
//
//  Created by Angel Lyn Cervantes on 12/7/24.
//

// Not complete. Need to add flashcards

import SwiftUI

struct AlbumView: View {
    @State private var isAddCardSheetPresented = false
    @ObservedObject var manager: FlashcardManager
    var albumId: UUID
    
    
    var body: some View {
        VStack {
            Text("Viewing Album")
                .font(.largeTitle)
                .padding(.top, 50)
            
            Spacer()
            
            Button(action: {
                isAddCardSheetPresented = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            
            Text("Add Flashcards")
                .font(.title2)
                .padding(.top, 10)
            
            // List Flashcards
            
            Spacer()
        }
        .sheet(isPresented: $isAddCardSheetPresented) {
            CreateFlashcardView(manager: manager, albumId: albumId)
        }
    }
}
