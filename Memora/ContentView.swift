import SwiftUI

struct ContentView: View {
    @State private var isAddCardSheetPresented = false
    @State private var isAddAlbumSheetPresented = false
    @State private var showAlert = false
    @State private var albumToDelete: Album?
    @StateObject private var manager = FlashcardManager()
    
    var body: some View {
        VStack {
            Text("Memora")
                .font(.largeTitle)
                .padding(.top, 50)
            
            Spacer()
            
            VStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        isAddAlbumSheetPresented = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                    }
                    Text("Create Flashcard Set")
                        .font(.title3)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
            
            Spacer()
            
            List {
                ForEach(manager.albums) { album in
                    HStack {
                        Text(album.title)
                        Spacer()
                        Button(action: {
                            albumToDelete = album
                            showAlert = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $isAddAlbumSheetPresented) {
            CreateAlbumView(manager: manager)
        }
        .sheet(isPresented: $isAddCardSheetPresented) {
            CreateFlashcardView(manager: manager, albumId: manager.albums[0].id)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete Album"),
                message: Text("Are you sure you want to delete this album?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let album = albumToDelete {
                        manager.deleteAlbum(album)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    ContentView()
}
