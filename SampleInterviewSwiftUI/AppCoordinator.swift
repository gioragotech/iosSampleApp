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
    
    private let repository: Repository
    private var cancellables = Set<AnyCancellable>()
    
    // Cache for view models to prevent unnecessary allocations
    private var itemsListViewModel: ItemsListViewModel?
    
    init(repository: Repository) {
        self.repository = repository
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
        return ItemDetailsViewModel(itemId: itemId)
    }
    
    // MARK: - Navigation Methods
    
    func navigateToItemDetails(itemId: String) {
        path.append(NavigationDestination.itemDetails(itemId))
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func navigateToRoot() {
        path = NavigationPath()
    }
    
    // MARK: - Memory Management
    
    func clearCache() {
        itemsListViewModel = nil
    }
}

// MARK: - Navigation Destination

enum NavigationDestination: Hashable {
    case itemDetails(String)
} 