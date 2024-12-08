//
//  CreateAlbumView.swift
//  Memora
//
//  Created by Alexis Nemsingh on 12/8/24.
//

import SwiftUI

struct CreateAlbumView: View {
    @ObservedObject var manager: FlashcardManager
    @Environment(\.dismiss) private var dismiss
    @State private var albumTitle = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter Album Title", text: $albumTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Save Album") {
                    manager.addAlbum(title: albumTitle)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(albumTitle.isEmpty)
            }
            .navigationTitle("Create Album")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

