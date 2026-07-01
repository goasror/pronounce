//
//  WordScriptingView.swift
//  Pronounce
//
//  Created by asror on 08/02/26.
//

import SwiftUI
import UIKit
import Combine
import PencilKit
import CoreData

struct WordScriptingView: View {
    @ObservedObject var word: WordEntity
    @Binding var isScripting: Bool
    var animation: Namespace.ID
    
    @Environment(\.managedObjectContext) var moc
    @State private var canvas = PKCanvasView()
    @State private var canUndo = false
    @State private var canRedo = false
    @State private var isEmpty = true

    var body: some View {
        VStack {
            HStack {
                Button(role: .destructive) { canvas.drawing = PKDrawing() } label: {
                    Label("Erase", systemImage: "eraser")
                }
                Spacer()
                Button { withAnimation { isScripting = false } } label: {
                    Label("Close", systemImage: "xmark")
                }
            }
            .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 12, height: 32, withSpacer: false))
            .foregroundStyle(.red)

            ScriptAreaView(canUndo: $canUndo, canRedo: $canRedo, isEmpty: $isEmpty, drawingArea: $canvas)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .background {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(.background).opacity(0.8)
                        .matchedGeometryEffect(id: "scriptbg", in: animation)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 2)
                        .matchedGeometryEffect(id: "scriptbr", in: animation)
                }

            scriptControls
        }
        .padding()
    }

    private var scriptControls: some View {
        HStack {
            Button("Save") { saveDrawing() }
                .disabled(isEmpty)
                .foregroundStyle(isEmpty ? .secondary : .primary)
            
            Spacer()
            
            Button { canvas.undoManager?.undo() } label: { Image(systemName: "arrow.uturn.backward") }
                .disabled(!canUndo)
                .foregroundStyle(canUndo ? .primary : .secondary)
            
            Button { canvas.undoManager?.redo() } label: { Image(systemName: "arrow.uturn.forward") }
                .disabled(!canRedo)
                .foregroundStyle(canRedo ? .primary : .secondary)
        }
        .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 12, height: 32, withSpacer: false, lineWidth: 1))
    }

    private func saveDrawing() {
        let drawingBounds = canvas.drawing.bounds
        guard !drawingBounds.isEmpty, let image = exportDrawing(canvasView: canvas) else { return }
        

        let script = ScriptEntity(context: moc)
        script.scriptData = image.pngData()
        script.createdDate = .now
        word.addToScriptEntities(script)
        try? moc.save()
        canvas.drawing = PKDrawing()
    }
    
    private func exportDrawing(canvasView: PKCanvasView) -> UIImage? {
        let drawing = canvasView.drawing
        let fullCanvasRect = canvasView.bounds
        if fullCanvasRect.isEmpty { return nil }
        let renderer = UIGraphicsImageRenderer(size: fullCanvasRect.size)
        
        return renderer.image { context in
            UIColor.systemBackground.setFill()
            context.fill(fullCanvasRect)
            drawing.image(from: fullCanvasRect, scale: 2.0).draw(in: fullCanvasRect)
        }
    }
}
