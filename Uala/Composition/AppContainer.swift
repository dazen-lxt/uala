//
//  AppContainer.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import Foundation

struct AppContainer {
    
    private let coreDataStack = CoreDataStack()
    
    func makeCityListView() -> CityListView {
        let cityRepository: CityRepositoryProtocol
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("UI-TESTING") {
            // MARK: - UI TESTING - Mocks
            let mockCityCount = Int(ProcessInfo.processInfo.environment["MOCK_CITY_COUNT"] ?? "") ?? 200
            cityRepository = MockCityRepository(totalCities: mockCityCount)
        } else {
            // MARK: - Development / Debug build
            let cityService = CityService()
            let cityStorage = CityStorage(context: coreDataStack.context)
            cityRepository = CityRepository(cityService: cityService, cityStorage: cityStorage)
        }
        #else
        // MARK: - Production - Real dependencies
        let cityService = CityService()
        let cityStorage = CityStorage(context: coreDataStack.context)
        cityRepository = CityRepository(cityService: cityService, cityStorage: cityStorage)
        #endif
        let cityListViewModel = CityListViewModel(cityRepostiory: cityRepository)
        return CityListView(cityListViewModel: cityListViewModel)
    }
}
