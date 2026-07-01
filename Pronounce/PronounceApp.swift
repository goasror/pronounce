//
//  PronounceApp.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import CoreData

@main
struct PronounceApp: App {
    var body: some Scene {
        WindowGroup {
            BookShelfView()
                .environment(\.managedObjectContext, PronounceContainer().persistentContainer.viewContext)
        }
    }
}
