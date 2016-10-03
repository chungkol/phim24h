//
//  Image.swift
//  Phim24h
//
//  Created by Chung on 10/3/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON
struct Backdrop {
    
    
    var aspect_ratio: Float?
    var file_path: String?
    var height: Int?
    var iso_639_1: String?
    var vote_average: Double?
    var vote_count : Int?
    var width: Int?
    
    init(_ json: JSON) {
        
        aspect_ratio = json[.aspect_ratio]
        file_path = json[.file_path]
        height = json[.height]
        iso_639_1 = json[.iso_639_1]
        vote_average = json[.vote_average]
        vote_count = json[.vote_count]
        width = json[.width]
    }
}
