//
//  BookCoverPickerView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI

struct BookCoverPicker: View {
    @Binding var bookCover: UIImage?
    @Binding var microAnimationCover: Bool
    var onTap: () -> Void

    var body: some View {
        VStack {
            if let bookCover {
                Image(uiImage: bookCover)
                    .resizable()
                    .scaledToFill()
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(alignment: .topTrailing) {
                        Button {
                            withAnimation { self.bookCover = nil }
                        } label: {
                            Image(systemName: "xmark")
                                
                        }
                        .buttonStyle(OutlinedButtonCircle(width: 20, height: 20))
                        .foregroundStyle(.red)
                        .padding()
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1)
                    VStack {
                        Image(systemName: "photo")
                        Text("Book Cover")
                    }
                    .font(.title)
                }
                .contentShape(.rect)
                .onTapGesture(perform: onTap)
                .shake(trigger: $microAnimationCover)
            }
        }
        .padding(20)
        .transition(.opacity)
    }
}
