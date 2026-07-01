//
//  BookEntity.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import CoreData
import UIKit

extension BookEntity {
    var viewBookName: String {
        self.bookName ?? ""
    }
    var viewBookAuthor: String {
        self.bookAuthor ?? ""
    }
    var viewBookCover: UIImage {
        if let data = self.bookCover {
            UIImage(data: data) ?? UIImage(systemName: "text.book.closed")!
        } else {
            UIImage(systemName: "text.book.closed")!
        }
    }
    var viewNewPageIndex: Int64 {
        self.newPageIndex
    }
    var viewLastViewedPage: Int {
        Int(self.lastViewedPage)
    }
    var viewPageEntities: [PageEntity] {
        self.pageEntities?.array as? [PageEntity] ?? []
    }
    var viewSentences: [SentenceEntity] {
        let pages = self.viewPageEntities
        var sentences: [SentenceEntity] = []
        for page in pages {
            sentences.append(contentsOf: page.viewSentences)
        }
        return sentences
    }
    var viewWords: [WordEntity] {
        let sentences = self.viewSentences
        var words: [WordEntity] = []
        for sentence in sentences {
            words.append(contentsOf: sentence.viewWords)
        }
        return words
    }
    var viewScripts: [ScriptEntity] {
        let words = self.viewWords
        var scripts: [ScriptEntity] = []
        for word in words {
            scripts.append(contentsOf: word.viewScripts)
        }
        return scripts
    }
    var viewRecords: [RecordEntity] {
        var records: [RecordEntity] = []
        for page in self.viewPageEntities {
            records.append(contentsOf: page.viewRecords)
        }
        for sentence in self.viewSentences {
            records.append(contentsOf: sentence.viewRecords)
        }
        for word in self.viewWords {
            records.append(contentsOf: word.viewRecords)
        }
        return records
    }
}
