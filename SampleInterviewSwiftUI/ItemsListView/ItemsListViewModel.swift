//
//  ItemsListViewModel.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Combine
import Foundation

struct ListItem: Identifiable {
    let id: String
    let title: String
}

enum ViewEvent {
    case fetchItems
    case showDetails(String)
    case stopRefreshData
}

class ItemsListViewModel: ObservableObject {
    @Published var state: ScreenState<[ListItem]> = .idle
    let eventSubject = PassthroughSubject<ViewEvent, Never>()
    let showDetails = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let repository: Repository

    init(repsitory: Repository) {
        print("init ItemsListViewModel")
        self.repository = repsitory
        eventSubject
            .sink { [weak self] event in
                self?.handleEvent(event: event)
            }.store(in: &cancellables)
    }

    private func handleEvent(event: ViewEvent) {
        switch event {
        case .fetchItems:
            repository.getItems(withPolling: false).map({ itemsListDto in
                itemsListDto.map({ itemDto in
                    ListItem(
                        id: itemDto.id, title: itemDto.title)
                })
            }).receive(on: DispatchQueue.main).sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] listItems in
                self?.state = .loaded(listItems)
            }.store(in: &cancellables)

        case .showDetails(let itemId):
            showDetails.send(itemId)
        case .stopRefreshData:
            self.repository.stopPolling()
        }
    }

    deinit {
        print("deinit ItemsListViewModel")
        self.repository.stopPolling()
    }
}
