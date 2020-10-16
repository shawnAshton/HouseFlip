//
//  House.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 9/28/20.
//

import Foundation
import Firebase

protocol documentSerializable {
    init?(dictionary:[String:Any])
}

struct House {
    var id:String
    var address:String
    var owner:String
    var price:String
    //var purchaseDateAsTimeStamp:Date
    var purchaseDate:Timestamp
    var houseNotes:String
    var category:Int
    
    var dictionary:[String:Any]{
        return [
            "id": id,
            "address": address,
            "owner": owner,
            "price": price,
            "purchaseDate" : purchaseDate,
            "houseNotes" : houseNotes,
            "category": category
        ]
    }
}

extension House:documentSerializable{
    init?(dictionary:[String:Any]){
        guard let id = dictionary["id"] as? String,
              let address = dictionary["address"] as? String,
              let owner = dictionary["owner"] as? String,
              let price = dictionary["price"] as? String,
              let purchaseDate = dictionary["purchaseDate"] as? Timestamp,
              let houseNotes = dictionary["houseNotes"] as? String,
              let category = dictionary["category"] as? Int
            else {return nil}
        
        self.init(id:id, address:address, owner:owner, price:price, purchaseDate:purchaseDate, houseNotes:houseNotes, category:category)
    }
}
