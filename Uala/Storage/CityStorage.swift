//
//  CityStorage.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import CoreData

final class CityStorage: CityStorageProtocol {
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Initializer
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Internal Methods
    func fetchPagedCitiesFromCoreData(prefix: String, page: Int, pageSize: Int) throws -> [City] {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        request.fetchOffset = page * pageSize
        request.fetchLimit = pageSize
        if !prefix.isEmpty {
            request.predicate = NSPredicate(format: "name BEGINSWITH[cd] %@", prefix)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        let results = try context.fetch(request)
        return results.map {
            City(
                id: Int($0.id),
                country: $0.country ?? "",
                name: $0.name ?? "",
                coord: Coordinate(lat: $0.latitude, lon: $0.longitude)
            )
        }
    }
    
    func hasStoredCities() throws -> Bool {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        request.fetchLimit = 1
        let count = try context.count(for: request)
        return count > 0
    }
    
    func saveCities(_ cities: [City]) {
        context.perform { [weak self] in
            guard let self else { return }
            for city in cities {
                let entity = CityEntity(context: context)
                entity.id = Int64(city.id)
                entity.name = city.name
                entity.country = city.country
                entity.latitude = city.coord.lat
                entity.longitude = city.coord.lon
            }

            do {
                try context.save()
            } catch {
                print("❌ Error saving cities: \(error)")
                context.rollback()
            }
        }
    }
}
