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
    
    static let vote_average = JSONKey<Double?>("vote_average")
    
    static let name = JSONKey<String?>("name")
    
    //KEY image
    
    //    "aspect_ratio": 1.77777777777778,
    //    "file_path": "/foxgxCt3JSmHevCXUJfQ9ZGB4K5.jpg",
    //    "height": 2160,
    //    "iso_639_1": null,
    //    "vote_average": 5.3125,
    //    "vote_count": 1,
    //    "width": 3840
    static let aspect_ratio = JSONKey<Float?>("aspect_ratio")
    static let file_path = JSONKey<String?>("file_path")
    static let height = JSONKey<Int?>("height")
    static let iso_639_1 = JSONKey<String?>("iso_639_1")
    static let width = JSONKey<Int?>("width")
    
    //KEY trailer
    //    "id": "571bf3bdc3a36824a30024ea",
    //    "iso_639_1": "en",
    //    "iso_3166_1": "US",
    //    "key": "LoebZZ8K5N0",
    //    "name": "Official Trailer",
    //    "site": "YouTube",
    //    "size": 1080,
    //    "type": "Trailer"
    static let id_trailer = JSONKey<String?>("id")
    static let iso_3166_1 = JSONKey<String?>("iso_3166_1")
    static let key = JSONKey<String?>("key")
    static let site = JSONKey<String?>("site")
    static let size = JSONKey<Int?>("size")
    static let type = JSONKey<String?>("type")
    
    
    //KEY Cast
    //    "cast_id": 5,
    //    "character": "Andrew Neimann",
    //    "credit_id": "52fe4ef7c3a36847f82b3fc3",
    //    "id": 996701,
    //    "name": "Miles Teller",
    //    "order": 0,
    //    "profile_path": "/g9DoeCHyn2C110gHbnh6nrD08Id.jpg"
    
    static let cast = JSONKey<JSON>("cast")
    static let cast_id = JSONKey<Int?>("cast_id")
    static let character = JSONKey<String?>("character")
    static let credit_id = JSONKey<String?>("credit_id")
    static let order = JSONKey<Int?>("order")
    static let profile_path = JSONKey<String>("profile_path")
    //KEY Crew
    
//    var credit_id: String?
//    var department: String?
//    var id: Int?
//    var job: String?
//    var name: String?
//    var profile_path: String?
     static let crew = JSONKey<JSON>("crew")
    static let department = JSONKey<String?>("department")
    static let job = JSONKey<String?>("job")

    
}
