//
//  ItemDetailView.swift
//  Timestamper
//
//  Created by Stu Greenham on 29/01/2022.
//

import SwiftUI

struct ItemDetailView: View {
    
    //: MARK: - PROPERTIES
    
    // CoreData specific
    @Environment(\.managedObjectContext) private var viewContext
    // Var to hold the project information data
    @State var item: Item?
    // Toggle for if delete alert should appear
    @State private var showingDeleteAlert = false
    // Toggle for if empty state should appear
    @State private var showingEmptyState = false
    // Stopwatch object
    @ObservedObject var stopWatchManager = StopWatchManager()
    
    
    //: MARK: - FUNCTIONS
    
    // Delete a project from CoreData
    // From https://www.youtube.com/watch?v=zx3qWNU2NnY&t=1s
    func deleteItem() {
        viewContext.delete(item!)
        do {
            try self.viewContext.save()
        } catch {
            let error = error as NSError
            print(error.debugDescription)
        }
        
        item = nil
        showingEmptyState = true
    }
    
    
    //: MARK: - BODY
    
    var body: some View {
        
        if item != nil {
            
            VStack(alignment: .leading) {
                
                // Title
                Text(item?.title ?? "Unknown Title")
                
                Divider()
                
                // Stopwatch
                HStack {
                    
                    // Counter
                    Text(String(format: "%.1f", stopWatchManager.secondsElapsed))
                    
                    Spacer()
                    
                    // Buttons
                    if stopWatchManager.mode == .stopped {
                        Button(action: {self.stopWatchManager.start()}) {
                            Text("Start")
                        }
                    }
                    if stopWatchManager.mode == .running {
                        Button(action: {self.stopWatchManager.pause()}) {
                            Text("Pause")
                        }
                    }
                    if stopWatchManager.mode == .paused {
                        Button(action: {self.stopWatchManager.start()}) {
                            Text("Resume")
                        }
                        Button(action: {self.stopWatchManager.stop()}) {
                            Text("Reset")
                        }
                    }
                    
                }
                .padding(12)
                .background(Color("timerCellBg").cornerRadius(8))
                
                
                Spacer()
                
                
                // Add timestamp button
                Button(action: {
                    // Do something
                }, label: {
                    Text("Add Timestamp")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                })
                    //.buttonStyle(BlueButtonStyle())
                    
                
                
            }
                .padding()
                .toolbar {
                    
                    // DELETE
                    ToolbarItem(placement: .destructiveAction) {
                        Button(
                            action: { self.showingDeleteAlert = true },
                            label: { Image(systemName: "trash") }
                        )
                    }
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(title: Text("Delete Item"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                            self.deleteItem()
                        }, secondaryButton: .cancel()
                    )
                }
        } else {
            EmptyView()
        }
        
    }
    
}


struct TimerButton: View {
    
    let label: String
    let buttonColor: Color
    
    var body: some View {
        Text(label)
            .foregroundColor(.white)
            .padding(.vertical, 20)
            .padding(.horizontal, 90)
            .background(buttonColor)
            .cornerRadius(10)
    }
}




//: MARK: - PREVIEW

struct ItemDetailView_Previews: PreviewProvider {
    
    static var viewContext = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        let sampleItem = Item(context: viewContext)
        sampleItem.title = "Sample Item"
        sampleItem.timestamp = Date()
        sampleItem.data = ["Test 1", "Test 2"]

        return ItemDetailView(item: sampleItem).environment(\.managedObjectContext, viewContext)
    }
}
