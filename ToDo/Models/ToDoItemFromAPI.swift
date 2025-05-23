//
//  ToDoItemFromAPI.swift
//  ToDo
//
//  Created by Matvey Kostukovsky on 5/22/25.
//

struct ToDoItemFromAPI: Decodable {
    let title: String
    let completed: Bool
    
    func toInternalModel() -> ToDoItem {
        return ToDoItem(title: title, completed: completed)
    }
}
