//
//  PagingScrollView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import SwiftUI

struct PagingList<Data, Content>: View
where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    
    // MARK: - Inputs
    let axis: Axis
    let data: Data
    @Binding var currentIndex: Int
    var canContentScroll: Bool = true
    @ViewBuilder let content: (Data.Element) -> Content
    
    
    // MARK: - Internal State
    @GestureState private var dragOffset: CGFloat = 0
    
    private let snapAnim = Animation.spring(response: 0.3, dampingFraction: 1.0)
    private let dragAnim = Animation.interactiveSpring(response: 0.15, dampingFraction: 0.86)
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            // Determine dimension based on axis
            let scrollLength = axis == .horizontal ? size.width : size.height
            
            Group {
                if axis == .horizontal {
                    LazyHStack(spacing: 0) {
                        pageLoop(length: scrollLength, otherLength: size.height)
                    }
                } else {
                    LazyVStack(spacing: 0) {
                        pageLoop(length: size.width, otherLength: scrollLength)
                    }
                }
            }
            // Math: Apply offset to X for horizontal, Y for vertical
            .offset(
                x: axis == .horizontal ? calculateOffset(length: scrollLength) : 0,
                y: axis == .vertical ? calculateOffset(length: scrollLength) : 0
            )
            .gesture(canContentScroll ? dragGesture(length: scrollLength) : nil)
            .animation(snapAnim, value: currentIndex)
            .animation(dragAnim, value: dragOffset)
        }
        .clipped()
        .onChange(of: data.count) { newCount in
            if currentIndex >= newCount {
                currentIndex = max(0, newCount - 1)
            }
        }
    }
    
    // Helper to build the pages
    
    private func dragGesture(length: CGFloat) -> some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = axis == .horizontal ? value.translation.width : value.translation.height
            }
            .onEnded { value in
                let translation = axis == .horizontal ? value.translation.width : value.translation.height
                let velocity = axis == .horizontal ? value.predictedEndTranslation.width : value.predictedEndTranslation.height
                handleDragEnd(translation: translation, velocity: velocity, length: length)
            }
    }
    
    @ViewBuilder
    private func pageLoop(length: CGFloat, otherLength: CGFloat) -> some View {
        ForEach(data) { item in
            content(item)
                .frame(width: axis == .horizontal ? length : otherLength,
                       height: axis == .vertical ? length : otherLength)
//                .drawingGroup()
        }
    }
    
    // MARK: - Generic Math
    
    private func calculateOffset(length: CGFloat) -> CGFloat {
        let baseOffset = -CGFloat(currentIndex) * length
        let isFirst = currentIndex == 0
        let isLast = currentIndex == data.count - 1
        
        // Rubber banding
        if (isFirst && dragOffset > 0) || (isLast && dragOffset < 0) {
            return baseOffset + (dragOffset * 0.3)
        }
        return baseOffset + dragOffset
    }
    
    private func handleDragEnd(translation: CGFloat, velocity: CGFloat, length: CGFloat) {
        let totalMove = translation + velocity
        let threshold = length / 2
        
        if totalMove < -threshold && currentIndex < data.count - 1 {
            currentIndex += 1
        } else if totalMove > threshold && currentIndex > 0 {
            currentIndex -= 1
        }
    }
}
