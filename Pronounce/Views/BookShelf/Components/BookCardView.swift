//
//  BookCardView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI

struct BookCardView: View {
    @ObservedObject var book: BookEntity
    var body: some View {
        VStack {
            VStack {
                Image(uiImage: book.viewBookCover)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Text(book.viewBookName)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            Text(book.viewBookAuthor)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            HStack(spacing: 20) {
//                NavigationLink {
//                    
//                } label: {
//                    Text("Details")
//                }
                NavigationLink {
                    ReadBookPagesView(book: book, lastIndex: book.viewLastViewedPage)
                } label: {
                    HStack {
                        Text("Read")
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 12, height: 40))
        }
        .padding(20)
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(lineWidth: 2)
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
    }
}
