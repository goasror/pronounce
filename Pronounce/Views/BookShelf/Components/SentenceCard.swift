//
//  SentenceCard.swift
//  Pronounce
//
//  Created by asror on 08/02/26.
//

import SwiftUI
import Combine


struct SentenceCard: View {
    @ObservedObject var sentence: SentenceEntity
    @State private var collapsed: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        collapsed.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .rotationEffect(collapsed ? Angle(degrees: 0) : Angle(degrees: 180))
                }
                .buttonStyle(OutlinedButtonCircle(width: 44, height: 44, lineWidth: 1))
                .padding()
                NavigationLink {
                    SentenceScrollView(sentence: sentence, currentIndex: 0)
                } label: {
                    HStack {
                        Text(sentence.viewSentenceText)
                            .bold()
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical)
                    .padding(.trailing)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

            }
            if collapsed {
                ForEach(0..<sentence.viewWords.count, id: \.self) { index in
                    VStack {
                        Divider()
                        NavigationLink {
                            SentenceScrollView(sentence: sentence, currentIndex: index)
                        } label: {
                            HStack {
                                Text(sentence.viewWords[index].viewWordText)
                                    .padding(.bottom)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 1)
        }
    }
}
