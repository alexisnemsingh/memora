import SwiftUI

struct ContentView: View {
    @State private var isAddAlbumSheetPresented = false
    @StateObject private var manager = FlashcardManager()
    
    var body: some View {
        NavigationView {
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
                        NavigationLink(destination: AlbumView(manager: manager, albumId: album.id)) {
                            HStack {
                                Text(album.title)
                                Spacer()
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .sheet(isPresented: $isAddAlbumSheetPresented) {
                CreateAlbumView(manager: manager)
            }
        }
    }
}

#Preview {
    ContentView()
}
