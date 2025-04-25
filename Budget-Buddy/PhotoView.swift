//
//  PhotoView.swift
//  Places-Firebase
//
//  Created by Maureen Fox on 4/22/25.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @Binding var item: Item // passed in froom SpotDetailView
    @State private var photo = Photo()
    @State private var data = Data() // We need to take image & convert it to data to save it
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            TextField("description", text: $photo.description)
                .textFieldStyle(.roundedBorder)
            
            Text("by: \(photo.reviewer), on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                                           Button("Save") {
                                               Task {
                                                   item.imageURL = await ItemViewModel.saveImage(item: item, photo: photo, data: data)
                                                   dismiss()
                                               }
                                           }
                                       }
                                   }
                                   .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                                   .onChange(of: selectedPhoto) {
                                       // turn selectedPhoto into a usable Image View
                                       Task {
                                           do {
                                               if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                                                   selectedImage = image
                                               }
                                               // Get raw data from image so we can save it to Firebase Storage
                                               guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                                   print("😡 ERROR: Could not convert data from selectedPhoto")
                                                   return
                                               }
                                               data = transferredData
                                           } catch {
                                               print("😡 ERROR: Could not create Image from selectedPhoto. \(error.localizedDescription)")
                                           }
                                       }
                                   }
                           }
                           .padding()
                       }
                   }
                    
                    
                    
                    
                    
#Preview {
    PhotoView(item: .constant(Item()))
}
