//
//  AppView.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import SwiftUI

struct AppView: View {
    @StateObject private var coordinator: AppCoordinator
    
    init(repository: Repository = MainRepository(networkActions: NetworkActionsImpl())) {
        self._coordinator = StateObject(wrappedValue: AppCoordinator(repository: repository))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.createItemsListView()
                .navigationTitle("Items")
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .itemDetails(let itemId):
                        coordinator.createItemDetailsView(itemId: itemId)
                            .navigationTitle("Item Details")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
        }
    }
}

#Preview {
    AppView()
} 
