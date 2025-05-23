//
//  LocalStorageServiceTests.swift
//  LocalStorageServiceTests
//
//  Created by Matvey Kostukovsky on 5/17/25.
//

import Foundation
import Testing

@testable import ToDo

@MainActor
@Suite(.serialized) class LocalStorageServiceTests {
    let sut: LocalStorageService!
    
    init() {
        sut = LocalStorageService.shared
        try! sut.removeAllToDoItems()
    }
    
    deinit {
        try! sut.removeAllToDoItems()
    }
    
    @Test func addToDoItem() {
        let item1 = ToDoItem(title: "Test Item 1")
        try! sut.addToDoItem(item1)
        
        let retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.count == 1)
    }

    @Test func getAllToDoItems() {
        var retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.isEmpty)
        
        let item1 = ToDoItem(title: "Test Item 1")
        let item2 = ToDoItem(title: "Test Item 2")
        let item3 = ToDoItem(title: "Test Item 3")
        
        try! sut.addToDoItem(item1)
        try! sut.addToDoItem(item2)
        try! sut.addToDoItem(item3)
        
        retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.count == 3)
    }
    
    @Test func updateToDoItem() {
        let item1 = ToDoItem(title: "Test Item 1")
        
        try! sut.addToDoItem(item1)
        
        var retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.count == 1)
        #expect(retrievedToDoItems[0].completed == false)
        
        let isCompleted = true
        try! sut.update(item: item1, with: isCompleted)
        
        retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.count == 1)
        #expect(retrievedToDoItems[0].completed == true)
    }
    
    @Test func removeToDoItemWithID() {
        let id = UUID()
        let item1 = ToDoItem(id: id, title: "Test Item 1")
        
        try! sut.addToDoItem(item1)
        
        var retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.count == 1)
        
        try! sut.removeToDoItem(with: id)
        
        retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.isEmpty)
    }

    @Test func removeAllToDoItems() {
        let item1 = ToDoItem(title: "Test Item 1")
        
        try! sut.addToDoItem(item1)
        
        var retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.count == 1)
        
        try! sut.removeAllToDoItems()
        
        retrievedToDoItems = try! sut.getAllToDoItems()
        #expect(retrievedToDoItems.isEmpty)
    }
}
