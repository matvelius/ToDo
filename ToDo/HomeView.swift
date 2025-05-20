//
//  ContentView.swift
//  ToDo
//
//  Created by Matvey Kostukovsky on 5/17/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var viewModel: HomeViewModel
    @State var newToDoItemTitle: String = ""
    
    @FocusState private var isNewToDoItemTextFieldFocused: Bool

    var body: some View {
        List {
            // TODO: extract to subviews
            // Existing to do items
            ForEach(Array(viewModel.toDoItems.enumerated()), id: \.0) { index, item in
                HStack() {
                    Button {
                        viewModel.toggleItemCompletion(at: index)
                        isNewToDoItemTextFieldFocused = false
                    } label: {
                        Image(systemName: item.completed ? "checkmark.circle" : "circle")
                            .foregroundStyle(Color.gray)
                    }
                    
                    Text(item.title)
                }
            }
            .onDelete { indexSet in
                viewModel.removeToDoItem(at: indexSet.first)
            }
            
            // New to do item
            HStack {
                Image(systemName: "circle.dotted")
                    .foregroundStyle(Color.gray)
                
                TextField("Add a new to-do", text: $newToDoItemTitle)
                    .onSubmit {
                        viewModel.addToDoItem(title: newToDoItemTitle)
                        newToDoItemTitle = ""
                    }
                    .focused($isNewToDoItemTextFieldFocused)
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            viewModel.getAllToDoItems()
        }
        .onChange(of: isNewToDoItemTextFieldFocused) { _, isFocused in
            if !isFocused && !newToDoItemTitle.isEmpty {
                viewModel.addToDoItem(title: newToDoItemTitle)
                newToDoItemTitle = ""
            }
        }
    }
}

#Preview {
    let localStorageService = LocalStorageService.shared
    let viewModel = HomeViewModel(localStorageService: localStorageService)
    HomeView(viewModel: viewModel)
}
