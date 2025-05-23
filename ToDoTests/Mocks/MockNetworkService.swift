//
//  MockNetworkService.swift
//  ToDoTests
//
//  Created by Matvey Kostukovsky on 5/22/25.
//

import Foundation

@testable import ToDo

class MockNetworkService: NetworkServiceProtocol {
    func fetchData<T>(for urlString: String) async throws -> T where T: Decodable {
        let item1 = ToDoItemFromAPI(title: "Test Item 1",
                                    completed: false)
        let item2 = ToDoItemFromAPI(title: "Test Item 2",
                                    completed: false)
        let item3 = ToDoItemFromAPI(title: "Test Item 3",
                                    completed: false)
        
        return [item1, item2, item3] as! T
    }
}
