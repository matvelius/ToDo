//
//  LocalStorageService.swift
//  ToDo
//
//  Created by Matvey Kostukovsky on 5/17/25.
//

import Foundation
import SwiftData

protocol LocalStorageServiceProtocol {
    func getAllToDoItems() throws -> [ToDoItem]
    func addToDoItem(_ item: ToDoItem) throws
    func update(item: ToDoItem, with completion: Bool) throws
    func removeToDoItem(with id: UUID) throws
    func removeAllToDoItems() throws
}

class LocalStorageService: LocalStorageServiceProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    // TODO: investigate whether or not @MainActor is necessary
    @MainActor
    static let shared = LocalStorageService()
    
    // TODO: investigate whether or not @MainActor is necessary
    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(
                for: ToDoItem.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Unable to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    func getAllToDoItems() throws -> [ToDoItem] {
        return try modelContext.fetch(FetchDescriptor<ToDoItem>())
    }
    
    func addToDoItem(_ item: ToDoItem) throws {
        modelContext.insert(item)
        try modelContext.save()
    }
    
    func update(item: ToDoItem, with isCompleted: Bool) throws {
        item.completed = isCompleted
        try modelContext.save()
    }
    
    func removeToDoItem(with id: UUID) throws {
        try modelContext.delete(model: ToDoItem.self,
                                where: #Predicate { $0.id == id })
        try modelContext.save()
    }
    
    func removeAllToDoItems() throws {
        let allItems = try getAllToDoItems()
        for item in allItems {
            modelContext.delete(item)
        }
        try modelContext.save()
    }
    
    enum LocalStorageServiceError: Error {
        case itemNotFound
    }
}
