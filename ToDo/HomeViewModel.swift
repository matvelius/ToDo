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
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.matveycodes.ToDo", category: String(describing: HomeViewModel.self))
    
    private let localStorageService: LocalStorageServiceProtocol
    
    var toDoItems: [ToDoItem] = []
    
    @MainActor
    init(localStorageService: LocalStorageServiceProtocol) {
        self.localStorageService = localStorageService
    }
    
    func getAllToDoItems() {
        do {
            toDoItems = try localStorageService.getAllToDoItems()
        } catch {
            logger.error("Unable to fetch items: \(error.localizedDescription)")
        }
    }
    
    func addToDoItem(title: String) {
        do {
            let item = ToDoItem(title: title)
            try localStorageService.addToDoItem(item)
            getAllToDoItems()
            logger.info("Added to do item with title: \(title)")
        } catch {
            // TODO: Add error toast / alert for user
            logger.error("Unable to add item: \(error.localizedDescription)")
        }
    }
    
    func removeToDoItem(at index: Int?) {
        guard let index else {
            // TODO: Add error toast / alert for user
            logger.error("Invalid index provided")
            return
        }
        
        do {
            let id = toDoItems[index].id
            try localStorageService.removeToDoItem(with: id)
            getAllToDoItems()
        } catch {
            // TODO: Add error toast / alert for user
            logger.error("Unable to remove item at index \(index): \(error.localizedDescription)")
        }
    }
    
    func toggleItemCompletion(at index: Int) {
        do {
            let item = toDoItems[index]
            try localStorageService.update(item: item, with: !item.completed)
        } catch {
            // TODO: Add error toast / alert for user
            logger.error("Unable to update item at index \(index): \(error.localizedDescription)")
        }
    }
}
