//
//  Genre.swift
//  TMDB
//
//  Created by Denny Arfansyah on 27/11/20.
//

import Foundation

struct Genres: Decodable {
    
    let genres: [Genre]?
    
}

struct Genre: Decodable {
    
    let id: Int?
    let name: String?
}
