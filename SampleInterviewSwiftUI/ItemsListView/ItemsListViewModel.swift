//
//  ItemsListViewModel.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Foundation
import Combine

struct ListItem: Identifiable {
    let id: String
    let title: String
    let description: String
}

enum ViewEvent {
    case fetchItems
    case showDetails
}

class ItemsListViewModel: ObservableObject {
    @Published var state: ScreenState<[ListItem]> = .idle
    let eventSubject = PassthroughSubject<ViewEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        eventSubject
            .sink  { [weak self] event in
                self?.handleEvent(event: event)
            }.store(in: &cancellables)
    }
    
    private func handleEvent(event: ViewEvent) {
        switch event {
        case .fetchItems: break
        case .showDetails: break
        }
    }
    
}
