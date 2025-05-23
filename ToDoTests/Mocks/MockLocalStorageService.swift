//
//  MockLocalStorageService.swift
//  ToDoTests
//
//  Created by Matvey Kostukovsky on 5/20/25.
//

import Foundation

@testable import ToDo

class MockLocalStorageService: LocalStorageServiceProtocol {
    private var toDoItems = [ToDoItem]()
    
    init() {
        let item1 = ToDoItem(title: "Test Item 1")
        let item2 = ToDoItem(title: "Test Item 2")
        let item3 = ToDoItem(title: "Test Item 3")
        
        toDoItems = [item1, item2, item3]
    }
    
    func getAllToDoItems() throws -> [ToDoItem] {
        return toDoItems
    }
    
    func addToDoItem(_ item: ToDoItem) throws {
        toDoItems.append(item)
    }
    
    func update(item: ToDoItem, with completion: Bool) throws {
        toDoItems.first(where: { $0.id == item.id })?.completed = completion
    }
    
    func removeToDoItem(with id: UUID) throws {
        toDoItems.removeAll(where: { $0.id == id })
    }
    
    func removeAllToDoItems() throws {
        toDoItems = []
    }
}
