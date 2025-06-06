//
//  ContentView.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ItemsListViewModel(repsitory: MainRepository())
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                Text("Tap to load items.")
               // Button("Load Items", action: viewModel.fetchItems)
            case .loading:
                ProgressView("Loading...")
            case .loaded(let items):
                List(items) { item in
                    Text(item.title)
                }
            case .empty:
                Text("No items found")
            case .error(let message):
                Text("Error:\(message)")
            }
        }.onAppear {
            viewModel.eventSubject.send(.fetchItems)
        }
    }
}

#Preview {
    ContentView()
}
