//
//  Item.swift
//  Budget-Buddy
//
//  Created by Maureen Fox on 4/24/25.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth 
import FirebaseStorage

struct Item: Codable, Identifiable {
    @DocumentID var id: String?
    var name = ""
    var venmoHandle = ""
    var imageURL: String?
    var price = ""
    var isReimbursed = false
    var notes = ""
    var purchaseDate = Date.now + 60*60*24
    var roommate = ""
    var username: String = Auth.auth().currentUser?.email ?? ""
}
