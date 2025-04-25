//
//  ItemListView.swift
//  Budget-Buddy
//
//  Created by Maureen Fox on 4/24/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct ItemListView: View {

    @FirestoreQuery(collectionPath: "items") var items: [Item]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
            NavigationStack {
                
                Text("Communal Puchases: ")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.bBblue)
                
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            ItemDetailView(item: item)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: item.isReimbursed ? "checkmark.rectangle" : "rectangle")
                                        .foregroundStyle(item.isReimbursed ? .bBgreen : .bBpink)
                                    Text(item.name)
                                        .font(.title)
                                        .foregroundStyle(item.isReimbursed ? .bBgreen : .bBpink)
                                    
                                }
                                HStack {
                                    Text("$\(item.price)")
                                        .font(.title3)
                                        .foregroundStyle(.secondary)
                                    Text(item.roommate)
                                        .font(.title3)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                ItemViewModel.deleteData(item: item)
                            }
                        }
                    }
                    
                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("🪵➡️ Log out successful!")
                                dismiss()
                            } catch {
                                print("😡 ERROR: Could not sign out!")
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    ItemDetailView(item: Item())
                }
            }
        
    }
}

            #Preview {
                ItemListView()
            }
