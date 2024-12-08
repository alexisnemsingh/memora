//
//  CreateFlashcardView.swift
//  Memora
//
//  Created by Alexis Nemsingh on 12/8/24.
//

import SwiftUI
import PhotosUI

struct CreateFlashcardView: View {
    @ObservedObject var manager: FlashcardManager
    var albumId: UUID
    @Environment(\.dismiss) private var dismiss
    
    @State private var frontText = ""
    @State private var backText = ""
    @State private var frontImage: UIImage?
    @State private var backImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isFrontSide = true
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationStack {
            VStack {
                if isFrontSide {
                    // Front of Card View
                    VStack {
                        if let image = frontImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        }
                        
                        TextField("Enter Text", text: $frontText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                    Button("Next") {
                        isFrontSide = false
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(frontText.isEmpty)
                } else {
                    // Back of Card View
                    VStack {
                        if let image = backImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        }
                        
                        TextField("Enter Text", text: $backText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                    Button("Save Flashcard") {
                        let frontImageData = frontImage?.jpegData(compressionQuality: 0.8)
                        let backImageData = backImage?.jpegData(compressionQuality: 0.8)
                        manager.addFlashcard(to: albumId, question: frontText, answer: backText, frontImage: frontImageData, backImage: backImageData)
                        print(manager.albums[0].flashcards)
                        print("card saved")
                        
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle(isFrontSide ? "Front of Card" : "Back of Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Take Photo") {
                            sourceType = .camera
                            isImagePickerPresented = true
                        }
                        
                        Button("Choose from Library") {
                            sourceType = .photoLibrary
                            isImagePickerPresented = true
                        }
                    } label: {
                        Label("Add Image", systemImage: "camera.fill")
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: isFrontSide ? $frontImage : $backImage, sourceType: sourceType)
            }
        }
    }
}
