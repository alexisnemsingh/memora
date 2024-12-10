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
    
    var body: some View {
        VStack {
            Text("Flashcard " + String(cardId))
                .font(.largeTitle)
                .padding(.top, 50)
        }
    }
}
