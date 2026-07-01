//
//  WordHistoryView.swift
//  Pronounce
//
//  Created by asror on 08/02/26.
//

import SwiftUI
import Combine
import CoreData

struct WordHistoryView: View {
    @ObservedObject var word: WordEntity
    @State private var showRecords: Bool = true
    @Environment(\.managedObjectContext) var moc
    let player = RecordPlayer()
    @State private var seeScript: ScriptEntity?
    var body: some View {
        NavigationStack {
            if showRecords {
                List {
                    ForEach(word.viewRecords) { record in
                        RecordPlayerCard(recordEntity: record, player: player)
                            .foregroundStyle(.primary)
                    }
                    .onDelete(perform: { indexset in
                        for index in indexset {
                            word.removeFromRecordEntities(at: index)
                        }
                    })
                    .listRowSpacing(10)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle("Records")
                .safeAreaInset(edge: .bottom) {
                    Button {
                        showRecords = false
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Show Scripts")
                        }
                        .font(.title3)
                    }
                    .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 72, withSpacer: true, lineWidth: 2))
                    .padding()
                }
                .transition(.move(edge: .trailing).combined(with: .opacity).animation(.bouncy))
            } else {
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        ForEach(word.viewScripts) { script in
                            ScriptCard(script: script)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        word.removeFromScriptEntities(script)
                                        try? moc.save()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onTapGesture {
                                    seeScript = script
                                }
                        }
                    }
                    .padding(20)
                    .navigationTitle("Scripts")
                }
                .overlay {
                    if let seeScript, let data = seeScript.viewScriptData {
                        let uiImage = UIImage(data: data) ?? UIImage(systemName: "scribble")!
                        VStack {
                            Spacer()
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    withAnimation {
                                        self.seeScript = nil
                                    }
                                }
                                .transition(.identity)
                            Spacer()
                        }
                        .background(.background)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Button {
                        showRecords = true
                    } label: {
                        HStack {
                            Image(systemName: "recordingtape")
                            Text("Show Records")
                        }
                        .font(.title3)
                    }
                    .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 72, withSpacer: true, lineWidth: 2))
                    .padding()
                }
                .transition(.move(edge: .leading).combined(with: .opacity).animation(.bouncy))

            }
        }
    }
}
