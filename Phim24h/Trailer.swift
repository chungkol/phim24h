//
//  Trailer.swift
//  Phim24h
//
//  Created by Chung on 10/3/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON
struct Trailer {
    
    
    //
    //    "id": "571bf3bdc3a36824a30024ea",
    //    "iso_639_1": "en",
    //    "iso_3166_1": "US",
    //    "key": "LoebZZ8K5N0",
    //    "name": "Official Trailer",
    //    "site": "YouTube",
    //    "size": 1080,
    //    "type": "Trailer"
    
    var id: String?
    var iso_639_1: String?
    var iso_3166_1: String?
    var key: String?
    var name: String?
    var site : String?
    var size: Int?
    var type: String?
    
    init(_ json: JSON) {
        
        id = json[.id_trailer]
        iso_639_1 = json[.iso_639_1]
        iso_3166_1 = json[.iso_3166_1]
        key = json[.key]
        name = json[.name]
        site = json[.site]
        size = json[.size]
        type = json[.type]
    }
}
