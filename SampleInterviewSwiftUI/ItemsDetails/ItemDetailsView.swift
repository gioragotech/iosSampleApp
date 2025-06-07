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
        VStack(alignment: .leading, spacing: 16) {
            Text("Item ID: \(viewModel.itemId)")
                .font(.headline)
            
            Text("This is the details view for the selected item.")
                .font(.body)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ItemDetailsView(viewModel: ItemDetailsViewModel(itemId: "sample-id", repository: MainRepository(networkActions: NetworkActionsImpl())))
}
