//
//  ScriptEntity.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import CoreData

extension ScriptEntity {
    var viewScriptData: Data? {
        self.scriptData
    }
    var viewCreatedDate: Date {
        self.createdDate ?? .now
    }
    
    var viewRelatedWord: WordEntity? {
        self.wordEntity
    }
}
