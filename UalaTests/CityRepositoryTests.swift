//
//  CityRepositoryTests.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 25/03/25.
//

import XCTest
@testable import Uala

final class CityRepositoryTests: XCTestCase {

    var mockService: MockCityService!
    var mockStorage: MockCityStorage!
    var repository: CityRepository!

    override func setUp() {
        super.setUp()
        mockService = MockCityService()
        mockStorage = MockCityStorage()
        repository = CityRepository(cityService: mockService, cityStorage: mockStorage)
    }

    func test_fetchCities_firstSession_loadsFromService_andSaves() async throws {
        mockService.cities = (0..<10).map {
            City(id: $0, country: "X", name: "City \($0)", coord: .init(lat: 0, lon: 0))
        }
        mockStorage.stored = false
        let _ = try await repository.fetchCities(prefix: "", page: 0, pageSize: 5)
        XCTAssertEqual(mockStorage.saveCalled, true)
        XCTAssertEqual(mockStorage.fetchCalled, true)
    }

    func test_fetchCities_whenAlreadySeeded_fetchesFromCoreData() async throws {
        mockStorage.stored = true
        mockStorage.stubbedCities = [.init(id: 1, country: "AR", name: "X", coord: .init(lat: 0, lon: 0))]

        let result = try await repository.fetchCities(prefix: "", page: 0, pageSize: 10)

        XCTAssertEqual(result.first?.id, 1)
        XCTAssertTrue(mockStorage.fetchCalled)
    }
    
    func test_addFavorite_addsToStorage() async throws {
        try await repository.addFavorite(777)
        let stored = try await mockStorage.fetchFavorites()
        XCTAssertTrue(stored.contains(777))
    }

    func test_removeFavorite_removesFromStorage() async throws {
        try await repository.addFavorite(555)
        try await repository.removeFavorite(555)
        let stored = try await mockStorage.fetchFavorites()
        XCTAssertFalse(stored.contains(555))
    }

    func test_fetchFavorites_readsFromStorage() async throws {
        try await mockStorage.addFavorite(12)
        try await mockStorage.addFavorite(34)
        let favorites = try await repository.fetchFavorites()
        XCTAssertEqual(Set(favorites), Set([12, 34]))
    }
}

final class MockCityService: CityServiceProtocol {
    var cities: [City] = []

    func fetchCities() async throws -> [City] {
        cities
    }
}

final class MockCityStorage: CityStorageProtocol {
    var stored = false
    var saveCalled = false
    var fetchCalled = false
    var stubbedCities: [City] = []
    var storedFavorites: Set<Int> = []

    func fetchPagedCitiesFromCoreData(prefix: String, page: Int, pageSize: Int) throws -> [City] {
        fetchCalled = true
        return stubbedCities
    }

    func hasStoredCities() throws -> Bool {
        stored
    }

    func saveCities(_ cities: [City]) {
        saveCalled = true
    }
    
    func fetchFavorites() async throws -> [Int] {
        return Array(storedFavorites)
    }

    func addFavorite(_ cityId: Int) async throws {
        storedFavorites.insert(cityId)
    }

    func removeFavorite(_ cityId: Int) async throws {
        storedFavorites.remove(cityId)
    }
}
