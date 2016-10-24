//
//  JSONKEYS.swift
//  Phim24h
//
//  Created by Chung on 9/24/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON
extension JSONKeys {
    
    
    static let poster_path   = JSONKey<String?>("poster_path")
    
    static let adult = JSONKey<Bool?>("adult")
    
    static let overview = JSONKey<String?>("overview")
    
    static let release_date = JSONKey<String?>("release_date")
    
    static let genre_ids = JSONKey<NSArray?>("genre_ids")
    
    static let id = JSONKey<Int?>("id")
    
    static let original_title = JSONKey<String?>("original_title")
    
    static let original_language = JSONKey<String?>("original_language")
    
    static let title = JSONKey<String?>("title")
    
    static let backdrop_path = JSONKey<String?>("backdrop_path")
    
    static let popularity = JSONKey<Double?>("popularity")
    
    static let vote_count = JSONKey<Int?>("vote_count")
    
    static let video = JSONKey<Bool?>("video")
    
    static let vote_average = JSONKey<Double?>("vote_average")
    
    static let name = JSONKey<String?>("name")
    
    static let aspect_ratio = JSONKey<Float?>("aspect_ratio")
    static let file_path = JSONKey<String?>("file_path")
    static let height = JSONKey<Int?>("height")
    static let iso_639_1 = JSONKey<String?>("iso_639_1")
    static let width = JSONKey<Int?>("width")
    
    
    static let id_trailer = JSONKey<String?>("id")
    static let iso_3166_1 = JSONKey<String?>("iso_3166_1")
    static let key = JSONKey<String?>("key")
    static let site = JSONKey<String?>("site")
    static let size = JSONKey<Int?>("size")
    static let type = JSONKey<String?>("type")
    
    
    
    static let cast = JSONKey<JSON>("cast")
    static let cast_id = JSONKey<Int?>("cast_id")
    static let character = JSONKey<String?>("character")
    static let credit_id = JSONKey<String?>("credit_id")
    static let order = JSONKey<Int?>("order")
    static let profile_path = JSONKey<String>("profile_path")
    
    static let crew = JSONKey<JSON>("crew")
    static let department = JSONKey<String?>("department")
    static let job = JSONKey<String?>("job")
    static let media_type = JSONKey<String?>("media_type")
    static let known_for = JSONKey<NSArray?>("known_for")

    static let budget = JSONKey<Double?>("budget")
    static let homepage = JSONKey<String?>("homepage")
    static let revenue = JSONKey<Double?>("revenue")
    static let runtime = JSONKey<Double?>("runtime")
    
       
    static let success = JSONKey<Bool?>("success")
    static let guest_session_id = JSONKey<String?>("guest_session_id")
    static let expires_at = JSONKey<String?>("expires_at")

    
}
