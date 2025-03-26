//
//  CoreDataStack.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import CoreData

struct CoreDataStack {
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init (inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CityModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }
    }
}
