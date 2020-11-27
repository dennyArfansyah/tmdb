//
//  Movie.swift
//  TMDB
//
//  Created by Denny Arfansyah on 27/11/20.
//

struct Movies: Decodable {
    
    let total_results: Int?
    let page: Int?
    let total_pages: Int?
    let results: [Movie]?
    
}

struct Movie: Decodable {
    
    let video: Bool?
    let id: Int?
    let vote_count: Int?
    let release_date: String?
    let adult: Bool?
    let backdrop_path: String?
    let vote_average: Double?
    let genre_ids: [Int]?
    let overview: String?
    let original_language: String?
    let original_title: String?
    let poster_path: String?
    let title: String?
    let budget: Int?
    let tagline: String?
    let revenue: Int?
    let popularity: Double?
    
}
