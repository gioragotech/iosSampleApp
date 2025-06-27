//
//  ContentView.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Combine
import SwiftUI

struct ItemsListView: View {
    @StateObject private var viewModel: ItemsListViewModel

    init(viewModel: ItemsListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                Text("Tap to load items.")
            case .loading:
                ProgressView("Loading...")
            case .loaded(let items):
                List(items, id: \.id) { item in
                    MovieRowView(movie: item)
                        .onTapGesture {
                            viewModel.eventSubject.send(.showDetails(item.id))
                        }
                }
            case .empty:
                Text("No items found")
            case .error(let message):
                Text("Error: \(message)")
            }
        }
        .onAppear {
            viewModel.eventSubject.send(.fetchItems)
        }
        .onDisappear {
            viewModel.eventSubject.send(.stopRefreshData)
        }
    }
}

struct MovieRowView: View {
    let movie: ListItemViewModel

    var body: some View {
        HStack(spacing: 16) {
            // Poster Image
            AsyncImage(url: URL(string: movie.posterUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 120)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 120)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 120)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "film")
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 120)
                        .cornerRadius(8)
                }
            }

            // Title and Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(movie.year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ItemsListView(
        viewModel: ItemsListViewModel(
            useCase: PollJobUseCaseImpl(repository: MainRepository(networkActions: NetworkActionsImpl())))) 
}
