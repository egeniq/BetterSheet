//
//  ContentView.swift
//  BetterSheetExample
//
//  Created by Nguyen Minh Phuc on 2019-10-08.
//  Copyright © 2019 BetterSheet. All rights reserved.
//

import SwiftUI
import BetterSheet

struct Fruit {
    let name: String
}

extension Fruit: Identifiable {
    var id: String {
        name
    }
}

struct BasicUsage: View {
    @State var showDetail = false

    var body: some View {
        VStack {
            Button(action: { self.showDetail = true }) {
                Text("Show Detail")
            }
        }
            .navigationBarTitle("Basic Usage")
            .betterSheet(isPresented: $showDetail) {
                Text("Detail!")
            }
    }
}

struct SimpleUsage: View {
    let fruits = [Fruit(name: "Apple"), Fruit(name: "Banana"), Fruit(name: "Orange")]
    @State var selectedFruit: Fruit? = nil

    var body: some View {
        List(fruits) { fruit in
            Button(action: { self.selectedFruit = fruit }) {
                Text(fruit.name)
            }
        }
            .navigationBarTitle("Simple Usage With List")
            .betterSheet(item: $selectedFruit) { fruit in
                Text("You selected \(fruit.name)")
            }
    }
}

struct EditView: View {
    @Binding var fruits: [Fruit]
    
    let fruit: Fruit?
    @State var name: String
    
    @Environment(\.betterSheetPresentationMode) var presentationMode
    
    @State var showDismissActions = false
    
    init(fruits: Binding<[Fruit]>, fruit: Fruit? = nil) {
        _fruits = fruits
        self.fruit = fruit
        _name = State(initialValue: fruit?.name ?? "")
    }
    
    var isNew: Bool {
        fruit == nil
    }
    
    var isValid: Bool {
        name.trimmingCharacters(in: .whitespaces).count > 0
    }
    
    var isModified: Bool {
        if let fruit = fruit, name != fruit.name {
            return true
        } else if fruit == nil && isValid {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name")
                    TextField("Fruit", text: $name).multilineTextAlignment(.trailing)
                }
            }
                .navigationBarTitle(fruit == nil ? "Add Fruit" : "Edit Fruit")
                .navigationBarItems(
                    leading: Button(action: save) { Text("Save").fontWeight(.bold).disabled(!isValid) },
                    trailing: Button(action: self.cancel) { Text("Cancel") }
                )
                .actionSheet(isPresented: $showDismissActions) {
                    ActionSheet(
                        title: Text("Select an option"),
                        message: nil,
                        buttons: [
                            .destructive(Text(isNew ? "Discard Fruit" : "Discard Changes"), action: self.cancel),
                            .default(Text(isNew ? "Add Fruit" : "Save Fruit"), action: self.save),
                            .cancel()
                        ]
                    )
                }
        }
            .betterSheetIsModalInPresentation(isModified)
            .onBetterSheetDidAttemptToDismiss {
                self.showDismissActions = true
            }
    }

    func save() {
        guard isValid else { return }
        
        let fruit = Fruit(name: name)
        
        if let index = fruits.firstIndex(where: { $0.id == self.fruit?.id }) {
            fruits.remove(at: index)
            fruits.insert(fruit, at: index)
        } else {
            fruits.append(fruit)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func cancel() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AdvancedUsage: View {
    @State var fruits: [Fruit] = [Fruit(name: "Apple")]

    @State var addFruit = false
    @State var editFruit: Fruit? = nil

    var body: some View {
        List(fruits) { fruit in
            Text(fruit.name)
            Spacer()
            Button(action: { self.editFruit = fruit }) {
                Image(systemName: "pencil.circle")
            }
        }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Fruits")
            .navigationBarItems(
                trailing: Button(action: { self.addFruit = true }) { Text("Add") }
            )
            .betterSheet(isPresented: $addFruit) {
                EditView(fruits: self.$fruits)
            }
            .betterSheet(item: $editFruit) { fruit in
                EditView(fruits: self.$fruits, fruit: fruit)
            }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BasicUsage()) {
                    Text("Basic Usage")
                }
                NavigationLink(destination: SimpleUsage()) {
                    Text("Simple Usage")
                }
                NavigationLink(destination: AdvancedUsage()) {
                    Text("Avanced Usage")
                }
            }
                .navigationBarTitle("BetterSheet Example")
        }
    }
}
