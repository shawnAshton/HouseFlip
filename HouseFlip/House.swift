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
    
    var dictionary:[String:Any]{
        return [
            "id": id,
            "address": address,
            "owner": owner,
            "price": price
        ]
    }
}

extension House:documentSerializable{
    init?(dictionary:[String:Any]){
        guard let id = dictionary["id"] as? String,
              let address = dictionary["address"] as? String,
              let owner = dictionary["owner"] as? String,
              let price = dictionary["price"] as? String else {return nil}
        
        self.init(id:id, address:address, owner:owner, price:price)
    }
}
