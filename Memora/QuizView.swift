//
//  QuizView.swift
//  Memora
//
//  Created by Angel Lyn Cervantes on 12/8/24.
//  Updated by Bryant Martinez For Color And Dark Mode on 12/9/24
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
    @EnvironmentObject var themeManager: ThemeManager // Access global dark mode state

    var body: some View {
        // Fetch the correct flashcard
        if let album = manager.albums.first(where: { $0.id == albumId }),
           cardId < album.flashcards.count {
            let cardData = album.flashcards[cardId]

            ZStack {
                // Background color based on dark mode
                (themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                    .ignoresSafeArea()

                VStack {
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
                        if cardId != count - 1 {
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
                        } else {
                            VStack {
                                Spacer()
                                NavigationLink("Return Home", destination: {
                                    AlbumView(manager: manager, albumId: albumId)
                                }).padding()
                            }
                        }
                    }
                }
                .frame(width: 400, height: 500)
                .background(
                    themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.white // Background color
                )
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
                        if answerText == cardData.answer {
                            Text("Correct!")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .foregroundColor(.green)
                        } else {
                            Text("Wrong!")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .foregroundColor(.red)
                        }
                        Text("Correct Answer: " + cardData.answer)
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(answerText == cardData.answer ? Color.green.opacity(0.2) : Color.red.opacity(0.2)) // Background change based on correctness
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
    @EnvironmentObject var themeManager: ThemeManager // Access global dark mode state

    var body: some View {
        VStack {
            if side == "Front" {
                Text(title + " Question")
                    .font(.largeTitle)
                    .padding(.top, 50)
                    .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Title color based on dark mode
            } else {
                Text(title + " Answer")
                    .font(.largeTitle)
                    .padding(.top, 50)
                    .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Title color based on dark mode
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
                .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Text color based on dark mode

            Spacer()
        }
        .background(themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white) // Background color based on dark mode
    }
}
