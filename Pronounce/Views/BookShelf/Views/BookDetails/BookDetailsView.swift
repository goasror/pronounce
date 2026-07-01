//
//  BookDetailsView.swift
//  Pronounce
//
//  Created by asror on 09/02/26.
//

import SwiftUI
import CoreData
import Combine


struct BookDetailsView: View {
    @ObservedObject var book: BookEntity
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    Image(uiImage: book.viewBookCover)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(height: 400)
                    VStack {
                        Text(book.viewBookName)
                            .font(.title)
                            
                        Text(book.viewBookAuthor)
                            .font(.title2)
                    }
                    .multilineTextAlignment(.leading)
                }
            }
        }
        .ignoresSafeArea()
    }
}
