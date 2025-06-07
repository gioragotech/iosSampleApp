//
//  ItemDetailsViewModel.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Foundation
import Combine

class ItemDetailsViewModel: ObservableObject {
    let itemId: String
    let repository: Repository
    @Published var state: ScreenState<[ListItem]> = .idle
    let eventSubject = PassthroughSubject<ViewEvent, Never>()
    
    init(itemId: String, repository: Repository) {
        self.itemId = itemId
        self.repository = repository
    }
    
    
}
