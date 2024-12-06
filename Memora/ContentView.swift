import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var isAddCardSheetPresented = false
    
    var body: some View {
        VStack {
            Text("Memora")
                .font(.largeTitle)
                .padding(.top, 50)
            
            Spacer()
            
            Button(action: {
                isAddCardSheetPresented = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            
            Text("Add Flashcards")
                .font(.title2)
                .padding(.top, 10)
            
            Spacer()
        }
        .sheet(isPresented: $isAddCardSheetPresented) {
            CreateFlashcardView()
        }
    }
}

struct CreateFlashcardView: View {
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
                        // Save logic here
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

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    ContentView()
}
