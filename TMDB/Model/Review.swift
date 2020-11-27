//
//  Review.swift
//  TMDB
//
//  Created by Denny Arfansyah on 27/11/20.
//

struct Reviews: Decodable {
    
    let id: Int?
    let page: Int?
    let results: [Review]?
    let total_pages: Int?
    let total_results: Int?
    
}

struct Review: Decodable {
    
    let author: String?
    let author_details: Author?
    let content: String?
    let created_at: String?
    let id: String?
    let updated_at: String?
    let url: String?
    
}

struct Author: Decodable {
    
    let name: String?
    let username: String?
    let avatar_path: String?
    let rating: Int?
    
}
