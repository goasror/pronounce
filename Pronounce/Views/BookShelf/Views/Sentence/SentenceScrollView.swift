//
//  SentenceScrollView.swift
//  Pronounce
//
//  Created by asror on 08/02/26.
//

import SwiftUI
import CoreData
import Combine

struct SentenceScrollView: View {
    @ObservedObject var sentence: SentenceEntity
    @State var currentIndex: Int
    @State private var isScripting = false
    var body: some View {
        NavigationStack {
            PagingList(axis: .horizontal, data: sentence.viewWords, currentIndex: $currentIndex, canContentScroll: !isScripting) { word in
                WordView(word: word, language: sentence.viewLanguage ?? .none, isScripting: $isScripting)
            }
        }
    }
}
