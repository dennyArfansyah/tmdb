//
//  K.swift
//  TMDB
//
//  Created by Denny Arfansyah on 26/11/20.
//

import Foundation

struct K {
    
    static let baseUrl = "https://api.themoviedb.org/3"
    static let apiKey = "520609269154335cdfd2f418e3d8377f"
    static let genres = "/genre/movie/list"
    static let movies = "/discover/movie"
    static let movie = "/movie"
    static let reviews = "/review"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w500"
    
    struct Segue {
        static let listMoviewSegue = "ListMovieSegue"
        static let movieSegue = "MovieSegue"
        static let listReviewSegue = "ListReviewSegue"
    }
    
    static let generalErrorMessage = "Something problem occured. Please try again later"
    static let pullToRefreshMessage = "Pull to refresh"
    static let noInternetConnection = "No Internet connection"
    static let noRecordsFounds = "No records found"
    
    static let genresUrl = baseUrl + genres + "?api_key=" + apiKey
    static let moviesUrl = baseUrl + movies + "?api_key=" + apiKey + "&with_genres="
    static let movieUrl = baseUrl + movie
    
    
}
