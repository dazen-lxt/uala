//
//  City.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

struct City: Codable, Identifiable, Hashable {
    var id: Int
    var country: String
    var name: String
    var coord: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country
        case name
        case coord
    }
}
