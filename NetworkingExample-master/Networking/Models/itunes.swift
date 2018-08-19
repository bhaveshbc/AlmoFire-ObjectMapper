//
//  itunes.swift
//  Networking
//
//  Created by Bhavesh Chaudhari on 16/08/18.
//  Copyright © 2018 Alaeddine Me. All rights reserved.
//

import Foundation


struct itunesFeed : Codable {
    
    let feed : Feed?
    
    enum CodingKeys: String, CodingKey {
        case feed = "feed"
    }
    
    
    
}

struct Feed : Codable {
    
    let author : Author?
    let copyright : String?
    let country : String?
    let icon : String?
    let id : String?
    let links : [Link]?
    let results : [ResultI]?
    let title : String?
    let updated : String?
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case copyright = "copyright"
        case country = "country"
        case icon = "icon"
        case id = "id"
        case links = "links"
        case results = "results"
        case title = "title"
        case updated = "updated"
    }
    
  
    
}


struct ResultI : Codable {
    
    let artistId : String?
    let artistName : String?
    let artistUrl : String?
    let artworkUrl100 : String?
    let copyright : String?
    let genres : [Genre]?
    let id : String?
    let kind : String?
    let name : String?
    let releaseDate : String?
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        case artistId = "artistId"
        case artistName = "artistName"
        case artistUrl = "artistUrl"
        case artworkUrl100 = "artworkUrl100"
        case copyright = "copyright"
        case genres = "genres"
        case id = "id"
        case kind = "kind"
        case name = "name"
        case releaseDate = "releaseDate"
        case url = "url"
    }
    
   
    
}


struct Genre : Codable {
    
    let genreId : String?
    let name : String?
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        case genreId = "genreId"
        case name = "name"
        case url = "url"
    }
    
   
    
}


struct Link : Codable {
    
    let alternate : String?
    let selfid : String?
    
    enum CodingKeys: String, CodingKey {
        case alternate = "alternate"
        case selfid = "self"
    }
}


struct Author : Codable {
    
    let name : String?
    let uri : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case uri = "uri"
    }
}

