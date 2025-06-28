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
    func fetchMovies() async throws -> [ItemDto]
    func fetchMovie(id: String) -> AnyPublisher<ItemDetailsDto, any Error>
}


enum APIRequest: URLRequestConvertible{
    case getMovies
    case getMovieById(String)
    
    var baseURL: String {
        return "http://www.omdbapi.com"
    }
    
    var apiKey: String {
           return "af892786"
       }
    
    var method: HTTPMethod {
        switch self {
        case .getMovieById, .getMovies:
            return .get
        }
    }
    
    var path:String {
        return ""
    }
    
    var parameters: Parameters? {
            switch self {
            case .getMovieById(let id):
                return [
                    "i": id,
                    "apikey": apiKey
                ]
            case .getMovies:
                return [
                    "s": "star",
                    "apikey": apiKey
                ]
            }
        }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
                
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.method = method
        request.headers = headers ?? HTTPHeaders()
                
        return try encoding.encode(request, with: parameters)
    }
}

struct CustomError: Error {
    let description: String
}

class NetworkActionsImpl: NetworkActions {
    func fetchMovies() async throws -> [ItemDto] {
        do {
            return try await AF.request(APIRequest.getMovies)
                    .validate()
                    .serializingDecodable(SearchResponse.self)
                    .value.search
            } catch {
                throw CustomError(description: error.localizedDescription)
            }
    }
    
    func fetchMoviesUsingURLSession() async throws -> [ItemDto] {
        guard let url = URL(string: "https://your-api-endpoint.com/movies") else {
            throw CustomError(description: "Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Add headers if needed
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw CustomError(description: "Server error: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }

            let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
            return decoded.search
        } catch {
            throw CustomError(description: error.localizedDescription)
        }
    }

    func fetchMovie(id: String) -> AnyPublisher<ItemDetailsDto, any Error> {
        AF.request(APIRequest.getMovieById(id))
            .validate()
            .publishDecodable(type: ItemDetailsDto.self).value()
            .mapError { afError in
                CustomError(description: afError.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

}
