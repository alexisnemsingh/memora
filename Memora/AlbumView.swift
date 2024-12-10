//
//  AlbumView.swift
//  Memora
//
//  Created by Angel Lyn Cervantes on 12/7/24.
//

import SwiftUI

struct AlbumView: View {
    @State private var isAddCardSheetPresented = false
    @State private var showQuizAlert = false
    @State private var showDeleteAlert = false
    @State private var isQuizActivated = false
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
            
            NavigationLink(destination: FlashcardReviewView(manager: manager, albumId: albumId))
            {
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Start Timed Review")
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(manager.albums.first { $0.id == albumId }?.flashcards.isEmpty ?? true)
            .padding(.bottom)
            
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
            
            HStack {
                Spacer()
                
                if (manager.albums.first { $0.id == albumId }?.flashcards != nil && manager.albums.first { $0.id == albumId }?.flashcards.count != 0) {
                    NavigationLink(
                        "Quiz Me!",
                        destination:
                            QuizView(
                                manager: manager,
                                albumId: albumId,
                                cardId: 0,
                                count: manager.albums.first { $0.id == albumId }!.flashcards.count)
                    )
                } else {
                    Button(action: {
                        showQuizAlert = true
                    }) {
                        Text("Quiz Me")
                            .foregroundColor(.black)
                    }
                    .alert(isPresented: $showQuizAlert) {
                        Alert(
                            title: Text("No Flashcards"),
                            message: Text("You cannot run a quiz. There are no flashcards in this album.")
                        )
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Text("Delete Album")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showDeleteAlert) {
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
                
                Spacer()
                
            }
            
        }
        .sheet(isPresented: $isAddCardSheetPresented) {
            CreateFlashcardView(manager: manager, albumId: albumId)
        }
        .sheet(isPresented: $isQuizActivated) {
            if (manager.albums.first { $0.id == albumId }?.flashcards.count ?? 0 ) > 0 {
                
            }
        }
    }
}
