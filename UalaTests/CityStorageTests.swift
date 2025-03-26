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

    func test_saveCities_persistsData() {
        let expectation = expectation(description: "Wait for saveCities")
        let city = City(id: 1, country: "AR", name: "Buenos Aires", coord: Coordinate(lat: -34.6, lon: -58.4))

        storage.saveCities([city])

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
            let results = try? self.coreDataStack.context.fetch(request)
            XCTAssertEqual(results?.count, 1)
            XCTAssertEqual(results?.first?.name, "Buenos Aires")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func test_fetchPagedCitiesFromCoreData_returnsCorrectPage() throws {
        for i in 0..<10 {
            let entity = CityEntity(context: coreDataStack.context)
            entity.id = Int64(i)
            entity.name = "City \(i)"
            entity.country = "Test"
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
        entityA.latitude = 0
        entityA.longitude = 0
        let entityB = CityEntity(context: coreDataStack.context)
        entityB.id = 2
        entityB.name = "B City"
        entityB.country = "Test"
        entityB.latitude = 0
        entityB.longitude = 0
        let entityC = CityEntity(context: coreDataStack.context)
        entityC.id = 3
        entityC.name = "W City"
        entityC.country = "Test"
        entityC.latitude = 0
        entityC.longitude = 0
        try coreDataStack.context.save()

        let data = try storage.fetchPagedCitiesFromCoreData(prefix: "W", page: 0, pageSize: 5)
        XCTAssertEqual(data.count, 1)
        XCTAssertEqual(data[0].id, 3)
        XCTAssertEqual(data[0].name, "W City")
        XCTAssertEqual(data[0].country, "Test")
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
}
