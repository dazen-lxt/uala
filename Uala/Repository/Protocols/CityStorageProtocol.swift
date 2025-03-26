//
//  CityStorageProtocol.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 25/03/25.
//

protocol CityStorageProtocol {
    func fetchPagedCitiesFromCoreData(prefix: String, page: Int, pageSize: Int) throws -> [City]
    func hasStoredCities() throws -> Bool
    func saveCities(_ cities: [City])
}
