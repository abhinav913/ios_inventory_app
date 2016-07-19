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
    let price:Float!
    let category:String!
    let itemRef:FIRDatabaseReference?
    
    init(name:String, price:Float, category:String, key:String="") {
        self.key = key
        self.name = name
        self.price = price
        self.category = category
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
        
        if let itemPrice = snapshot.value!["price"] as? Float {
            self.price = itemPrice
        } else {
            self.price = nil
        }
        
        if let itemCategory = snapshot.value!["category"] as? String {
            self.category = itemCategory
        } else {
            self.category = ""
        }
        
    }
    
    func toAnyObject() -> AnyObject {
        return ["name":name, "price":price, "category":category]
    }
    
}