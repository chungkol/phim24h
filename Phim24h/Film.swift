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


