//
//  SampleCities.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 26/03/25.
//

#if DEBUG

extension City {
    static let sampleCities: [City] = [
        City(
            id: 1,
            country: "AR",
            name: "Buenos Aires",
            coord: Coordinate(lat: -34.6037, lon: -58.3816)
        ),
        City(
            id: 2,
            country: "AR",
            name: "Córdoba",
            coord: Coordinate(lat: -31.4201, lon: -64.1888)
        ),
        City(
            id: 3,
            country: "AR",
            name: "Rosario",
            coord: Coordinate(lat: -32.9442, lon: -60.6505)
        ),
        City(
            id: 4,
            country: "AR",
            name: "Mendoza",
            coord: Coordinate(lat: -32.8895, lon: -68.8458)
        )
    ]
}

#endif
