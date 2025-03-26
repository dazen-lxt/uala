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

        let result = try await repository.fetchCities(prefix: "", page: 0, pageSize: 5)

        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(mockStorage.saveCalled, true)
        XCTAssertFalse(mockStorage.fetchCalled)
    }

    func test_fetchCities_withCachedServiceData_returnsFromMemory() async throws {
        mockService.cities = (0..<10).map {
            City(id: $0, country: "X", name: "City \($0)", coord: .init(lat: 0, lon: 0))
        }
        mockStorage.stored = false

        let _ = try await repository.fetchCities(prefix: "", page: 0, pageSize: 10)
        let cached = try await repository.fetchCities(prefix: "", page: 0, pageSize: 5)
        
        XCTAssertFalse(mockStorage.fetchCalled)
        XCTAssertEqual(mockStorage.saveCalled, true)
        XCTAssertEqual(cached.count, 5)
    }

    func test_fetchCities_whenAlreadySeeded_fetchesFromCoreData() async throws {
        mockStorage.stored = true
        mockStorage.stubbedCities = [.init(id: 1, country: "AR", name: "X", coord: .init(lat: 0, lon: 0))]

        let result = try await repository.fetchCities(prefix: "", page: 0, pageSize: 10)

        XCTAssertEqual(result.first?.id, 1)
        XCTAssertTrue(mockStorage.fetchCalled)
    }
    
    func test_fetchCities_withCachedServiceData_returnsFilteredData() async throws {
        mockService.cities = ["AA", "BA", "ZZ", "BC", "AB", "CC"].enumerated().map { index, letters in
            City(id: index, country: "X", name: "City \(letters)", coord: .init(lat: 0, lon: 0))
        }
        mockStorage.stored = false

        let result = try await repository.fetchCities(prefix: "City B", page: 0, pageSize: 5)
        
        XCTAssertFalse(mockStorage.fetchCalled)
        XCTAssertEqual(mockStorage.saveCalled, true)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.map(\.name), ["City BA", "City BC"])
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
}
