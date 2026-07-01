//
//  WordEntity.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import CoreData

extension WordEntity {
    var viewWordText: String {
        self.wordText ?? ""
    }
    var viewRecords: [RecordEntity] {
        self.recordEntities?.array as? [RecordEntity] ?? []
    }
    var viewScripts: [ScriptEntity] {
        self.scriptEntities?.array as? [ScriptEntity] ?? []
    }
    
    var viewSentence: [SentenceEntity] {
        self.sentenceEntities?.array as? [SentenceEntity] ?? []
    }
}
