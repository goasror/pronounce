//
//  AddABookView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import CoreData

struct AddABookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    // State
    @State private var bookCover: UIImage?
    @State private var bookTitle = ""
    @State private var bookAuthor = ""
    @State private var language: Languages = .none
    
    @State private var isSaving = false
    @State private var showScanner = false
    
    // Animations
    @State private var microAnimationCover = false
    @State private var microAnimationTitle = false
    @State private var microAnimationAuthor = false
    @FocusState private var isFocused: Field?

    enum Field: Hashable { case none, title, author }

    var disableSave: Bool {
        bookCover == nil || bookTitle.isEmpty || bookAuthor.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                // Book Card Container
                bookCard
                // Save Button
                bottomBar
            }
            .navigationTitle("Add a Book")
            .sheet(isPresented: $showScanner) {
                DocumentScanner { images in
                    showScanner = false
                    if let image = images.first { self.bookCover = image }
                } onCancel: { showScanner = false }
            }
        }
    }
    
    var bottomBar: some View {
        HStack (spacing: 20){
            Menu {
                Picker("Book Language", selection: $language){
                    ForEach(Languages.allCases, id: \.self) { language in
                        Text(language.displayName)
                    }
                }
            } label: {
                Button {} label: {
                    if language == .none {
                        Text("Select book language")
                            .multilineTextAlignment(.center)
                    } else {
                        Text(language.displayName)
                            .multilineTextAlignment(.center)
                    }
                }
                .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 32, height: 72, lineWidth: 2))
            }
            .foregroundStyle(.primary)

            Button {
                if disableSave {
                    if bookCover == nil { microAnimationCover = true }
                    if bookTitle.isEmpty { microAnimationTitle = true }
                    if bookAuthor.isEmpty { microAnimationAuthor = true }
                } else {
                    saveBook()
                }
            } label: {
                Text(isSaving ? "Saving..." : "Save")
                    .font(.title)
            }
            .disabled(isSaving)
            .foregroundStyle(disableSave ? .secondary : .primary)
            .buttonStyle(OutlinedButtonRoundedRectangle(cornerRadius: 32, height: 72, lineWidth: 2))
        }
        
        .padding()
    }
    
    var bookCard: some View {
        VStack {
            if isFocused == nil {
                BookCoverPicker(
                    bookCover: $bookCover,
                    microAnimationCover: $microAnimationCover,
                    onTap: { showScanner = true }
                )
            }
            
            CustomTextField(
                prompt: "Book Title",
                text: $bookTitle,
                font: .title2,
                field: .title,
                focusedField: $isFocused,
                animationTrigger: $microAnimationTitle
            )
            
            CustomTextField(
                prompt: "Author Name",
                text: $bookAuthor,
                font: .title3,
                field: .author,
                foregroundColor: .secondary,
                focusedField: $isFocused,
                animationTrigger: $microAnimationAuthor
            )
        }
        .animation(.easeInOut(duration: 0.1), value: isFocused)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 30).stroke(lineWidth: 2)
        }
        .padding(.horizontal, 40)
    }

    func saveBook() {
        
        guard let cover = bookCover, !bookTitle.isEmpty, !bookAuthor.isEmpty else { return }
        
        isSaving = true
        let book = BookEntity(context: moc)
        book.bookName = bookTitle
        book.bookAuthor = bookAuthor
        book.newPageIndex = 0
        book.bookCover = cover.jpegData(compressionQuality: 0.7)
        if language != .none {
            book.bookLanguage = language.rawValue
        }
        
        do {
            try moc.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { dismiss() }
        } catch {
            isSaving = false
            print("Error saving: \(error.localizedDescription)")
        }
    }
}
