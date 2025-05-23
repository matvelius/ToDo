//
//  ToDoItemFromAPI.swift
//  ToDo
//
//  Created by Matvey Kostukovsky on 5/22/25.
//

struct ToDoItemFromAPI: Decodable {
    // TODO: check if userId & id are necessary
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    func toInternalModel() -> ToDoItem {
        return ToDoItem(title: title, completed: completed)
    }
}
