//
//  ItemDetailsViewModel.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Foundation
import Combine

enum ItemDetailsEvent {
    case fetchItem
}

struct ItemDetails {
    let title: String
    let releaseYear: String
    let genre: String
    let duration: String
    let rating: String
    let overview: String
    let posterURL: URL?
}

class ItemDetailsViewModel: ObservableObject {
    @Published var state: ScreenState<ItemDetails> = .idle
    let eventSubject = PassthroughSubject<ItemDetailsEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    let itemId: String
    private let repository: Repository
    
    init(itemId: String, repository: Repository) {
        self.itemId = itemId
        self.repository = repository
        eventSubject.sink { [weak self] event in
            self?.handleEvent(event)
        }.store(in: &cancellables)
        eventSubject.send(.fetchItem)
    }
    
    
    private func handleEvent(_ event: ItemDetailsEvent) {
        switch event {
        case .fetchItem:
            fetchItem()
        }
    }
    
    private func fetchItem() {
        repository.getItem(id: itemId).map({ itemDto in
            ItemDetails(title: itemDto.title, releaseYear: itemDto.year, genre: itemDto.genre, duration: itemDto.runtime, rating: itemDto.imdbRating,overview: itemDto.plot, posterURL: URL(string: itemDto.poster))
        }).receive(on: DispatchQueue.main).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.state = .error(error.localizedDescription)
            }
        } receiveValue: { [weak self] listItem in
            self?.state = .loaded(listItem)
        }.store(in: &cancellables)
    }
    
    
}
