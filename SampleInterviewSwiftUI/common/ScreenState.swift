//
//  ScreenState.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import Foundation

enum ScreenState<T> {
    case idle
    case loading
    case loaded(T)
    case empty
    case error(String)
}
