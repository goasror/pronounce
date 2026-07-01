//
//  BookContentsFilter.swift
//  Pronounce
//
//  Created by asror on 09/02/26.
//

import SwiftUI

enum BookContentsFilter: CaseIterable {
    case gallery, pages, sentences, words, records, scripts
    
    var text: String {
        switch self {
        case .gallery:
            "Gallery"
        case .pages:
            "Pages"
        case .sentences:
            "Sentences"
        case .words:
            "Words"
        case .records:
            "Records"
        case .scripts:
            "Scripts"
        }
    }
}

struct BookContentsFilterView: View {
    @Binding var currentSelection: BookContentsFilter
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(BookContentsFilter.allCases, id: \.self) { item in
                    Button {
                        if currentSelection != item {
                            currentSelection = item
                        }
                    } label: {
                        Text(item.text)
                    }
                    .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 44, withSpacer: false, lineWidth: 1))
                    .foregroundStyle(currentSelection == item ? .primary : .secondary)
                }
            }
        }
    }
}
