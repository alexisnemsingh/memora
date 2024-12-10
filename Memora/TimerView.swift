//
//  TimerView.swift
//  Memora
//
//  Created by Brandy Nguyen on 12/9/24.
//

import SwiftUI
import UIKit

struct AlbumDetailView: View {
    @ObservedObject var manager: FlashcardManager
    let album: Album // Assuming you have an Album model

    var body: some View {
        NavigationView {
            VStack {
                // Other album details
                NavigationLink(destination: FlashcardReviewView(manager: manager, albumId: album.id)) {
                    Text("Start Review")
                        .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
