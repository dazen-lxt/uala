//
//  CityStorageProtocol.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import Combine

protocol CityRepositoryProtocol {
    func fetchCities(prefix: String, page: Int, pageSize: Int) async throws -> [City]
    func fetchFavorites() async throws -> [Int]
    func addFavorite(_ cityId: Int) async throws
    func removeFavorite(_ cityId: Int) async throws
}
