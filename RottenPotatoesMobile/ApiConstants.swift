//
//  ApiConstants.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-15.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import Foundation

struct ApiConstants {
    
    static let API_KEY = "" // not committing my api key
    static let MAX_TOTAL_PAGES = 2
    static let MAX_TABLE_ROWS = 20 * MAX_TOTAL_PAGES
    
    static let baseUrl = "https://api.themoviedb.org/3"
    static let baseUrlImage = "https://image.tmdb.org/t/p/"
    
    static let discover = "/discover/movie"
    static let genres = "/genre/movie/list"
    static let popularMovies = "/movie/popular"
    static let nowPlaying = "/movie/now_playing"
    static let topRated = "/movie/top_rated"
    static let popularPeople = "/person/popular"
    
    enum posterSize: String {
        case xsmall = "w92"
        case small = "w154"
        case medium = "w185"
        case large = "w342"
        case big = "w500"
        case xbig = "w780"
    }
    
}
