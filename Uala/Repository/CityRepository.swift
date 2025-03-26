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
    func fetchCities(page: Int, pageSize: Int) async throws -> [City] {
        if !citiesFromService.isEmpty {
            return getPagedCitiesFromService(page: page, pageSize: pageSize)
        }
        if isSeeded == nil {
            isSeeded = try cityStorage.hasStoredCities()
        }
        if isSeeded == false {
            try await loadAllCities()
            cityStorage.saveCities(citiesFromService)
            return getPagedCitiesFromService(page: page, pageSize: pageSize)
        }
        return try cityStorage.fetchPagedCitiesFromCoreData(page: page, pageSize: pageSize)
    }
    
   
    
    private func getPagedCitiesFromService(page: Int, pageSize: Int) -> [City] {
        let start = page * pageSize
        let end = min(start + pageSize, citiesFromService.count)
        guard start < end else { return [] }
        return Array(citiesFromService[start..<end])
    }
    
    // MARK: - Private Methods
    private func loadAllCities() async throws {
        citiesFromService = try await cityService.fetchCities()
    }
    
    
}
