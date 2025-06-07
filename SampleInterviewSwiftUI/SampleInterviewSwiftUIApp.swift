//
//  SampleInterviewSwiftUIApp.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 06/06/2025.
//

import SwiftUI

@main
struct SampleInterviewSwiftUIApp: App {
    private let container: DIContainer
    
    init() {
        self.container = DefaultDIContainer.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(container: container)
        }
    }
}
