//
//  ControlBarButton.swift
//  Pronounce
//
//  Created by asror on 06/02/26.
//

import SwiftUI

enum ControlBarActionType {
    case narrate, records, record, text, scan
}

struct ControlBarButton: View {
    var defaultSystemName: String
    var defaultLabel: String
    var activeSystemName: String
    var activeLabel: String
    var actionType: ControlBarActionType
    var currentAction: ControlBarActionType?
    var action: () -> Void
    
    var isTappable: Bool {
        if let currentAction {
            return currentAction == actionType
        }
        return true
    }
    var isActive: Bool {
        if let currentAction {
            return currentAction == actionType
        }
        return false
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                //                Spacer()
                Image(systemName: isActive ? activeSystemName : defaultSystemName)
                    .font(.title2)
                //                Spacer()
                //                Text(isActive ? activeLabel : defaultLabel)
                //                    .font(.system(size: 8))
                //                    .foregroundStyle(.secondary)
                //                    .padding(.bottom, 2)
            }
        }
        .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 72))
        .foregroundStyle(isTappable ? .primary : .secondary)
        .disabled(!isTappable || (isActive && currentAction == .scan))
    }
}

struct ControlBarNavButton: View {
    var defaultSystemName: String
    var defaultLabel: String
    var activeSystemName: String
    var activeLabel: String
    var actionType: ControlBarActionType
    var currentAction: ControlBarActionType?
    
    var isTappable: Bool {
        if let currentAction {
            return currentAction == actionType
        }
        return true
    }
    var isActive: Bool {
        if let currentAction {
            return currentAction == actionType
        }
        return false
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: isActive ? activeSystemName : defaultSystemName)
                    .font(.title2)
                Spacer()
            }
            //                Text(isActive ? activeLabel : defaultLabel)
            //                    .font(.system(size: 8))
            //                    .foregroundStyle(.secondary)
            //                    .padding(.bottom, 2)
        }
        .frame(height: 72)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .opacity(0.8)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 1)
        }
//        .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 20, height: 72))
        .foregroundStyle(isTappable ? .primary : .secondary)
        .disabled(!isTappable || (isActive && currentAction == .scan))
    }
}
