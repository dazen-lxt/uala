//
//  CityViewModel.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import Combine

class CityListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var cities: [City] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    private let cityRepostiory: CityRepositoryProtocol
    private var nextPage = 0
    private let pageSize = 20
    
    // MARK: - Initializer
    init(cityRepostiory: CityRepositoryProtocol) {
        self.cityRepostiory = cityRepostiory
    }
    
    // MARK: - Internal Methods
    @MainActor
    func loadMoreCities() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let data = try await cityRepostiory.fetchCities(page: nextPage, pageSize: pageSize)
            nextPage += 1
            self.cities.append(contentsOf: data)
        } catch {
            print("❌ Error fetching cities: \(error.localizedDescription)")
        }
    }
}
