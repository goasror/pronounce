//
//  PageView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import CoreData

struct PageView: View {
    @ObservedObject var page: PageEntity
    @Binding var showControlBar: Bool
    @Environment(\.managedObjectContext) var moc
    
    @State private var showRecords = false
    @State private var showSentences = false
    @State private var currectAction: ControlBarActionType?
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: page.viewPageImage)
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                if showControlBar {
                    ControlBarView(page: page, showRecords: $showRecords, showSentences: $showSentences, currentAction: $currectAction)
                        .transition(.move(edge: .bottom).combined(with: .opacity).animation(.bouncy))
                }
            }
            .onTapGesture {
                    showControlBar.toggle()
            }
        }
        .sheet(isPresented: $showRecords) {
            RecordsView(page: page)
        }
    }
}


