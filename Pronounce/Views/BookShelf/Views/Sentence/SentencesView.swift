//
//  SentencesView.swift
//  Pronounce
//
//  Created by asror on 07/02/26.
//

import SwiftUI
import Combine
import CoreData

struct SentencesView: View {
    @ObservedObject var page: PageEntity
    @Environment(\.managedObjectContext) var moc
//    @Environment(\.dismiss) var dismiss
    
    @State private var rescanning: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack{
                    ForEach(page.viewSentences) { sentence in
                        SentenceCard(sentence: sentence)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Sentences")
            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "xmark")
//                    }
//                    .buttonStyle(OutlinedButtonCircle(width: 32, height: 32, lineWidth: 1))
//                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        rescanning = true
                    } label: {
                        HStack {
                            Image(systemName: "text.viewfinder")
                                .font(.title3)
                            Text(rescanning ? "Scanning" : "Re-Scan")
                        }
                    }
                    .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 32, withSpacer: false))
                    .disabled(rescanning)
                    .foregroundStyle(rescanning ? .secondary : .primary)
                }
            }
            .task {
                page.viewSentences.forEach { sentence in
                    page.removeFromSentenceEntities(sentence)
                }
                try? moc.save()
                await LocalImageProcessor().processImage(for: page, moc: moc)
            }
        }
    }
}
