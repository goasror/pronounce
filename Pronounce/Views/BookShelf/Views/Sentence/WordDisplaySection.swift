//
//  WordDisplaySection.swift
//  Pronounce
//
//  Created by asror on 08/02/26.
//

import SwiftUI
import CoreData

struct WordDisplaySection: View {
    let word: WordEntity
    let onTap: () -> Void
    let onDoubleTap: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text(word.viewWordText)
                .font(.system(size: 200))
                .minimumScaleFactor(0.1)
                .lineLimit(1)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2, perform: onDoubleTap)
        .onTapGesture(count: 1, perform: onTap)
    }
}
