//
//  SenteceEntity.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import CoreData

extension SentenceEntity {
    var viewSentenceText: String {
        self.sentenceText ?? ""
    }
    var viewRecords: [RecordEntity] {
        self.recordEntities?.array as? [RecordEntity] ?? []
    }
    var viewWords: [WordEntity] {
        self.wordEntities?.array as? [WordEntity] ?? []
    }
    
    var viewPage: PageEntity? {
        self.pageEntity
    }
    var viewLanguage: Languages? {
        self.viewPage?.viewLanguage
    }
}
