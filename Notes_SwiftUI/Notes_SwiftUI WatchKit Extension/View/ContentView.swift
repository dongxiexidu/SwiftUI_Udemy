//
//  ContentView.swift
//  Notes_SwiftUI WatchKit Extension
//
//  Created by Junyeong Park on 2022/06/03.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    @State private var notes: [Note] = [Note]()
    @State private var text: String = ""
    
    // MARK: - FUNCTON
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func save() {
        do {
            // 1. Convert the notes array to data using JSONDecoder
            let data = try JSONEncoder().encode(notes)
            // 2. Create a new URL to save the file using the getDocumentDirectory func
            let url = getDocumentDirectory().appendingPathComponent("notes")
            // 3. Write the data to the given URL
            try data.write(to: url)
        } catch {
            print("Saving data has failed.")
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            do {
                // 1. Get the notes URL file
                let url = getDocumentDirectory().appendingPathComponent("notes")
                // 2. Create a new property for the data
                let data = try Data(contentsOf: url)
                // 3. Decode the data
                notes = try JSONDecoder().decode([Note].self, from: data)
            } catch {
                // Do nothing
            }
        }
    }
    
    func delete(offsets: IndexSet) {
        withAnimation {
            notes.remove(atOffsets: offsets)
            save()
        }
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 6) {
                TextField("Add New Note", text: $text)
                
                Button(action: {
                    // 1. Only run the button's action when the text field is not empty
                    guard text.isEmpty == false else {
                        return
                    } // guard is very effective!
                                        
                    // 2. Create a new note item and initialzie it with the text values
                    let note = Note(id: UUID(), text: text)

                    // 3. Add the new note item to the notes array (append)
                    notes.append(note)
                    
                    // 4. Make the text field empty
                    text = ""
                    
                    // 5. Save the notes (function)
                    save()
                    
                }, label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 42, weight: .semibold))
                })
                .fixedSize()
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.accentColor)
            } //: HSTACK
            Spacer()
            if notes.count >= 1 {
                List {
                  ForEach(0..<notes.count, id: \.self) { i in
                    NavigationLink(destination: DetailView(note: notes[i], count: notes.count, index: i)) {
                      HStack {
                        Capsule()
                          .frame(width: 4)
                          .foregroundColor(.accentColor)
                        Text(notes[i].text)
                          .lineLimit(1)
                          .padding(.leading, 5)
                      }
                    } //: HSTACK
                  } //: LOOP
                  .onDelete(perform: delete)
                }
            } else {
                Spacer()
                Image(systemName: "note.text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .opacity(0.25)
                    .padding(25)
                Spacer()
            } //: LIST
            Text("\(notes.count)")
        } //: VSTACK
        .navigationTitle("Notes")
        .onAppear(perform: {
            load()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
