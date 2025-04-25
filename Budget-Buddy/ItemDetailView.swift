//
//  ItemDetailView.swift
//  Budget-Buddy
//
//  Created by Maureen Fox on 4/24/25.
//

////
////  RoomateDetailView.swift
////  ToDoList
////
////  Created by Maureen Fox on 4/22/25.
////


import SwiftUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore // Might need Firebase?

struct ItemDetailView: View {
    @State var item: Item
    @Environment(\.dismiss) private var dismiss
    @State private var photoSheetIsPresented = false
    @State private var showingAlert = false // Alert user if they need to save Place before adding a Photo
    @State private var alertMessage = "Cannot add a Photo until you save the Place."
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Item Name:")
                    .bold()
                    .foregroundStyle(.accent)
                    .font(.title3)
                TextField("Item Name", text: $item.name)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.primary)
                    .font(.title3)
                Text("Price:")
                    .bold()
                    .foregroundStyle(.accent)
                    .font(.title3)
                HStack{
                    Text("$")
                        .font(.title3)
                    TextField("price", text: $item.price)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(.primary)
                        .font(.title3)
                }
                
                Text("Purchased By: ")
                    .foregroundStyle(.accent)
                    .bold()
                    .foregroundStyle(.primary)
                    .font(.title3)
                TextField("roommate", text: $item.roommate)
                    .textFieldStyle(.roundedBorder)
                    .pickerStyle(.palette)
                    .foregroundStyle(.primary)
                    .font(.title3)
                Text("VenmoHandle:")
                    .foregroundStyle(.accent)
                    .bold()
                    .foregroundStyle(.primary)
                    .font(.title3)
                TextField("venmoHandle", text: $item.venmoHandle)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.primary)
                    .font(.title3)
                Text("Reason for Purchase: ")
                    .foregroundStyle(.accent)
                    .bold()
                    .padding(.top)
                    .foregroundStyle(.primary)
                    .font(.title3)
                TextField("Notes", text: $item.notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.primary)
                    .font(.title3)
                    .listRowSeparator(.hidden)
                Spacer()
                DatePicker("Purchase Date:", selection: $item.purchaseDate)
                    .listRowSeparator(.hidden)
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .padding(.bottom)
                Toggle("Reimbursed?", isOn: $item.isReimbursed)
                    .padding(.top)
                    .listRowSeparator(.hidden)
                    .foregroundStyle(.accent)
    
                    .font(.title3)
                Button("Add Reciept") {
                    if item.id == nil { // Ask if you want to save
                        showingAlert.toggle()
                    } else { // Go right to PhotoView
                        photoSheetIsPresented.toggle()
                    }
                }
                .fullScreenCover(isPresented: $photoSheetIsPresented) {
                    PhotoView(item: $item)
                }
                // below is above Spacer() that is above "Add Photo" button
                if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                        .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                            .scaleEffect(4)
                            .tint(.accent)
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    }
                    .id(imageURL)  // This forces the view to recreate when imageURL changes
                }

            }
            .padding(.horizontal)
            .font(.title)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            let id = await ItemViewModel.saveItem(item: item)
                            dismiss()
                        }
                    }
                }
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    // We want to return place.id after saving a new Place. Right now it's nil
                    Task {
                        guard let id = await ItemViewModel.saveItem(item: item) else {
                            print("😡 ERROR: Saving spot in alert returned nil")
                            return
                        }
                        item.id = id
                        print(item)
                        photoSheetIsPresented.toggle() // Now open sheet & move to PhotoView
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(item: Item(id: "02341", name: "Toilet Paper", venmoHandle: "Maureenfox2", imageURL: "http: ", price: "34.34", isReimbursed: true, notes: "For toilet paper", purchaseDate: Date.now + 60*60*24, roommate: "Maureen"))
       }
}
