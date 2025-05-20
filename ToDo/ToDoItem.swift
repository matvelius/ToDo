//
//  Item.swift
//  ToDo
//
//  Created by Matvey Kostukovsky on 5/17/25.
//

import Foundation
import SwiftData

@Model
final class ToDoItem: Identifiable, Equatable {
    @Attribute(.unique) var id: UUID
    
    var title: String
    var completed: Bool
    
    init(id: UUID = .init(),
         title: String,
         completed: Bool = false) {
        self.id = id
        self.title = title
        self.completed = completed
    }
}

//@Model
//final class TestModel {
//    @Attribute(.unique) var id: UUID
//    
//    var title: String
//    
//    init(id: UUID = .init(),
//         title: String) {
//        self.id = id
//        self.title = title
//    }
//}
