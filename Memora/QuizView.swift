//
//  QuizView.swift
//  Memora
//
//  Created by Angel Lyn Cervantes on 12/8/24.
//

import SwiftUI

struct QuizView: View {
    @ObservedObject var manager: FlashcardManager
    var albumId: UUID
    var cardId: Int
    var count: Int

    @State private var degree = 0.0
    @State private var isBack = false
    @State private var answerText = ""
    @State private var showAnswerSheet = false

    @State private var cardData: Flashcard?

    init(manager: FlashcardManager, albumId: UUID, cardId: Int, count: Int) {
        self.manager = manager
        self.albumId = albumId
        self.cardId = cardId
        self.count = count
        
        // initialize cardData
        guard let album = manager.albums.first(where: { $0.id == albumId }), cardId < album.flashcards.count else {
            fatalError("Card or album not found")
        }
        _cardData = State(initialValue: album.flashcards[cardId])
    }

    var body: some View {
    if let cardData = cardData {
            ZStack {
                if !isBack {
                    SideView(
                        title: "Card " + String(cardId + 1),
                        side: "Front",
                        sideText: cardData.question,
                        sideImage: cardData.frontImage
                    )
                    VStack {
                        Spacer()
                        TextField("Enter answer", text: $answerText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button(action: {
                            showAnswerSheet = true
                        }) {
                            Text("Submit Answer")
                        }.padding()
                    }
                } else {
                    SideView(
                        title: "Card " + String(cardId + 1),
                        side: "Back",
                        sideText: cardData.answer,
                        sideImage: cardData.backImage
                    )
                    VStack {
                        Spacer()
                        NavigationLink("Next Question", destination: {
                            QuizView(
                                manager: manager,
                                albumId: albumId,
                                cardId: (cardId + 1) % count, // Wrap-around for cards
                                count: count
                            )
                        }).padding()
                    }
                }
            }
            .frame(width: 400, height: 500)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .rotation3DEffect(
                .degrees(degree),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.easeInOut(duration: 1), value: degree)
            .sheet(isPresented: $showAnswerSheet) {
                // Answer Submission Action
                VStack {
                    Text("Correct Answer:" + cardData.answer)
                        .font(.headline)
                        .padding()
                    Button("Flip to Back") {
                        withAnimation(.spring()) {
                            degree += 360
                            isBack.toggle()
                        }
                        showAnswerSheet = false
                    }
                }
            }
        } else {
            Text("Card not found")
                .font(.title)
                .foregroundColor(.red)
        }
    }
}

struct SideView: View {
    var title: String
    var side: String
    var sideText: String
    var sideImage: Data?
    
    
    var body: some View {
        VStack {
            if side == "Front" {
                Text(title + " Question")
                    .font(.largeTitle)
                    .padding(.top, 50)
            } else {
                Text(title + " Answer")
                    .font(.largeTitle)
                    .padding(.top, 50)
            }
            
            if let imageData = sideImage, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            Text(sideText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
        }
    }
}
