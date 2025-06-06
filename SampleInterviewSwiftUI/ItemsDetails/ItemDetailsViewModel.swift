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
   
    init(itemId: String) {
        self.itemId = itemId
    }
}
