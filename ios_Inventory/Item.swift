//
//  Item.swift
//  ios_Inventory
//
//  Created by Sohan Shah on 7/7/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import Foundation

class Item {
    var id:String
    var name:String
    var price:Double
    var quantity:Int
    var category:Int
    var notes:String
    
    init(id: String, name: String, price: Double, quantity:Int, category:Int, notes:String) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.category = category
        self.notes = notes
    }
    
    
}