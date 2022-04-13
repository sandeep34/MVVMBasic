//
//  MoviewModel.swift
//  MVVM_Practice
//
//  Created by Sandeep Tomar on 30/01/22.
//

import Foundation

class MovieModel: Codable {
    
    var adult: Bool?
    var backdrop_path: String?
    var id: Int?
    var  original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Float?
    var poster_path: String?
    var release_date: String?
    var  title: String?
    var  video: Bool?
    var  vote_average: String?
    var  vote_count: String?
   // var genre_ids = Dictionary<String, Any>()
    

}

struct Genreids: Codable {
   
}
