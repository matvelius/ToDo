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
    @Namespace var bottomID
    
    @State var showAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { scrollViewProxy in
                    List {
                        existingToDoItems()
                        newToDoItemLine(with: scrollViewProxy)
                            .id(bottomID)
                    }
                    .listStyle(PlainListStyle())
                    .onAppear {
                        viewModel.getAllToDoItems()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("To-Do List")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            addToDoItemButton(with: scrollViewProxy)
                        }
                    }
                }

                HStack(alignment: .center) {
                    addToDoItemsFromAPIButton()
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                }
            }
        }
        .onChange(of: viewModel.errorString) { _, newValue in
            guard newValue != nil else {
                return
            }
            showAlert = true
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorString ?? "Unknown Error. Please try again."))
        }
    }
    
    // MARK: - Subviews
    
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
    func newToDoItemLine(with scrollViewProxy: ScrollViewProxy) -> some View {
        HStack {
            Image(systemName: "circle.dotted")
                .foregroundStyle(Color.gray)
            
            TextField("Add a new to-do", text: $newToDoItemTitle)
                .onSubmit {
                    addToDoItem(with: scrollViewProxy)
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
    func addToDoItemButton(with scrollViewProxy: ScrollViewProxy) -> some View {
        Button {
            if isNewToDoItemTextFieldFocused && !newToDoItemTitle.isEmpty {
                addToDoItem(with: scrollViewProxy)
            } else {
                isNewToDoItemTextFieldFocused = true
                withAnimation {
                    scrollViewProxy.scrollTo(bottomID)
                }
            }
        } label: {
            Image(systemName: "plus")
        }
    }
    
    @ViewBuilder
    func addToDoItemsFromAPIButton() -> some View {
        Button {
            viewModel.fetchToDoItemsFromAPI()
        } label: {
            Text("Add to-do's from API")
                .frame(maxWidth: .infinity)
                .padding(10)
                .foregroundColor(.gray)
                .background(
                    RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    )
                    .stroke(.gray, lineWidth: 2)
                )
                
        }
        .disabled(viewModel.isLoading)
    }
    
    // MARK: - Helper methods
    
    private func addToDoItem(with proxy: ScrollViewProxy) {
        viewModel.addToDoItem(title: newToDoItemTitle)
        newToDoItemTitle = ""
        // adding a short delay fixes scrolling to the new item
        Task {
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation {
                proxy.scrollTo(bottomID)
                isNewToDoItemTextFieldFocused = true
            }
        }
    }
}

#Preview {
    let localStorageService = LocalStorageService.shared
    let networkService = NetworkService.shared
    let viewModel = HomeViewModel(
        localStorageService: localStorageService,
        networkService: networkService
    )
    HomeView(viewModel: viewModel)
}
