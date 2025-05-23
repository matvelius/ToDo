//
//  HomeViewController.swift
//  ToDo
//
//  Created by Matvey Kostukovsky on 5/17/25.
//

import Foundation
import os

@Observable
class HomeViewModel {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.matveycodes.ToDo",
                                category: String(describing: HomeViewModel.self))
    
    private let localStorageService: any LocalStorageServiceProtocol
    private let networkService: any NetworkServiceProtocol
    
    var toDoItems: [ToDoItem] = []
    var isLoading: Bool = false
    var errorString: String?
    
    @MainActor
    init(localStorageService: any LocalStorageServiceProtocol,
         networkService: any NetworkServiceProtocol) {
        self.localStorageService = localStorageService
        self.networkService = networkService
    }
    
    func getAllToDoItems() {
        do {
            toDoItems = try localStorageService.getAllToDoItems()
            errorString = nil
        } catch {
            logger.error("Unable to fetch to-do items: \(error.localizedDescription)")
            errorString = Constants.unableToFetchToDoItemsErrorMessage
        }
    }
    
    func addToDoItem(title: String) {
        do {
            let item = ToDoItem(title: title)
            try localStorageService.addToDoItem(item)
            getAllToDoItems()
            logger.info("Added to-do item with title: \(title)")
            errorString = nil
        } catch {
            logger.error("Unable to add to-do item: \(error.localizedDescription)")
            errorString = Constants.unableToAddToDoItemErrorMessage
        }
    }
    
    func removeToDoItem(at index: Int?) {
        guard let index else {
            logger.error("Invalid index provided")
            errorString = Constants.unableToRemoveToDoItemErrorMessage
            return
        }
        
        do {
            let id = toDoItems[index].id
            try localStorageService.removeToDoItem(with: id)
            getAllToDoItems()
            errorString = nil
        } catch {
            logger.error("Unable to remove to-do item at index \(index): \(error.localizedDescription)")
            errorString = Constants.unableToRemoveToDoItemErrorMessage
        }
    }
    
    func toggleItemCompletion(at index: Int) {
        do {
            let item = toDoItems[index]
            try localStorageService.update(item: item, with: !item.completed)
            errorString = nil
        } catch {
            logger.error("Unable to update to-do item at index \(index): \(error.localizedDescription)")
            errorString = Constants.unableToToggleToDoItemCompletionErrorMessage
        }
    }
    
    func fetchToDoItemsFromAPI() {
        isLoading = true
        Task {
            do {
                let items: [ToDoItemFromAPI] = try await networkService.fetchData(for: Constants.toDoItemsURL)
                try items.forEach { item in
                    try localStorageService.addToDoItem(item.toInternalModel())
                }
                getAllToDoItems()
                errorString = nil
            } catch {
                logger.error("Unable to fetch to-do items from API: \(error.localizedDescription)")
                errorString = Constants.unableToFetchToDoItemsFromTheAPIErrorMessage
            }
            
            isLoading = false
        }
    }
    
    struct Constants {
        static let toDoItemsURL = "https://jsonplaceholder.typicode.com/todos"
        static let unableToFetchToDoItemsErrorMessage = "Unable to fetch to-do items. Please try again."
        static let unableToAddToDoItemErrorMessage = "Unable to add to-do item. Please try again."
        static let unableToRemoveToDoItemErrorMessage = "Unable to remove to-do item. Please try again."
        static let unableToToggleToDoItemCompletionErrorMessage = "Unable to toggle to-do item completion. Please try again."
        static let unableToFetchToDoItemsFromTheAPIErrorMessage = "Unable to fetch to-do items from the API. Please try again."
    }
}
