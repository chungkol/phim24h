//
//  ManagerData.swift
//  Phim24h
//
//  Created by Chung on 9/22/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import Alamofire
import JASON
class ManagerData {
    static let API_KEY = "b7f3fcf9abbb6d309e2a52b55cc8127c"
    static let TOP_RATED = "https://api.themoviedb.org/3/movie/top_rated?language=en-US"
    static let POPULAR = "https://api.themoviedb.org/3/movie/popular?language=en-US"
    static let UPCOMING = "https://api.themoviedb.org/3/movie/upcoming?language=en-US"
    static let NOW_PLAYING = "https://api.themoviedb.org/3/movie/now_playing?language=en-US"
    static let GENRE = "https://api.themoviedb.org/3/genre/movie/list?language=en-US"
    
    
    static let instance = ManagerData()
    
    private var list_Top_Rated : [Film] = []
    var list_Popular : [Film] = []
    var list_Up_Coming : [Film] = []
    var list_Now_Playing : [Film] = []
    var list_genres: [Genre] = []
    var pageTopRated = 1
    var pagePopular = 1
    var pageUpComing = 1
    var pageNowPlaying = 1
    private init() {
        
    }
    
    
    func getAllGenre(completetion: @escaping ([Genre])->()) {
        if list_genres.count == 0  {
            getGenres(completetion: { [unowned self] genres in
                self.list_genres = genres
                completetion(genres)
                
            })
        }
    }
    
    
    //get list film top rated
    func getTopRated(page: Int,type: String,
                     completetion:@escaping ([Film])->())
    {
        if (list_Top_Rated.count == 0)
        {
            getFilms(page: page, type: type, completetion: { [unowned self] films in
                self.list_Top_Rated = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Top_Rated)
        }
    }
    
    //get lish film popular
    func getPopular(page: Int,type: String,
                    completetion:@escaping ([Film])->())
    {
        if (list_Popular.count == 0)
        {
            getFilms(page: page, type: type, completetion: { [unowned self] films in
                self.list_Popular = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Popular)
        }
    }
    
    //get list film up coming
    func getUpComing(page: Int,type: String,
                     completetion:@escaping ([Film])->())
    {
        if (list_Up_Coming.count == 0)
        {
            getFilms(page: page, type: type, completetion: { [unowned self] films in
                self.list_Up_Coming = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Up_Coming)
        }
    }
    
    //get lish film now playing
    func getNowPlaying(page: Int,type: String,
                       completetion:@escaping ([Film])->())
    {
        if (list_Now_Playing.count == 0)
        {
            getFilms(page: page, type: type, completetion: { [unowned self] films in
                self.list_Now_Playing = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Now_Playing)
        }
    }
    
    private func getFilms(page: Int, type: String,
                          completetion:@escaping ([Film])->()){
        let parameters: Parameters = ["api_key": ManagerData.API_KEY,
                                      "page": page]
        
        Alamofire.request(type, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["results"].map(Film.init)
                    completetion(results)
                }
        }
    }
    
    //get genre of film
    private func getGenres(completetion: @escaping ([Genre])->()) {
        
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        
        Alamofire.request(ManagerData.GENRE, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["genres"].map(Genre.init)
                    completetion(results)
                
                }
        }
        
    }
    
    
    
}


extension DataRequest {
    /**
     Creates a response serializer that returns a JASON.JSON object constructed from the response data.
     
     - returns: A JASON.JSON object response serializer.
     */
    static public func JASONReponseSerializer() -> DataResponseSerializer<JASON.JSON> {
        return DataResponseSerializer { _, _, data, error in
            guard error == nil else { return .failure(error!) }
            
            return .success(JASON.JSON(data))
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    @discardableResult
    public func responseJASON(completionHandler: @escaping (DataResponse<JASON.JSON>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.JASONReponseSerializer(), completionHandler: completionHandler)
    }
    
}
