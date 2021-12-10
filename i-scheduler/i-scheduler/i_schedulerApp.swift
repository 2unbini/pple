//
//  i_schedulerApp.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/06.
//

import SwiftUI
import CoreData

@main
struct i_schedulerApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
