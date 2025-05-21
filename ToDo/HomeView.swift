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
        NavigationStack {
            List {
                existingToDoItems()
                newToDoItemLine()
            }
            .listStyle(PlainListStyle())
            .onAppear {
                viewModel.getAllToDoItems()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    addToDoItemButton()
                }
            }
        }
    }
    
    @ViewBuilder
    func existingToDoItems() -> some View {
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
            withAnimation {
                viewModel.removeToDoItem(at: indexSet.first)
                newToDoItemTitle = ""
            }
        }
    }
    
    @ViewBuilder
    func newToDoItemLine() -> some View {
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
        .onChange(of: isNewToDoItemTextFieldFocused) { _, isFocused in
            if !isFocused && !newToDoItemTitle.isEmpty {
                viewModel.addToDoItem(title: newToDoItemTitle)
                newToDoItemTitle = ""
            }
        }
    }
    
    @ViewBuilder
    func addToDoItemButton() -> some View {
        Button {
            if isNewToDoItemTextFieldFocused {
                viewModel.addToDoItem(title: newToDoItemTitle)
                newToDoItemTitle = ""
            } else {
                isNewToDoItemTextFieldFocused = true
            }
        } label: {
            Image(systemName: "plus")
        }
    }
}

#Preview {
    let localStorageService = LocalStorageService.shared
    let viewModel = HomeViewModel(localStorageService: localStorageService)
    HomeView(viewModel: viewModel)
}
