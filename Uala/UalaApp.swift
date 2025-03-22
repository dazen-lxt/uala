//
//  UalaApp.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import SwiftUI

@main
struct UalaApp: App {
    
    let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            container.makeCityListView()
        }
    }
}
