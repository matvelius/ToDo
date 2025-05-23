//
//  ToDoApp.swift
//  ToDo
//
//  Created by Matvey Kostukovsky on 5/17/25.
//

import SwiftUI

@main
struct ToDoApp: App {
    let viewModel: HomeViewModel
    
    init() {
        viewModel = HomeViewModel(
            localStorageService: LocalStorageService.shared,
            networkService: NetworkService.shared
        )
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: viewModel)
        }
    }
}
