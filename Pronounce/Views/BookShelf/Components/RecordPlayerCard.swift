//
//  RecordPlayerCard.swift
//  Pronounce
//
//  Created by asror on 07/02/26.
//

import SwiftUI

struct RecordPlayerCard: View {
    let recordEntity: RecordEntity
    let player: RecordPlayer
    @State private var isPlaying: Bool = false
    var body: some View {
        Button {
            if isPlaying {
                player.stop()
                isPlaying = false
            } else {
                if let data = recordEntity.viewRecordData {
                    isPlaying = true
                    player.play(recordData: data)
                }
            }
        } label: {
            HStack {
                Circle()
                    .fill(.clear)
                    .frame(width: 44, height: 44)
                    .overlay {
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 2)
                            Image(systemName: isPlaying ? "stop" : "play")
                                .font(.title3)
                        }
                    }
                    .padding()
                Text(recordEntity.viewCreatedDate, style: .date)
                Spacer()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
            }
        }
    }
}
