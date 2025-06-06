//
//  ContentView.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import SwiftUI

struct ItemsListView: View {
    @ObservedObject private var viewModel: ItemsListViewModel

    init(viewModel: ItemsListViewModel) {
        self.viewModel = viewModel
    }

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
                    Button(action: {
                        print("Tapped on: \(item.title)")
                        viewModel.eventSubject.send(.showDetails(item.id))
                    }) {
                        HStack {
                            Text(item.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
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
    ItemsListView(viewModel: ItemsListViewModel(repsitory: MainRepository()))
}
