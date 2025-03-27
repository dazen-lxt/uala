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
    private var isSeeded: Bool?
    
    // MARK: - Initializer
    init(cityService: CityServiceProtocol, cityStorage: CityStorageProtocol) {
        self.cityService = cityService
        self.cityStorage = cityStorage
    }
    
    // MARK: - Internal Methods
    func fetchCities(prefix: String, page: Int, pageSize: Int) async throws -> [City] {
        if isSeeded == nil {
            isSeeded = try cityStorage.hasStoredCities()
        }
        if isSeeded == false {
            let citiesFromService = try await cityService.fetchCities()
            await cityStorage.saveCities(citiesFromService)
            isSeeded = true
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
    
}
