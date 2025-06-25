//
//  ItemDetails.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import SwiftUI

struct ItemDetailsView: View {
    @ObservedObject private var viewModel: ItemDetailsViewModel

    init(viewModel: ItemDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
      
            switch viewModel.state {
            case .idle: EmptyView()
            case .loading:
                VStack {
                    ProgressView("Loading...")
                }
            case .loaded(let item):
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Poster
                        if let url = item.posterURL {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(height: 300)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 300)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }

                        // Title
                        Text(item.title)
                            .font(.title)
                            .fontWeight(.bold)

                        // Metadata
                        HStack {
                            Text(item.releaseYear)
                            Text("•")
                            Text(item.genre)
                            Text("•")
                            Text(item.duration)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                        // Rating
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(item.rating))
                        }
                        .font(.headline)

                        // Overview
                        Text("Overview")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(item.overview)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Movie Details")
                .navigationBarTitleDisplayMode(.inline)
            case .empty:
                VStack {
                    Text("No items found")
                }
            case .error(let message):
                VStack {
                    Text("Error:\(message)")
                }
            }
        }
}

#Preview {
    ItemDetailsView(
        viewModel: ItemDetailsViewModel(
            itemId: "sample-id",
            repository: MainRepository(networkActions: NetworkActionsImpl())))
}
