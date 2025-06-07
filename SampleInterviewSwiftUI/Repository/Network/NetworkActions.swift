//
//  networkActions.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 07/06/2025.
//

import Alamofire
import Combine
import Foundation

protocol NetworkActions {
    func fetchMovies() -> AnyPublisher<SearchResponse, any Error>
    func fetchMovie(id: String) -> AnyPublisher<ItemDetailsDto, any Error>
}

struct CustomError: Error {
    let description: String
}

class NetworkActionsImpl: NetworkActions {
    func fetchMovies() -> AnyPublisher<SearchResponse, any Error> {
        AF.request("http://www.omdbapi.com/?s=star&apikey=af892786").validate()
            .publishDecodable(type: SearchResponse.self).value()
            .mapError { afError in
                CustomError(description: afError.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    func fetchMovie(id: String) -> AnyPublisher<ItemDetailsDto, any Error> {
        AF.request("http://www.omdbapi.com/?i=tt5508566&apikey=af892786")
            .validate()
            .publishDecodable(type: ItemDetailsDto.self).value()
            .mapError { afError in
                CustomError(description: afError.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

}
