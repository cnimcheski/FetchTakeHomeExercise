//
//  ContentView.swift
//  FetchTakeHomeExercise
//
//  Created by Steve Nimcheski on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [Item] = []
    @State private var searchText = ""
    @State private var isLoadingItems = true
    @State private var sortType: SortType = .ascending
    
    var body: some View {
        NavigationView {
            if isLoadingItems {
                ProgressView("Loading items...")
                    .task {
                        await getItems()
                    }
            } else {
                List {
                    ForEach(1..<5) { index in
                        Section {
                            if filterItems(index: index).count == 0 {
                                Text("No items of LIST ID \(index) were found.")
                            } else {
                                ForEach(filterItems(index: index)) { item in
                                    Text(item.unwrappedName)
                                }
                            }
                        } header: {
                            Text("LIST ID: \(index)")
                        }
                    }
                }
                .navigationTitle("Items")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button("Ascending") {
                                sortType = .ascending
                            }
                            
                            Button("Descending") {
                                sortType = .descending
                            }
                        } label: {
                            Text(sortType == .ascending ? "Ascending" : "Descending")
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    func getItems() async {
        let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([Item].self, from: data)
            items = decodedData
        } catch {
            items = []
            print("Error retrieving data: \(error.localizedDescription)")
        }
        
        isLoadingItems = false
    }
    
    func filterItems(index: Int) -> [Item] {
        if searchText.isEmpty {
            if sortType == .ascending {
                return items.filter { $0.name != nil && $0.name != "" && $0.listId == index }.sorted { $0.unwrappedName < $1.unwrappedName }
            } else {
                return items.filter { $0.name != nil && $0.name != "" && $0.listId == index }.sorted { $0.unwrappedName > $1.unwrappedName }
            }
        } else {
            if sortType == .ascending {
                return items.filter { $0.name != nil && $0.name != "" && $0.listId == index && $0.unwrappedName.contains(searchText) }.sorted { $0.unwrappedName < $1.unwrappedName }
            } else {
                return items.filter { $0.name != nil && $0.name != "" && $0.listId == index && $0.unwrappedName.contains(searchText) }.sorted { $0.unwrappedName > $1.unwrappedName }
            }
        }
    }
}

#Preview {
    ContentView()
}
