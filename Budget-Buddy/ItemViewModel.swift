
import Foundation
import FirebaseFirestore
import FirebaseStorage

@Observable
class ItemViewModel {
static func saveItem(item: Item) async -> String? { // nil if effort failed, otherwise return place.id
        let db = Firestore.firestore()
        
        if let id = item.id { // if true the place exists
            do {
                try db.collection("items").document(id).setData(from: item)
                print("😎 Data updated successfully!")
                return id
            } catch {
                print("😡 Could not update data in 'items' \(error.localizedDescription)")
                return id
            }
        } else { // We need to add a new place & create a new id / document name
            do {
                let docRef = try db.collection("items").addDocument(from: item)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 Could not create a new place in 'items' \(error.localizedDescription)")
                return nil
            }
        }
    }
    static func deleteData(item: Item) {
        let db = Firestore.firestore()
        guard let id = item.id else {
            print("No item.id")
            return
        }
        
        Task {
            do {
                try await db.collection("items").document(id).delete()
            } catch {
                print("😡 ERROR: Could not delete document \(id). \(error.localizedDescription)")
            }
        }
    }
    
    static func saveImage(item: Item, photo: Photo, data: Data) async -> String? {
        guard let id = item.id else {
            print("😡 ERROR: Should never have been called without a valid item.id")
            return nil
        }
        
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = item.id // since we only have one image, use the place.id
        }
        metadata.contentType = "image/jpeg" // to view image in the browser from Firestore console
        let path = "\(id))" // id is the name of the place document (place.id). All photos for a place will be saved in a "folder" with its place document name.
        print("The path is: \(id)")
        do {
              let storageref = storage.child(path)
              let returnedMetaData = try await storageref.putDataAsync(data, metadata: metadata)
              print("😎 SAVED! \(returnedMetaData)")
              
              // get URL that we'll use to load the image
              guard let url = try? await storageref.downloadURL() else {
                  print("😡 ERROR: Could not get downloadURL")
                  return nil
              }
              var newItem = item
              newItem.imageURL = url.absoluteString
              print("newPlace.imageURL: \(newItem.imageURL ?? "")")
              
              // Now photo file is saved in Storage, save a Photo document to the place.id's "photos" collection
              let db = Firestore.firestore()
              do {
                  try db.collection("items").document(id).setData(from: newItem)
                  return newItem.imageURL
              } catch {
                  print("😡 ERROR: Could not update data in items/\(id). \(error.localizedDescription)")
                  return nil
              }
          } catch {
              print("😡 ERROR saving photo to Storage \(error.localizedDescription)")
              return nil
          }
      }
}
