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
    private let preloadOffset = 5
    
    // MARK: - Initializer
    init(cityListViewModel: CityListViewModel) {
        self.cityListViewModel = cityListViewModel
    }
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(cityListViewModel.cities.indices, id: \.self) { index in
                let city = cityListViewModel.cities[index]
                Text(city.name)
                    .onAppear {
                        preloadIfNeeded(for: index)
                    }
            }
        }
        .overlay {
            if cityListViewModel.isLoading && cityListViewModel.cities.isEmpty {
                ProgressView().padding()
            }
        }
        .task {
            await cityListViewModel.loadMoreCities()
        }
    }
    
    // MARK - Private Helpers
    func preloadIfNeeded(for index: Int) {
        if index >= cityListViewModel.cities.count - preloadOffset {
            Task {
                await cityListViewModel.loadMoreCities()
            }
        }
    }
}

#Preview {
    AppContainer().makeCityListView()
}
