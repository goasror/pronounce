//
//  CustomTextFieldView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI

struct CustomTextField: View {
    let prompt: String
    @Binding var text: String
    let font: Font
    let field: AddABookView.Field
    var foregroundColor: Color = .primary
    @FocusState.Binding var focusedField: AddABookView.Field?
    @Binding var animationTrigger: Bool

    var body: some View {
        VStack {
            Divider()
            TextField(prompt, text: $text)
                .font(font)
                .focused($focusedField, equals: field)
                .padding(.vertical)
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
                .foregroundStyle(foregroundColor)
                .shake(trigger: $animationTrigger)
                .onTapGesture {
                    focusedField = (focusedField == field) ? nil : field
                }
        }
    }
}
