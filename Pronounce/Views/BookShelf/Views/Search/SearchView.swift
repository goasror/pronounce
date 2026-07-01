//
//  SearchView.swift
//  Pronounce
//
//  Created by asror on 09/02/26.
//

import SwiftUI
import CoreData

struct SearchView: View {
    @State private var searchTerm: String = ""
    @FocusState private var focusState: Bool
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @State var words: [WordEntity] = []
    
    var animation: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(words) { word in
                        Text(word.viewWordText)
                    }
                }
            }
            
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading)
                        .matchedGeometryEffect(id: "symbol", in: animation)
                    
                    TextField("Search words", text: $searchTerm)
                        .focused($focusState)
                }
                .font(.title2)
                .frame(height: 72)
                .background {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(.background)
                        .opacity(0.8)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 2)
                        .matchedGeometryEffect(id: "searchBorder", in: animation)
                }
                .onTapGesture {
                    focusState.toggle()
                }
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                }
                .buttonStyle(OutlinedButtonCircle(width: 72, height: 72, lineWidth: 2))
                .foregroundStyle(.red)
            }
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusState = true
            }
        }
        .navigationTitle("Search Words")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: searchTerm) {
            if searchTerm.isEmpty {
                words = []
            } else {
                // Use [cd] for case-insensitive partial matching
                // Use %@ to safely pass the variable
                let request = WordEntity.fetchRequest()
                request.predicate = NSPredicate(format: "wordText CONTAINS[cd] %@", searchTerm)
                request.sortDescriptors = [NSSortDescriptor(keyPath: \WordEntity.wordText, ascending: true)]
                do {
                    words = try moc.fetch(request)
                } catch {
                    print("Couldn't fetch words.")
                }
            }
        }
    }
}
