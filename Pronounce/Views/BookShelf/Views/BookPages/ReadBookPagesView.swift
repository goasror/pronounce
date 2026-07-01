//
//  BookPagesView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import CoreData

struct ReadBookPagesView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var book: BookEntity
    var lastIndex: Int
    
    @State var pageIndex: Int
    @State private var showScanner: Bool = false
    @State private var showControlBar = false
    
    init(book: BookEntity, lastIndex: Int) {
        self.book = book
        self.lastIndex = lastIndex
        self.pageIndex = lastIndex
    }
    
    
    var body: some View {
        NavigationStack {
            PagingList(axis: .horizontal, data: book.viewPageEntities, currentIndex: $pageIndex/*, canContentScroll: true*/) { page in
                PageView(page: page, showControlBar: $showControlBar)
            }
        }
        .onDisappear {
            try? moc.save()
            print("Progress saved at page \(pageIndex)")
        }
        .task(id: pageIndex) {
            guard pageIndex < book.viewPageEntities.count else { return }
            if book.lastViewedPage != Int64(pageIndex) {
                book.lastViewedPage = Int64(pageIndex)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    showScanner = true
                } label: {
                    Text("Add new Page")
                }
                .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 32))
            }
        }
        .sheet(isPresented: $showScanner) {
            DocumentScanner { images in
                for image in images {
                    let newPage = PageEntity(context: moc)
                    newPage.pageImage = image.pngData()
                    book.addToPageEntities(newPage)
                }
                do {
                    try moc.save()
                    withAnimation {
                        self.pageIndex = book.viewPageEntities.count - 1
                    }
                } catch {
                    print("Save failed")
                }
                showScanner = false
            } onCancel: {
                showScanner = false
            }
        }
    }
}
