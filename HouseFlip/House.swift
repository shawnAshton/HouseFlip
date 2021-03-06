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
    //var purchaseDateAsTimeStamp:Date
    var purchaseDate:Timestamp
    var houseNotes:String
    var category:Int
    var arv:String
    var estimatedRepair:String
    var slider1:Float
    var slider2:Float
    
    
    var dictionary:[String:Any]{
        return [
            "id": id,
            "address": address,
            "purchaseDate" : purchaseDate,
            "houseNotes" : houseNotes,
            "category": category,
            "arv" : arv,
            "estimatedRepair" : estimatedRepair,
            "slider1" : slider1,
            "slider2" : slider2
        ]
    }
}

extension House:documentSerializable{
    init?(dictionary:[String:Any]){
        guard let id = dictionary["id"] as? String,
              let address = dictionary["address"] as? String,
              let purchaseDate = dictionary["purchaseDate"] as? Timestamp,
              let houseNotes = dictionary["houseNotes"] as? String,
              let category = dictionary["category"] as? Int
            else {return nil}
        let arv = dictionary["arv"] as? String ?? "0"
        let estimatedRepair = dictionary["estimatedRepair"] as? String ?? "0"
        let slider1 = dictionary["slider1"] as? Float ?? 0
        let slider2 = dictionary["slider2"] as? Float ?? 0
        
        self.init(id:id, address:address, purchaseDate:purchaseDate, houseNotes:houseNotes, category:category, arv:arv, estimatedRepair:estimatedRepair,
                  slider1:slider1, slider2:slider2)
    }
}
