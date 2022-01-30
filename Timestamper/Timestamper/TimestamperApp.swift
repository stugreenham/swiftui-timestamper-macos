//
//  TimestamperApp.swift
//  Timestamper
//
//  Created by Stu Greenham on 29/01/2022.
//

import SwiftUI

@main
struct TimestamperApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
