//
//  FlashCardView.swift
//  Memora
//
//  Created by Alexis Nemsingh on 12/8/24.
//

import SwiftUI

struct FlashcardView: View {
    var flashcard: Flashcard
    @ObservedObject var manager: FlashcardManager
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            if let frontImageData = flashcard.frontImage, let frontImage = UIImage(data: frontImageData) {
                Image(uiImage: frontImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            Text(flashcard.question)
                .font(.headline)
                .padding()
            
            if let backImageData = flashcard.backImage, let backImage = UIImage(data: backImageData) {
                Image(uiImage: backImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            Text(flashcard.answer)
                .font(.subheadline)
                .padding()
            
            Spacer()
            
            Button(action: {
                showAlert = true
            }) {
                Text("Delete Flashcard")
                    .foregroundColor(.red)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Flashcard"),
                    message: Text("Are you sure you want to delete this flashcard?"),
                    primaryButton: .destructive(Text("Delete")) {
                        manager.deleteFlashcard(flashcard)
                        dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationTitle("Flashcard")
        .navigationBarTitleDisplayMode(.inline)
    }
}
