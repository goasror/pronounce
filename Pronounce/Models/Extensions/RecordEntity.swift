//
//  RecordEntity.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import CoreData

extension RecordEntity {
    var viewRecordData: Data? {
        self.recordData
    }
    var viewCreatedDate: Date {
        self.createdDate ?? .now
    }
    
    var viewRelatedWord: WordEntity? {
        self.wordEntity
    }
    var viewRelatedSentence: SentenceEntity? {
        self.sentenceEntity
    }
    var viewRelatedPage: PageEntity? {
        self.pageEntity
    }
}
