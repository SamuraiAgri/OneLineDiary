//
//  OneLineDiaryApp.swift
//  OneLineDiary
//
//  Created by rinka on 2025/04/13.
//

import SwiftUI

@main
struct OneLineDiaryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
