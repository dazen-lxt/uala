//
//  CityStorageProtocol.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 25/03/25.
//

protocol CityStorageProtocol {
    // MARK: - Cities
    func fetchPagedCitiesFromCoreData(prefix: String, page: Int, pageSize: Int) throws -> [City]
    func hasStoredCities() throws -> Bool
    func saveCities(_ cities: [City]) async
    
    // MARK: - Favorites
    func fetchFavorites() async throws -> [Int]
    func addFavorite(_ cityId: Int) async throws
    func removeFavorite(_ cityId: Int) async throws
}
