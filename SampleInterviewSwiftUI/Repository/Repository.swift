//
//  Repository.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Combine
import Foundation

protocol Repository {
    func getItems() async throws -> [ItemDto]
    func getItem(id: String) -> AnyPublisher<ItemDetailsDto, Error>
}

class MainRepository: Repository {
    private var cancellable = Set<AnyCancellable>()
    let networkActions: NetworkActions
    let dbActions: DbActions

    init(networkActions: NetworkActions, dbActions: DbActions) {
        self.networkActions = networkActions
        self.dbActions = dbActions
    }
    
    func getItems() async throws -> [ItemDto] {
        return try await networkActions.fetchMovies()
    }
    
    func getItem(id: String) -> AnyPublisher<ItemDetailsDto, Error> {
        return networkActions.fetchMovie(id: id).eraseToAnyPublisher()
    }

   
}
