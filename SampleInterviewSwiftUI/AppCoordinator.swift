//
//  AppCoordinator.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import SwiftUI
import Combine

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // Cache for view models to prevent unnecessary allocations
    private var itemsListViewModel: ItemsListViewModel?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - View Creation Methods
    
    func createItemsListView() -> ItemsListView {
        let viewModel = getOrCreateItemsListViewModel()
        return ItemsListView(viewModel: viewModel)
    }
    
    func createItemDetailsView(itemId: String) -> ItemDetailsView {
        let viewModel = createItemDetailsViewModel(itemId: itemId)
        return ItemDetailsView(viewModel: viewModel)
    }
    
    // MARK: - ViewModel Creation Methods
    
    private func getOrCreateItemsListViewModel() -> ItemsListViewModel {
        if let existingViewModel = itemsListViewModel {
            return existingViewModel
        }
        
        let repository = container.resolve(Repository.self)
        let viewModel = ItemsListViewModel(repsitory: repository)
        
        // Subscribe to navigation events from the view model
        viewModel.showDetails
            .sink { [weak self] itemId in
                self?.navigateToItemDetails(itemId: itemId)
            }
            .store(in: &cancellables)
        
        itemsListViewModel = viewModel
        return viewModel
    }
    
    private func createItemDetailsViewModel(itemId: String) -> ItemDetailsViewModel {
        let repository = container.resolve(Repository.self)
        return ItemDetailsViewModel(itemId: itemId, repository: repository)
    }
    
    // MARK: - Navigation Methods
    
    func navigateToItemDetails(itemId: String) {
        path.append(NavigationDestination.itemDetails(itemId))
    }
}

// MARK: - Navigation Destination

enum NavigationDestination: Hashable {
    case itemDetails(String)
} 
