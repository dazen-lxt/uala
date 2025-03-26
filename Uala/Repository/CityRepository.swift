//
//  CityRepository.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 22/03/25.
//


final class CityRepository: CityRepositoryProtocol {
    
    // MARK: - Private Properties
    private let cityService: CityServiceProtocol
    private let cityStorage: CityStorageProtocol
    private var citiesFromService: [City] = []
    private var isSeeded: Bool?
    
    // MARK: - Initializer
    init(cityService: CityServiceProtocol, cityStorage: CityStorageProtocol) {
        self.cityService = cityService
        self.cityStorage = cityStorage
    }
    
    // MARK: - Internal Methods
    func fetchCities(prefix: String, page: Int, pageSize: Int) async throws -> [City] {
        if !citiesFromService.isEmpty {
            return getPagedCitiesFromCachedService(prefix: prefix, page: page, pageSize: pageSize)
        }
        if isSeeded == nil {
            isSeeded = try cityStorage.hasStoredCities()
        }
        if isSeeded == false {
            try await loadAllCities()
            cityStorage.saveCities(citiesFromService)
            return getPagedCitiesFromCachedService(prefix: prefix, page: page, pageSize: pageSize)
        }
        return try cityStorage.fetchPagedCitiesFromCoreData(prefix: prefix, page: page, pageSize: pageSize)
    }
    
    func fetchFavorites() async throws -> [Int] {
        return try await cityStorage.fetchFavorites()
    }
    
    func addFavorite(_ cityId: Int) async throws {
        try await cityStorage.addFavorite(cityId)
    }
    
    func removeFavorite(_ cityId: Int) async throws {
        try await cityStorage.removeFavorite(cityId)
    }
    
    // MARK: - Private Methods
    private func getPagedCitiesFromCachedService(prefix: String, page: Int, pageSize: Int) -> [City] {
        let filteredCities = citiesFromService
            .filter { city in
                city.name.lowercased().hasPrefix(prefix.lowercased())
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        let start = page * pageSize
        let end = min(start + pageSize, filteredCities.count)
        guard start < end else { return [] }
        return Array(filteredCities[start..<end])
    }
    
    private func loadAllCities() async throws {
        citiesFromService = try await cityService.fetchCities()
    }
    
    
}
