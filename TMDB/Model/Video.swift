//
//  Video.swift
//  TMDB
//
//  Created by Denny Arfansyah on 27/11/20.
//

struct Videos: Decodable {
    
    let id: Int?
    let results: [Video]?
}

struct Video: Decodable {
    
    let id: String?
    let iso_639_1: String?
    let iso_3166_1: String?
    let key: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
    
}
