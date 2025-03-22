//
//  CityStorage.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

final class CityStorage: CityStorageProtocol {
    
    // MARK: - Private Properties
    private var cityService: CityServiceProtocol
    private var cities: [City] = []
    
    // MARK: - Initializer
    init(cityService: CityServiceProtocol) {
        self.cityService = cityService
    }
    
    // MARK: - Internal Methods
    func fetchCities(page: Int, pageSize: Int) async throws -> [City] {
        if cities.isEmpty {
            try await loadAllCities()
        }
        let start = page * pageSize
        let end = min(start + pageSize, cities.count)
        guard start < end else { return [] }
        return Array(cities[start..<end])
    }
    
    // MARK: - Private Methods
    private func loadAllCities() async throws {
        cities = try await cityService.fetchCities()
    }
    
}
