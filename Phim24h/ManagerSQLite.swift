//
//  ManagerSQLite.swift
//  Phim24h
//
//  Created by Chung on 10/12/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import GRDB
class ManagerSQLite : NSObject {
    static let shareInstance = ManagerSQLite()
    
    var pathToDatabase: String!
    static let DB_NAME = "manager.sqlite3"
    var database: DatabaseQueue!
    
    
    
    //colum
    
    let id = "id"
    let poster_path = "poster_path"
    let adult = "adult"
    let overview = "overview"
    let release_date = "release_date"
    let genre_ids = "genre_ids"
    let original_title = "original_title"
    let original_language = "original_language"
    let title = "title"
    let backdrop_path = "backdrop_path"
    let popularity = "popularity"
    let vote_count = "vote_count"
    let video = "video"
    let vote_average = "vote_average"
    
    
    
    private override init() {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        pathToDatabase = documentsDirectory.appending("/\(ManagerSQLite.DB_NAME)")
        database = try! DatabaseQueue(path: pathToDatabase)
    }
    
    func creatDB(table_name: String) throws {
        try! database.inDatabase { db in
            try db.create(table: table_name, temporary: false, ifNotExists: true){ t in
                t.column("id", .integer).primaryKey()
                t.column("poster_path", .text)
                t.column("adult", .boolean).defaults(to: false)
                t.column("overview", .text)
                t.column("release_date", .text)
                t.column("genre_ids", .text)
                t.column("original_title", .text)
                t.column("original_language", .text)
                t.column("title", .text)
                t.column("backdrop_path", .text)
                t.column("popularity", .double)
                t.column("vote_count", .integer)
                t.column("video", .boolean)
                t.column("vote_average", .double)
            }
        }
        
    }
    func insertData(table_name: String, film: Film) throws {
        try! creatDB(table_name: table_name)
        try! database.inDatabase { db in
            try db.execute("INSERT INTO \(table_name) (id, poster_path, adult, overview, release_date, genre_ids, original_title, original_language, title, backdrop_path, popularity, vote_count, video,vote_average) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", arguments: [film.id, film.poster_path , film.adult , film.overview, film.release_date, self.convertArrToString(arr: film.genre_ids as! [Int]), film.original_title, film.original_language, film.title, film.backdrop_path, film.popularity, film.vote_count, film.video, film.vote_average])
        }
        
    }
    func getAllData(table_name: String) throws -> [Film] {
        var arr: [Film] = []
        try! creatDB(table_name: table_name)
        let query = "select * from \(table_name)"
        try! database.inDatabase { db in
            for row in Row.fetch(db, query) {
                var film : Film = Film()
                film.id = row.value(named: "id")
                film.poster_path = row.value(named: "poster_path")
                film.adult = row.value(named: "adult")
                film.overview = row.value(named: "overview")
                film.release_date = row.value(named: "release_date")
                
                film.genre_ids = convertStringToArr(text: row.value(named: "genre_ids")) as NSArray?
                film.original_title = row.value(named: "original_title")
                film.original_language = row.value(named: "original_language")
                film.title = row.value(named: "title")
                film.backdrop_path = row.value(named: "backdrop_path")
                film.popularity = row.value(named: "popularity")
                film.vote_count = row.value(named: "vote_count")
                film.video = row.value(named: "video")
                film.vote_average = row.value(named: "vote_average")
                arr.append(film)
            }
        }
        return arr
    }
    
    
    func convertArrToString(arr: [Int]) -> String {
        var result = ""
        for value in arr {
            result += "\(value),"
        }
        return result
    }
    func convertStringToArr(text: String) -> [Int] {
        var result: [Int] = []
        let temp = text.characters.split{$0 == ","}
        for (_,value) in temp.enumerated()  {
            //            if value != nil {
            //                temp.remove(at: index)
            //            }
            result.append(Int(String(value))!)
        }
        
        return result
    }
    
    
    //
    //
    //
    //
    //    var db: Connection! = nil
    //    private override init() {
    //
    //    }
    //
    //    func connectDatabase() throws {
    //        db = try! Connection("\(ManagerSQLite.PATH)//\(ManagerSQLite.DB_NAME)")
    //        print(ManagerSQLite.PATH)
    //        try! db.execute("PRAGMA foreign_keys = ON;")
    //        db.trace( { (info) in
    //            print(info)
    //        })
    //
    //    }
    //
    //    func createTable(table_name: String) throws {
    //        let films = Table(table_name)
    //        if db != nil {
    //            try! db.run(films.create(ifNotExists: true)  { t in
    //                t.column(id, primaryKey: true)
    //                t.column(poster_path)
    //                t.column(adult)
    //                t.column(overview)
    //                t.column(release_date)
    //                t.column(genre_ids)
    //                t.column(original_title)
    //                t.column(original_language)
    //                t.column(title)
    //                t.column(backdrop_path)
    //                t.column(popularity)
    //                t.column(vote_count)
    //                t.column(video)
    //                t.column(vote_average)
    //            })
    //
    //        }
    //
    //
    //    }
    //
    //    func insertValues(film: Film, table_name: String) throws -> Bool {
    //        try createTable(table_name: table_name)
    //        let table = Table(table_name)
    //        if db != nil {
    //
    //            let insertValues = table.insert(id <- film.id!, poster_path <- film.poster_path, adult <- film.adult, overview <- film.overview, release_date <- film.release_date, genre_ids <- self.convertArrToString(arr: film.genre_ids as! [Int]), original_title <- film.original_title, original_language <- film.original_language, title <- film.title, backdrop_path <- film.backdrop_path, popularity <- film.popularity, vote_count <- film.vote_count, video <- film.video, vote_average <- film.vote_average  )
    //            try db.run(insertValues)
    //            return true
    //        }else {
    //            return false
    //        }
    //
    //    }
    //    func getAllFavorite(table_name: String) throws -> [Film]
    //    {
    //        let table = Table(table_name)
    //        var datas: [Film] = []
    //        if db != nil {
    //            for value in try db.prepare(table) {
    //                var item: Film = Film()
    //                item.id = value[id]
    //                item.poster_path = value[poster_path]
    //                item.adult = value[adult]
    //                item.overview = value[overview]
    //                item.release_date = value[release_date]
    //                item.genre_ids = convertStringToArr(text: value[genre_ids]!) as NSArray?
    //                item.original_title = value[original_title]
    //                item.original_language = value[original_language]
    //                item.title = value[title]
    //                item.backdrop_path = value[backdrop_path]
    //                item.popularity = value[popularity]
    //                item.vote_count = value[vote_count]
    //                item.video = value[video]
    //                item.vote_average = value[vote_average]
    //
    //                datas.append(item)
    //
    //            }
    //
    //        }
    //
    //        return datas
    //
    //    }
    //
    //
    //
    //
    //
    //
    
}
