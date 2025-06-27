//
//  PollJobUseCase.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 27/06/2025.
//

import Foundation
import Combine

protocol PollJobUseCase {
    func startPolling() -> AnyPublisher<[ItemDto], Error>
    func stopPolling()
}


class PollJobUseCaseImpl: PollJobUseCase {
    private let repository: Repository
    private var pollingTask: Task<Void, Never>?
    private let subject = CurrentValueSubject<[ItemDto], Error>([])

    init(repository: Repository) {
        self.repository = repository
    }
    
    func startPolling() -> AnyPublisher<[ItemDto], Error>  {
        self.pollingTask?.cancel()
        self.pollingTask = Task {
            while !Task.isCancelled {
                do {
                    let result = try await repository.getItems()
                    subject.send(result)
                } catch  {
                    subject.send(completion: .failure(error))
                }
               
              
                try? await Task.sleep(nanoseconds: 10_000_000_000)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func stopPolling() {
        self.pollingTask?.cancel()
        pollingTask = nil
    }
}
