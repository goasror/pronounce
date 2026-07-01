//
//  ScriptCard.swift
//  Pronounce
//
//  Created by asror on 08/02/26.
//

import SwiftUI
import CoreData
import Combine

struct ScriptCard: View {
    let script: ScriptEntity
    var scriptUIImage: UIImage {
        if let data = script.viewScriptData {
            UIImage(data: data) ?? UIImage(systemName: "scribble")!
        } else {
            UIImage(systemName: "scribble")!
        }
    }
    var body: some View {
        VStack(spacing: 10) {
            Image(uiImage: scriptUIImage)
                .resizable()
                .scaledToFit()
            Text(script.viewCreatedDate, style: .date)
                .foregroundStyle(.secondary)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 1)
        }
    }
}
