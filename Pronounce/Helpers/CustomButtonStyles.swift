//
//  CustomButtonStyles.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI

struct OutlinedButtonRoundedRectangle: ButtonStyle {
    var cornerRadius: CGFloat
    var height: CGFloat
    var withSpacer: Bool = true
    var lineWidth: CGFloat = 1
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if withSpacer {
                Spacer()
            }
            configuration.label
                .padding(.horizontal)
            if withSpacer {
                Spacer()
            }
        }
        .frame(height: height)
        .containerShape(.rect)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.background)
                .opacity(0.8)
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
        }
            
    }
}

struct OutlinedButtonCircle: ButtonStyle {
    var width: CGFloat
    var height: CGFloat
    var lineWidth: CGFloat = 2
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .frame(width: width, height: height)
        .background {
            Circle()
                .fill(.background)
                .opacity(0.8)
        }
        .overlay {
            Circle()
                .stroke(lineWidth: lineWidth)
        }
            
    }
}
