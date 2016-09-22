//
//  Film.swift
//  Phim24h
//
//  Created by Chung on 9/21/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON

struct Film {
    let poster_path: String!
    let adult: Bool!
    let overview: String!
    let release_date: String!
    let genre_ids: NSArray!
    let id: Int!
    let original_title: String!
    let original_language: String!
    let title: String!
    let backdrop_path: String!
    let popularity: Float!
    let vote_count: Int!
    let video: Bool!
    let vote_average: Float!
    
    init(_ json: JSON) {
        JSON.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        poster_path = json[.poster_path]
        adult = json[.adult]
        overview = json[.overview]
        release_date = json[.release_date]
        genre_ids = json[.genre_ids]
        id = json[.id]
        original_title = json[.original_title]
        original_language = json[.original_language]
        title = json[.title]
        backdrop_path = json[.backdrop_path]
        popularity = json[.popularity]
        vote_count = json[.vote_count]
        video = json[.video]
        vote_average = json[.vote_average]
        
    }
}


extension JSONKeys {
    
    
    static let poster_path   = JSONKey<String>("poster_path")
    
    static let adult = JSONKey<Bool>("adult")
    
    static let overview = JSONKey<String>("overview")
    
    static let release_date = JSONKey<String>("release_date")
    
    static let genre_ids = JSONKey<NSArray>("genre_ids")
    
    static let id = JSONKey<Int>("id")

    static let original_title = JSONKey<String>("original_title")

    static let original_language = JSONKey<String>("original_language")

    static let title = JSONKey<String>("title")

    static let backdrop_path = JSONKey<String>("backdrop_path")

    static let popularity = JSONKey<Float>("popularity")

    static let vote_count = JSONKey<Int>("vote_count")

    static let video = JSONKey<Bool>("video")

    static let vote_average = JSONKey<Float>("vote_average")
    
    
}
