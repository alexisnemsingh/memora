//
//  Timer.swift
//  Memora
//
//  Created by Brandy Nguyen on 12/9/24.
//

import SwiftUI

struct FlashcardReviewView: View {
    @ObservedObject var manager: FlashcardManager
    var albumId: UUID
    
    // Timer-related state variables
    @State private var selectedTimerDuration: Double = 30 // Default 30 seconds
    @State private var timeRemaining: Double = 30
    @State private var isTimerRunning = false
    @State private var showTimerSetup = true
    
    // Flashcard review states
    @State private var currentCardIndex = 0
    @State private var isCardFlipped = false
    
    // Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var currentFlashcards: [Flashcard] {
        manager.albums.first(where: { $0.id == albumId })?.flashcards ?? []
    }
    
    var body: some View {
        VStack {
            if showTimerSetup {
                // Timer Setup View
                timerSetupView
            } else {
                // Review View
                reviewView
            }
        }
        .navigationTitle("Flashcard Review")
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Timer finished
                    isTimerRunning = false
                    showTimerSetup = true
                }
            }
        }
    }
    
    var timerSetupView: some View {
        VStack {
            Text("Set Review Timer")
                .font(.title2)
                .padding()
            
            // Timer duration slider
            Text("Timer Duration: \(Int(selectedTimerDuration)) seconds")
            
            Slider(value: $selectedTimerDuration,
                   in: 10...300, // 10 seconds to 5 minutes
                   step: 5)
                .padding()
            
            Button("Start Review") {
                timeRemaining = selectedTimerDuration
                isTimerRunning = true
                showTimerSetup = false
                currentCardIndex = 0
            }
            .buttonStyle(.borderedProminent)
            .disabled(currentFlashcards.isEmpty)
        }
        .padding()
    }
    
    var reviewView: some View {
        VStack {
            // Timer Display
            Text("\(Int(timeRemaining)) seconds remaining")
                .font(.headline)
                .padding()
            
            // Progress Indicator
            Text("Card \(currentCardIndex + 1) of \(currentFlashcards.count)")
                .foregroundColor(.secondary)
            
            // Flashcard View
            if !currentFlashcards.isEmpty {
                let currentCard = currentFlashcards[currentCardIndex]
                
                VStack {
                    // Front of Card
                    if !isCardFlipped {
                        Text(currentCard.question)
                            .font(.title)
                            .padding()
                    }
                    // Back of Card
                    else {
                        Text(currentCard.answer)
                            .font(.title)
                            .padding()
                    }
                    
                    // Card Image (if exists)
                    if let imageData = isCardFlipped ? currentCard.backImage : currentCard.frontImage,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                }
                .frame(minHeight: 300)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .onTapGesture {
                    withAnimation {
                        isCardFlipped.toggle()
                    }
                }
                
                // Navigation Buttons
                HStack {
                    Button("Previous") {
                        if currentCardIndex > 0 {
                            currentCardIndex -= 1
                            isCardFlipped = false
                        }
                    }
                    .disabled(currentCardIndex == 0)
                    
                    Button("Next") {
                        if currentCardIndex < currentFlashcards.count - 1 {
                            currentCardIndex += 1
                            isCardFlipped = false
                        }
                    }
                    .disabled(currentCardIndex == currentFlashcards.count - 1)
                }
                .padding()
            } else {
                Text("No flashcards in this album")
            }
            
            // End Review Button
            Button("End Review") {
                showTimerSetup = true
                isTimerRunning = false
            }
            .foregroundColor(.red)
        }
        .padding()
    }
}
