//
//  CityStorageTests.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 25/03/25.
//

import XCTest
import CoreData
@testable import Uala

final class CityStorageTests: XCTestCase {

    var storage: CityStorage!
    var coreDataStack: CoreDataStack!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(inMemory: true)
        storage = CityStorage(context: coreDataStack.context)
    }

    func test_saveCities_persistsData() async {
        let city = City(id: 1, country: "AR", name: "Buenos Aires", coord: Coordinate(lat: -34.6, lon: -58.4))

        await storage.saveCities([city])

        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        let results = try? self.coreDataStack.context.fetch(request)
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.name, "Buenos Aires")
    }

    func test_fetchPagedCitiesFromCoreData_returnsCorrectPage() throws {
        for i in 0..<10 {
            let entity = CityEntity(context: coreDataStack.context)
            entity.id = Int64(i)
            entity.name = "City \(i)"
            entity.country = "Test"
            entity.searchKey = "City \(i), Test"
            entity.latitude = 0
            entity.longitude = 0
        }
        try coreDataStack.context.save()

        let page = try storage.fetchPagedCitiesFromCoreData(prefix: "", page: 1, pageSize: 5)
        XCTAssertEqual(page.count, 5)
    }
    
    func test_fetchPagedCitiesFromCoreData_returnsCorrectPrefix() throws {
        let entityA = CityEntity(context: coreDataStack.context)
        entityA.id = 1
        entityA.name = "Z City"
        entityA.country = "Test"
        entityA.searchKey = "Z City, Test"
        entityA.latitude = 0
        entityA.longitude = 0
        let entityB = CityEntity(context: coreDataStack.context)
        entityB.id = 2
        entityB.name = "B City"
        entityB.country = "Test"
        entityB.searchKey = "B City, Test"
        entityB.latitude = 0
        entityB.longitude = 0
        let entityC = CityEntity(context: coreDataStack.context)
        entityC.id = 3
        entityC.name = "W City"
        entityC.country = "Test"
        entityC.searchKey = "W City, Test"
        entityC.latitude = 0
        entityC.longitude = 0
        try coreDataStack.context.save()

        let data = try storage.fetchPagedCitiesFromCoreData(prefix: "w", page: 0, pageSize: 5)
        XCTAssertEqual(data.count, 1)
        XCTAssertEqual(data[0].id, 3)
        XCTAssertEqual(data[0].name, "W City")
        XCTAssertEqual(data[0].country, "Test")
        XCTAssertEqual(data[0].searchKey, "W City, Test")
    }

    func test_hasStoredCities_whenEmpty_returnsFalse() throws {
        XCTAssertFalse(try storage.hasStoredCities())
    }

    func test_hasStoredCities_whenDataExists_returnsTrue() throws {
        let entity = CityEntity(context: coreDataStack.context)
        entity.id = 99
        try coreDataStack.context.save()

        XCTAssertTrue(try storage.hasStoredCities())
    }
    
    func test_addFavorite_savesFavorite() async throws {
        try await storage.addFavorite(42)
        let ids = try await storage.fetchFavorites()
        XCTAssertTrue(ids.contains(42))
    }

    func test_addFavorite_doesNotDuplicate() async throws {
        try await storage.addFavorite(42)
        try await storage.addFavorite(42)
        let ids = try await storage.fetchFavorites()
        XCTAssertEqual(ids.filter { $0 == 42 }.count, 1)
    }

    func test_removeFavorite_deletesFavorite() async throws {
        try await storage.addFavorite(100)
        try await storage.removeFavorite(100)
        let ids = try await storage.fetchFavorites()
        XCTAssertFalse(ids.contains(100))
    }

    func test_fetchFavorites_returnsAllSavedFavorites() async throws {
        try await storage.addFavorite(1)
        try await storage.addFavorite(2)
        try await storage.addFavorite(3)

        let favorites = try await storage.fetchFavorites()
        XCTAssertEqual(Set(favorites), Set([1, 2, 3]))
    }
}
