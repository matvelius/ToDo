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
    var mockLocalStorageService: (any LocalStorageServiceProtocol)?
    let mockNetworkService: (any NetworkServiceProtocol)?
        
    init() {
        mockLocalStorageService = MockLocalStorageService()
        mockNetworkService = MockNetworkService()
        sut = HomeViewModel(localStorageService: mockLocalStorageService!,
                            networkService: mockNetworkService!)
    }
    
    @Test func getAllToDoItems() {
        sut.getAllToDoItems()
        #expect(sut.toDoItems.count == 3)
    }
    
    @Test func addToDoItem() {
        sut.getAllToDoItems()
        let expectedTitle = "Test Item 4"
        sut.addToDoItem(title: expectedTitle)
        #expect(sut.toDoItems.count == 4)
        #expect(sut.toDoItems.last?.title == expectedTitle)
    }
    
    @Test func removeToDoItem() {
        sut.getAllToDoItems()
        sut.removeToDoItem(at: 2)
        #expect(sut.toDoItems.count == 2)
        #expect(sut.toDoItems.last?.title == "Test Item 2")
    }
    
    @Test func toggleItemCompletion() {
        sut.getAllToDoItems()
        sut.toggleItemCompletion(at: 0)
        #expect(sut.toDoItems[0].completed)
    }
    
    @Test func fetchToDoItemsFromAPISuccess() {
        // clearing local storage so that it doesn't
        // interfere with the test
        try! mockLocalStorageService!.removeAllToDoItems()
        
        sut.fetchToDoItemsFromAPI()
        Thread.sleep(forTimeInterval: 0.1)
        #expect(self.sut.errorString == nil)
        #expect(self.sut.toDoItems.count == 3)
    }
    
    @Test func fetchToDoItemsFromAPIFailure() {
        // clearing local storage so that it doesn't
        // interfere with the test
        try! mockLocalStorageService!.removeAllToDoItems()
        
        sut.fetchToDoItemsFromAPI()
        Thread.sleep(forTimeInterval: 0.1)
        #expect(self.sut.errorString == nil)
        #expect(self.sut.toDoItems.count == 3)
    }
}
