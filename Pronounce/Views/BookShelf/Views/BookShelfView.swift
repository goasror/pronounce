//
//  BookShelfView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import CoreData

struct BookShelfView: View {
    @Namespace var animation
    @State private var showSettings: Bool = false
    @State private var bookIndex: Int = 0
    
    @FetchRequest<BookEntity>(sortDescriptors: [SortDescriptor(\.bookName)]) var books
    @State private var currentIndex: Int = 0
    
    var body: some View {
            NavigationStack {
                VStack {
                    PagingList(axis: .horizontal, data: books, currentIndex: $currentIndex/*, canContentScroll: true*/) { book in
                        BookCardView(book: book)
                    }
                    bottomToolbar
                }
                .navigationTitle("Book Shelf")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            AddABookView()
                        } label: {
                            Text("Add a Book")
                        }
                        .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 32, withSpacer: false))
                    }
                }
                .sheet(isPresented: $showSettings) {
                    EmptyView()
                }
            }
    }
    
    var bottomToolbar: some View {
        HStack(spacing: 20) {
//            Button {
//                showSettings = true
//            } label: {
//                Image(systemName: "gear")
//                    .font(.title2)
//                    .padding()
//            }
//            .buttonStyle(OutlinedButtonCircle(width: 72, height: 72))
            Spacer()
            NavigationLink {
                SearchView(animation: animation)
            } label: {
                HStack {
//                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .matchedGeometryEffect(id: "symbol", in: animation)
//                    Text("Search Words")
//                    Spacer()
                }
                .font(.title2)
                .frame(width: 72, height: 72)
                .background {
//                    RoundedRectangle(cornerRadius: 32)
                    RoundedRectangle(cornerRadius: 36)
                        .fill(.background)
                        .opacity(0.8)
                }
                .overlay {
//                    RoundedRectangle(cornerRadius: 32)
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(lineWidth: 2)
                        .matchedGeometryEffect(id: "searchBorder", in: animation)
                }
            }
            .foregroundStyle(.primary)
        }
        .padding()
    }
}
