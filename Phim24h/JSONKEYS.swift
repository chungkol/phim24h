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
    
    static let popularity = JSONKey<Float?>("popularity")
    
    static let vote_count = JSONKey<Int?>("vote_count")
    
    static let video = JSONKey<Bool?>("video")
    
    static let vote_average = JSONKey<Float?>("vote_average")
    
    static let name = JSONKey<String?>("name")
    
    
}
