//
//  PronounceContainer.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import Foundation
import CoreData

class PronounceContainer {
    let persistentContainer: NSPersistentContainer
    init() {
        persistentContainer = NSPersistentContainer(name: "PronounceModels")
        //        persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.loadPersistentStores { _, _ in }
        
    }
}
