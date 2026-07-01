//
//  ScriptButton.swift
//  Pronounce
//
//  Created by asror on 08/02/26.
//

import SwiftUI

struct RecordButton: View {
    let systemName: String
    let label: String
    var tint: Color = .primary

    var body: some View {
        VStack {
            Image(systemName: systemName).font(.title2)
            Text(label).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 72)
        .background {
            RoundedRectangle(cornerRadius: 32)
                .fill(.background).opacity(0.8)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(lineWidth: 2)
        }
        .foregroundStyle(tint)
    }
}

struct ScriptButton: View {
    let systemName: String
    let label: String
    var animation: Namespace.ID? = nil
    var id: String = ""
    var tint: Color = .primary

    var body: some View {
        VStack {
            Image(systemName: systemName).font(.title2)
            Text(label).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 72)
        .background {
            RoundedRectangle(cornerRadius: 32)
                .fill(.background).opacity(0.8)
                .iflet(animation) { $0.matchedGeometryEffect(id: "\(id)bg", in: $1) }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(lineWidth: 2)
                .iflet(animation) { $0.matchedGeometryEffect(id: "\(id)br", in: $1) }
        }
        .foregroundStyle(tint)
    }
}

// Helper for conditional modifiers
extension View {
    @ViewBuilder func iflet<T, Content: View>(_ value: T?, transform: (Self, T) -> Content) -> some View {
        if let value = value { transform(self, value) } else { self }
    }
}
