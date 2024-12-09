//
//  AlbumView.swift
//  Memora
//
//  Created by Angel Lyn Cervantes on 12/7/24.
//

import SwiftUI

struct AlbumView: View {
    @State private var isAddCardSheetPresented = false
    @State private var showAlert = false
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
            
            List {
                ForEach(manager.albums.first { $0.id == albumId }?.flashcards ?? []) { flashcard in
                    NavigationLink(destination: FlashcardView(flashcard: flashcard, manager: manager)) {
                        VStack(alignment: .leading) {
                            Text(flashcard.question)
                                .font(.headline)
                            Text(flashcard.answer)
                                .font(.subheadline)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                showAlert = true
            }) {
                Text("Delete Album")
                    .foregroundColor(.red)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Album"),
                    message: Text("Are you sure you want to delete this album?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let album = manager.albums.first(where: { $0.id == albumId }) {
                            manager.deleteAlbum(album)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .sheet(isPresented: $isAddCardSheetPresented) {
            CreateFlashcardView(manager: manager, albumId: albumId)
        }
    }
}
