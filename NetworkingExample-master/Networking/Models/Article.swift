//
//  Article.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 26/11/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Foundation
import ObjectMapper



struct Article : Mappable {
    var id : Int?
    var title : String?
    var image : String?
    var author : String?
    var categories : [Categories]?
    var datePublished : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {

        id <- map["id"]
        title <- map["title"]
        image <- map["image"]
        author <- map["author"]
        categories <- map["categories"]
        datePublished <- map["datePublished"]
        
    }
    
}


struct Categories : Mappable {
    var id : Int?
    var name : String?
    var parent_id : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        parent_id <- map["parent_id"]
    }
    
}
