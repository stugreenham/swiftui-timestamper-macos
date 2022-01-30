//
//  AppView.swift
//  Timestamper
//
//  Created by Stu Greenham on 29/01/2022.
//

import SwiftUI

struct AppView: View {
    
    //: MARK: - PROPERTIES
    
    // Core data related
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    
    //: MARK: - FUNCTIONS
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.title = "No Title"
            // newItem.data = ["Test"]

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Delete Item
    private func deleteItem(item: Item) {
        withAnimation {
            viewContext.delete(item)
            saveItem()
        }
    }
    
    // Save Item
    private func saveItem() {
        do {
            try self.viewContext.save()
            //feedback.notificationOccurred(.success)
        } catch {
            let error = error as NSError
            print(error.debugDescription)
        }
    }
    
    // Format date
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    // Function to allow a user to toggle the sidebar back into view on Mac. Without this, the sidebar can be collapsed and not be reopened.
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }

    
    //: MARK: - BODY
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(items) { item in
                    ItemSidebarCell(item: item)
                }
                //.onDelete(perform: deleteItems)
            }
            .listStyle(SidebarListStyle())
            .toolbar {
                
                // Toggle the sidebar icon
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
                
                // Add new item
                ToolbarItem(placement: .navigation) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "square.and.pencil")
                    }
                }
                
            }
            
            EmptyView()
        }
        .navigationTitle("Timestamper")
        // define min widths for the main window
        .frame(minWidth: 600, idealWidth: 600, maxWidth: .infinity, minHeight: 600, idealHeight: 800, maxHeight: .infinity)
    }
    
}


// Sidebar list cell
struct ItemSidebarCell: View {
    @State var item: Item
    
    var body: some View {
        NavigationLink(destination: ItemDetailView(item: item)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title ?? "Unknown")
                    .font(.headline)

                Text("Item at: \(item.timestamp!)")
                    .font(.callout)
                    .lineLimit(1)
//                    .foregroundColor(Color(.gray))
            }
            .padding(8)
        }
    }
}



struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
