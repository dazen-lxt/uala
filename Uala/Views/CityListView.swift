//
//  ContentView.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import SwiftUI

struct CityListView: View {
    
    // MARK: - Properties
    @ObservedObject private var cityListViewModel: CityListViewModel
    
    // MARK: - Initializer
    init(cityListViewModel: CityListViewModel) {
        self.cityListViewModel = cityListViewModel
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(cityListViewModel.cities.indices, id: \.self) { index in
                        let city = $cityListViewModel.cities[index]
                        CityCellView(city: city, isFavorite: Binding(
                            get: {
                                cityListViewModel.favorites.contains(city.id)
                            },
                            set: { _ in
                                Task {
                                    await cityListViewModel.toggleFavorite(for: city.id)
                                }
                            }
                        ))
                            .onAppear {
                                Task {
                                    await cityListViewModel.loadMoreIfNeeded(for: index)
                                }
                            }
                    }
                }
                .searchable(text: $cityListViewModel.filterTerm, prompt: "Search")
                if cityListViewModel.isFetching {
                    ProgressView().padding()
                } else if cityListViewModel.cities.isEmpty {
                    Text("No cities found").padding()
                }
                
            }
            .task {
                await cityListViewModel.loadFavorites()
                await cityListViewModel.loadCities(reset: false)
            }
            .navigationTitle("Cities")
        }
        
    }
}

#Preview {
    let cityRepostiory = MockCityRepository(totalCities: 200)
    let cityListViewModel = CityListViewModel(cityRepostiory: cityRepostiory)
    CityListView(cityListViewModel: cityListViewModel)
}
