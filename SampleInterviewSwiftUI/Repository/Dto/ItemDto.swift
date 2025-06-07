//
//  ItemDto.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Foundation

struct ItemDto: Codable {
    let id: String
    let year: String
    let title: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case year = "Year"
        case title = "Title"
        case poster = "Poster"
    }
}

struct SearchResponse: Codable {
    let search: [ItemDto]

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
