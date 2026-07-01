//
//  ScriptArea.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import PencilKit

struct ScriptAreaView: UIViewRepresentable {
    @Binding var canUndo: Bool
    @Binding var canRedo: Bool
    @Binding var isEmpty: Bool
    @Binding var drawingArea: PKCanvasView
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = drawingArea
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: UIColor(.primary), width: 8)
        canvas.isOpaque = false
        canvas.backgroundColor = .systemBackground
        canvas.delegate = context.coordinator
        
        DispatchQueue.main.async {
            self.drawingArea = canvas
            context.coordinator.updateUndoRedoStates(canvas: canvas)
        }
        
        return canvas
    }
    
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: ScriptAreaView
        init(_ parent: ScriptAreaView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            updateUndoRedoStates(canvas: canvasView)
            if canvasView.drawing.bounds.isEmpty {
                parent.isEmpty = true
            } else {
                parent.isEmpty = false
            }
        }
        
        func updateUndoRedoStates(canvas: PKCanvasView) {
            parent.canUndo = canvas.undoManager?.canUndo ?? false
            parent.canRedo = canvas.undoManager?.canRedo ?? false
        }
//        func exportDrawing(canvasView: PKCanvasView) -> UIImage? {
//            let drawing = canvasView.drawing
//            let imageRect = drawing.bounds
//            if imageRect.isEmpty { return nil }
//            return drawing.image(from: imageRect, scale: 1.0)
//        }
//        func exportDrawing(canvasView: PKCanvasView) -> UIImage? {
//            let drawing = canvasView.drawing
//            let fullCanvasRect = canvasView.bounds
//            if fullCanvasRect.isEmpty { return nil }
//            let renderer = UIGraphicsImageRenderer(size: fullCanvasRect.size)
//            
//            return renderer.image { context in
//                UIColor.systemBackground.setFill()
//                context.fill(fullCanvasRect)
//                drawing.image(from: fullCanvasRect, scale: 1.0).draw(in: fullCanvasRect)
//            }
//        }
    }
}

