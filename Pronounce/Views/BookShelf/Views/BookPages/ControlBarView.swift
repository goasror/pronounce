//
//  ControlBarView.swift
//  Pronounce
//
//  Created by asror on 06/02/26.
//

import SwiftUI
import CoreData

struct ControlBarView: View {
    @ObservedObject var page: PageEntity
    @Binding var showRecords: Bool
    @Binding var showSentences: Bool
    
    @Binding var currentAction: ControlBarActionType?
    
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var recordPlayer = RecordPlayer()
    @ObservedObject var speech = SpeechManager()
    var recorder = Recorder()
    var scanner = LocalImageProcessor()
    var body: some View {
        HStack(spacing: 10) {
            if !page.viewSentences.isEmpty {
                ControlBarButton(
                    defaultSystemName: "waveform",
                    defaultLabel: "Narrate",
                    activeSystemName: "stop",
                    activeLabel: "Stop",
                    actionType: .narrate,
                    currentAction: currentAction) {
                        if currentAction == .narrate {
                            speech.stop()
                            currentAction = nil
                        } else {
                            currentAction = .narrate
                            let sentences = page.viewSentences
                            var text = ""
                            for sentence in sentences {
                                text.append(contentsOf: sentence.viewSentenceText)
                            }
                            speech.speak(text, language: page.viewLanguage)
                        }
                    }
            }
            ControlBarButton(
                defaultSystemName: "recordingtape",
                defaultLabel: "Records",
                activeSystemName: "recordingtape",
                activeLabel: "Records",
                actionType: .records,
                currentAction: currentAction) {
                    showRecords = true
                }
            ControlBarButton(
                defaultSystemName: "mic",
                defaultLabel: "Record",
                activeSystemName: "stop",
                activeLabel: "Stop",
                actionType: .record,
                currentAction: currentAction) {
                    if currentAction == .record {
                        let data = recorder.stop()
                        let recording = RecordEntity(context: moc)
                        recording.recordData = data
                        page.addToRecordEntites(recording)
                        do {
                            try? moc.save()
                        }
                        currentAction = nil
                    } else {
                        currentAction = .record
                        recorder.record()
                    }
                }
            
            if page.viewSentences.isEmpty {
                ControlBarButton(
                    defaultSystemName: "text.viewfinder",
                    defaultLabel: "Scan",
                    activeSystemName: "progress.indicator",
                    activeLabel: "Scanning",
                    actionType: .scan,
                    currentAction: currentAction) {
                        if currentAction == .scan {
                            return
                        } else {
                            currentAction = .scan
                            Task {
                                do {
                                    await scanner.processImage(for: page, moc: moc)
                                    currentAction = nil
                                }
                            }
                        }
                    }
            } else {
                NavigationLink {
                    SentencesView(page: page)
                } label: {
                    ControlBarNavButton(
                        defaultSystemName: "text.word.spacing",
                        defaultLabel: "Sentences",
                        activeSystemName: "text.word.spacing",
                        activeLabel: "Sentences",
                        actionType: .text,
                        currentAction: currentAction)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}
