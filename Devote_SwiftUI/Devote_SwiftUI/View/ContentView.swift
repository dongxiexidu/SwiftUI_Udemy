//
//  ContentView.swift
//  Devote_SwiftUI
//
//  Created by Junyeong Park on 2022/05/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State var task: String = ""
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
      NavigationView {
        ZStack {
          // MARK: - MAIN VIEW
          VStack {
            // MARK: - HEADER
              VStack(spacing: 16) {
                  TextField("New Task", text: $task)
                      .padding()
                      .background(
                        Color(UIColor.systemGray6)
                      )
                      .cornerRadius(10)
                  Button(action: {
                      addItem()
                  }, label: {
                      Spacer()
                      Text("SAVE")
                      Spacer()
                  })
                  .disabled(isButtonDisabled)
                  .padding()
                  .font(.headline)
                  .foregroundColor(.white)
                  .background(isButtonDisabled ? .gray : .pink)
                  .cornerRadius(10)
              } //: VSTACK
              .padding()
            // MARK: - NEW TASK BUTTON
            
            // MARK: - TASKS
            
              List {
                  ForEach(items) { item in
                      VStack(alignment: .leading) {
                          Text(item.task ?? "")
                              .font(.headline)
                              .fontWeight(.bold)
                          Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                              .font(.footnote)
                              .foregroundColor(.gray)
                      } //: LIST ITEM
                  }
                  .onDelete(perform: deleteItems)
              } //: LIST
              .listStyle(InsetGroupedListStyle())
              .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
              .padding(.vertical, 0)
              .frame(maxWidth: 640)
          
          // MARK: - NEW TASK ITEM
        } //: ZSTACK
        .onAppear() {
          UITableView.appearance().backgroundColor = UIColor.clear
        }
        .navigationBarTitle("Daily Tasks", displayMode: .large)
        .background(
          BackgroundImageView()
        )
        .background(
          backgroundGradient.ignoresSafeArea(.all)
        )
      } //: NAVIGATION
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
