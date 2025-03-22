//
//  CitiyServiceProtocol.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import Combine

protocol CityServiceProtocol {
    func fetchCities() async throws -> [City]
}
