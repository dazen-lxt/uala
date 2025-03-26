//
//  MockCityRepository.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 26/03/25.
//

#if DEBUG

final class MockCityRepository: CityRepositoryProtocol {
    
    
    private let totalCities: Int
    private var allCities: [City] = []
    private var favorites = [2, 3, 5, 11, 101]

    init(totalCities: Int = 10) {
        self.totalCities = totalCities
    }
    
    func fetchCities(prefix: String, page: Int, pageSize: Int) async throws -> [City] {
        try await Task.sleep(for: .seconds(0.5))
        if allCities.isEmpty {
            generateCities()
        }
        let filteredCities = allCities.filter { city in
            city.name.lowercased().hasPrefix(prefix.lowercased())
        }
        let start = page * pageSize
        let end = min(start + pageSize, filteredCities.count)
        guard start < end else { return [] }

        return Array(filteredCities[start..<end])
    }
    
    private func generateCities() {
        let baseCities = City.sampleCities
        for i in 0..<totalCities {
            if let randomCity = baseCities.randomElement() {
                let uniqueCity = City(
                    id: i + 1,
                    country: randomCity.country,
                    name: "\(randomCity.name) \(i + 1)",
                    coord: randomCity.coord
                )
                allCities.append(uniqueCity)
            }
        }
        allCities.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    func fetchFavorites() async throws -> [Int] {
        return favorites
    }
    
    func addFavorite(_ cityId: Int) async throws {
        favorites.append(cityId)
    }
    
    func removeFavorite(_ cityId: Int) async throws {
        favorites.removeAll(where: { $0 == cityId })
    }
}

#endif

