//
//  PollJobUseCase.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 27/06/2025.
//

import Combine
import Foundation

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

    func startPolling() -> AnyPublisher<[ItemDto], Error> {
        self.pollingTask?.cancel()
        self.pollingTask = Task {
            while !Task.isCancelled {
                let result = await repository.getItems()
                switch result {
                case .failure(let message, let code):
                    subject.send(
                        completion: .failure(CustomError(description: message)))
                case .success(let result):
                    subject.send(result)
                }
                try? await Task.sleep(for: .seconds(10))
            }
        }

        return subject.eraseToAnyPublisher()
    }

    func stopPolling() {
        self.pollingTask?.cancel()
        pollingTask = nil
    }
}
