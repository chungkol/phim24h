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
    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var genre_ids: NSArray?
    var id: Int?
    var original_title: String?
    var original_language: String?
    var title: String?
    var backdrop_path: String?
    var popularity: Double?
    var vote_count: Int?
    var video: Bool?
    var vote_average: Double?
    var media_type: String?
    init(){
        
    }
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
        media_type = json[.media_type]
    }
}


