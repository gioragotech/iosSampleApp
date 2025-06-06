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
}

class MainRepository: Repository {
    static private let delayBetween: TimeInterval = 2_000_000_000
    private var cancellable = Set<AnyCancellable>()
    private let trigger = PassthroughSubject<Void, Never>()
    private var isPolling = false
    private var pollingTask: Task<Void, Never>?
    let poolinItemsPublisher = CurrentValueSubject<[ItemDto], Error>([])

    func getItems(withPolling: Bool) -> AnyPublisher<[ItemDto], Error> {
        if withPolling {
            startPolling()
            return poolinItemsPublisher.eraseToAnyPublisher()
        }

        return Just([
            ItemDto(id: "1", title: "x-men", description: "comics moview"),
            ItemDto(id: "2", title: "x-men 2", description: "comics moview"),
        ]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func startPolling() {
        guard !isPolling else { return }
        isPolling = true

        self.pollingTask = Task {
            while !Task.isCancelled {
                poolinItemsPublisher.send([ItemDto(id: "2", title: "xxxx", description: "yyyy")])
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                poolinItemsPublisher.send([ItemDto(id: "2", title: "xxxx1", description: "hhhhh")])
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }
    }
    
    func stopPolling() {
        self.pollingTask?.cancel()
        pollingTask = nil
    }
}
