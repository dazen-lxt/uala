//
//  CityListViewModelTests.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 26/03/25.
//

import XCTest
@testable import Uala

final class CityListViewModelTests: XCTestCase {
    var viewModel: CityListViewModel!
    var mockRepo: MockCityRepository!

    override func setUp() {
        super.setUp()
        mockRepo = MockCityRepository(total: 50)
        viewModel = CityListViewModel(cityRepostiory: mockRepo)
    }

    func test_initialLoad_fetchesFirstPage() async {
        await viewModel.loadCities(reset: false)
        XCTAssertEqual(viewModel.cities.count, 20)
    }

    func test_resetLoad_clearsDataAndLoadsFresh() async {
        await viewModel.loadCities(reset: false)
        XCTAssertEqual(viewModel.cities.count, 20)

        await viewModel.loadCities(reset: true)
        XCTAssertEqual(viewModel.cities.count, 20)
    }

    func test_allDataLoaded_stopsFurtherFetches() async {
        for _ in 0..<3 {
            await viewModel.loadCities(reset: false)
        }
        let previousCount = viewModel.cities.count
        await viewModel.loadCities(reset: false)
        XCTAssertEqual(viewModel.cities.count, previousCount)
    }

    func test_filterTerm_triggersDebouncedSearch() async {
        viewModel.filterTerm = "City 4"

        try? await Task.sleep(nanoseconds: 1_000_000_000)

        XCTAssertTrue(viewModel.cities.contains { $0.name.contains("4") })
    }

    func test_loadMoreIfNeeded_loadsNextPage() async {
        await viewModel.loadCities(reset: true)
        let initialCount = viewModel.cities.count

        await viewModel.loadMoreIfNeeded(for: initialCount - 1)

        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertGreaterThan(viewModel.cities.count, initialCount)
    }
}

final class MockCityRepository: CityRepositoryProtocol {
    var allCities: [City] = []

    init(total: Int = 20) {
        allCities = (0..<total).map {
            City(id: $0, country: "AR", name: "City \($0)", coord: .init(lat: 0, lon: 0))
        }
    }

    func fetchCities(prefix: String, page: Int, pageSize: Int) async throws -> [City] {
        let filtered = allCities.filter { $0.name.lowercased().hasPrefix(prefix.lowercased()) || prefix.isEmpty }
        let start = page * pageSize
        let end = min(start + pageSize, filtered.count)
        if end > start {
            return Array(filtered[start..<end])
        } else {
            return []
        }
    }
}
