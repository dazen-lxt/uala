//
//  AppContainer.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

struct AppContainer {
    
    func makeCityListView() -> CityListView {
        let cityService = CityService()
        let cityStorage = CityStorage(cityService: cityService)
        let cityListViewModel = CityListViewModel(cityStorage: cityStorage)
        return CityListView(cityListViewModel: cityListViewModel)
    }
}
