//
//  CityStorageProtocol.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import Combine

protocol CityStorageProtocol {
    func fetchCities(page: Int, pageSize: Int) async throws -> [City]
}
