//
//  RecordsView.swift
//  Pronounce
//
//  Created by asror on 07/02/26.
//

import SwiftUI
import CoreData
import Combine

struct RecordsView: View {
    @ObservedObject var page: PageEntity
    @StateObject var player = RecordPlayer()
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        NavigationStack {
            List {
                ForEach(page.viewRecords) { record in
                    RecordPlayerCard(recordEntity: record, player: player)
                }
                .onDelete { indexset in
                    for index in indexset {
                        page.removeFromRecordEntites(at: index)
                    }
                    try? moc.save()
                }
                .listRowSeparator(.hidden)
                .listRowSpacing(4)
            }
            .listStyle(.plain)
            .navigationTitle("Records")
        }
    }
}
