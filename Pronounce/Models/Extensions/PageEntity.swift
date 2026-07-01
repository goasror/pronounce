//
//  PageEntity.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import CoreData
import UIKit

extension PageEntity {
    var viewPageImage: UIImage {
        if let data = self.pageImage {
            UIImage(data: data) ?? UIImage(systemName: "text.page")!
        } else {
            UIImage(systemName: "text.page")!
        }
    }
    var viewSentences: [SentenceEntity] {
        self.sentenceEntities?.array as? [SentenceEntity] ?? []
    }
    var viewRecords: [RecordEntity] {
        self.recordEntites?.array as? [RecordEntity] ?? []
    }
    
    var viewRelatedBook: BookEntity? {
        self.bookEntity
    }
    var viewLanguage: Languages {
        if let languageCode = viewRelatedBook?.bookLanguage {
            return Languages.from(languageCode)
        }
        return .none
    }
}
