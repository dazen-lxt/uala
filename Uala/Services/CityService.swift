//
//  CityService.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import Foundation

final class CityService: CityServiceProtocol {
    
    // MARK: - Private Properties
    private let baseURL: String = "https://gist.githubusercontent.com/"
    
    // MARK: - Internal Methods
    func fetchCities() async throws -> [City] {
        let endpoint = baseURL.appending("hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")
        
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
           (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([City].self, from: data)
    }
}
