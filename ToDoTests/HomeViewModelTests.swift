//
//  HomeViewModelTests.swift
//  ToDoTests
//
//  Created by Matvey Kostukovsky on 5/20/25.
//

import Foundation
import Testing

@testable import ToDo

@MainActor
@Suite(.serialized) class HomeViewModelTests {
    let sut: HomeViewModel!
    let mockLocalStorageService: (any LocalStorageServiceProtocol)?
    
    init() {
        mockLocalStorageService = MockLocalStorageService()
        sut = HomeViewModel(localStorageService: mockLocalStorageService!)
    }
    
    @Test func testGetAllToDoItems() {
        sut.getAllToDoItems()
        #expect(sut.toDoItems.count == 3)
    }
    
    @Test func testAddToDoItem() {
        sut.getAllToDoItems()
        let expectedTitle = "Test Item 4"
        sut.addToDoItem(title: expectedTitle)
        #expect(sut.toDoItems.count == 4)
        #expect(sut.toDoItems.last?.title == expectedTitle)
    }
    
    @Test func testRemoveToDoItem() {
        sut.getAllToDoItems()
        sut.removeToDoItem(at: 2)
        #expect(sut.toDoItems.count == 2)
        #expect(sut.toDoItems.last?.title == "Test Item 2")
    }
    
    @Test func testToggleItemCompletion() {
        sut.getAllToDoItems()
        sut.toggleItemCompletion(at: 0)
        #expect(sut.toDoItems[0].completed)
    }
}
