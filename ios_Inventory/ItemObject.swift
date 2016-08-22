//
//  ItemObject.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/9/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Item {
    let key:String!
    let name:String!
    var price:Double!
    var category:String!
    var notes:String!
    var quantity:Int!
    var time:Double!
    let itemRef:FIRDatabaseReference?
    
    init(name:String, price:Double, category:String, notes:String, quantity:Int, time:Double, key:String="") {
        self.key = key
        self.name = name
        self.price = price
        self.category = category
        self.notes = notes
        self.quantity = quantity
        self.time = time
        self.itemRef = nil
    }
    
    init(snapshot:FIRDataSnapshot) {
        self.key = snapshot.key
        self.itemRef = snapshot.ref
        
        if let itemName = snapshot.value!["name"] as? String {
            self.name = itemName
        } else {
            self.name = ""
        }
        
        if let itemPrice = snapshot.value!["price"] as? Double {
            self.price = itemPrice
        } else {
            self.price = nil
        }
        
        if let itemCategory = snapshot.value!["category"] as? String {
            self.category = itemCategory
        } else {
            self.category = ""
        }
        
        if let itemNotes = snapshot.value!["notes"] as? String {
            self.notes = itemNotes
        } else {
            self.notes = nil
        }
        
        if let itemQuantity = snapshot.value!["quantity"] as? Int {
            self.quantity = itemQuantity
        } else {
            self.quantity = nil
        }
        
        if let itemTime = snapshot.value!["time"] as? Double {
            self.time = itemTime
        } else {
            self.time = nil
        }
        
    }
    
    func toAnyObject() -> AnyObject {
        return ["name":name, "price":price, "category":category, "notes":notes, "quantity":quantity, "time":time]
    }

}