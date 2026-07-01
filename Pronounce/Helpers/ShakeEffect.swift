//
//  ShakeEffect.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI

struct ShakeEffect: ViewModifier {
    @Binding var trigger: Bool // Binding lets the modifier "reset" the value
    
    @State private var offset: CGFloat = 0
    @State private var isRed: Bool = false
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .foregroundColor(isRed ? .red : nil)
            .onChange(of: trigger) { newValue in
                // Only run when the value becomes true
                if newValue {
                    runShake()
                }
            }
    }
    
    private func runShake() {
        // iOS 16 Haptics
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        Task {
            let duration = 0.08
            
            // Phase 1: Right + Red
            await withAnimation(.easeInOut(duration: duration)) {
                offset = 10
                isRed = true
            }
            
            // Phase 2: Left
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await withAnimation(.easeInOut(duration: duration)) {
                offset = -10
            }
            
            // Phase 3: Center + Reset
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await withAnimation(.easeInOut(duration: duration)) {
                offset = 0
                isRed = false
                trigger = false // Reset the toggle so it can be clicked again
            }
        }
    }
}

extension View {
    func shake(trigger: Binding<Bool>) -> some View {
        self.modifier(ShakeEffect(trigger: trigger))
    }
}
