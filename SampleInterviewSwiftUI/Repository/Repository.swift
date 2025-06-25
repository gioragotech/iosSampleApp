//
//  Repository.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Combine
import Foundation

protocol Repository {
    func getItems(withPolling: Bool) -> AnyPublisher<[ItemDto], Error>
    func getItem(id: String) -> AnyPublisher<ItemDetailsDto, Error>
    func stopPolling()
}

class MainRepository: Repository {
    private var cancellable = Set<AnyCancellable>()
    private var isPolling = false
    private var pollingTask: Task<Void, Never>?
    let networkActions: NetworkActions

    init(networkActions: NetworkActions) {
        self.networkActions = networkActions
    }
    
    func getItems(withPolling: Bool) -> AnyPublisher<[ItemDto], Error> {
        if withPolling {
            startPolling()
            // Return empty publisher for now since polling is not implemented
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return networkActions.fetchMovies()
            .map { response in
                response.search
            }
            .eraseToAnyPublisher()
    }
    
    func getItem(id: String) -> AnyPublisher<ItemDetailsDto, Error> {
        return networkActions.fetchMovie(id: id).eraseToAnyPublisher()
    }

    private func startPolling() {
        guard !isPolling else { return }
        isPolling = true

        self.pollingTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }
    }
    
    func stopPolling() {
        isPolling = false
        self.pollingTask?.cancel()
        pollingTask = nil
    }
}
