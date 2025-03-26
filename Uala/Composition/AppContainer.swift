//
//  AppContainer.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

struct AppContainer {
    
    private let coreDataStack = CoreDataStack()
    
    func makeCityListView() -> CityListView {
        let cityService = CityService()
        let cityStorage = CityStorage(context: coreDataStack.context)
        let cityRepostiory = CityRepository(cityService: cityService, cityStorage: cityStorage)
        let cityListViewModel = CityListViewModel(cityRepostiory: cityRepostiory)
        return CityListView(cityListViewModel: cityListViewModel)
    }
}
