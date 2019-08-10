# BetterSheet

Provides a powerful SwiftUI sheet replacement with the following features:
* All the features of the built-in `sheet` modifiers, but more robust (tested against Xcode 11.0 beta 5).
* Modal support (prevent the user from swiping to dismiss), similar to UIKit's [`modalInPresentation`](https://developer.apple.com/documentation/uikit/uiviewcontroller/3229894-modalinpresentation?language=objc))
* Support for invoking an action when the user tries to dismiss the sheet when it is modal.

Hopefully Apple will make the default `sheet` modifiers more robust and will add modal presentation
support as well before the final version of iOS 13.0 is released, so this library becomes obsolete. 

## Basic Usage

First make sure you import the `BetterSheet` package and  initialize `UIHostingController` with power 
sheet support in  `SceneDelegate.swift`:

```swift
window.rootViewController = UIHostingController.withBetterSheetSupport(rootView: ContentView())
```

The basic API for presenting a sheet is similar to SwiftUI's [`sheet(isPresented:onDismiss:content:)`](https://developer.apple.com/documentation/swiftui/view/3352791-sheet)
view modifier. But instead of using `sheet` you use `betterSheet`.

For example:

```swift
struct ContentView: View {
    @State var showDetail = false

    var body: some View {
        VStack {
            Button(action: { self.showDetail = true }) {
                Text("Show Detail")
            }
        }
            .betterSheet(isPresented: $showDetail) {
                Text("Detail!")
            }
    }
}
```

For more advanced use-cases there is an API similar to SwiftUI's  [`sheet(item:onDismiss:content:`](https://developer.apple.com/documentation/swiftui/view/3352792-sheet) 
view modifier available:

```swift
struct Fruit {
    let name: String
}

extension Fruit: Identifiable {
    var id: String {
        name
    }
}

struct ContentView: View {
    let fruits = [Fruit(name: "Apple"), Fruit(name: "Banana"), Fruit(name: "Orange")]
    @State var selectedFruit: Fruit? = nil

    var body: some View {
        List(fruits) { fruit in
            Button(action: { self.selectedFruit = fruit }) {
                Text(fruit.name)
            }
        }
            .betterSheet(item: $selectedFruit) { fruit in
                Text("You selected \(fruit.name)")
            }
    }
}
```

Just as with the SwiftUI `sheet` modifier there is an environment value similar to SwiftUI's  [`presentationMode`](https://developer.apple.com/documentation/swiftui/environmentvalues/3363874-presentationmode) 
available which you can use to dismiss a sheet from your own code. The BetterSheet version of this environment value is called
`betterSheetPresentationMode`. 

An example: 

```swift
struct DetailView: View {
    @Environment(\.betterSheetPresentationMode) var presentationMode
    
    var body: some View {
        Button(action: { self.presentationMode.value.dismiss() }) {
            Text("Dismiss")
        }
    }    
}

struct ContentView: View {
    @State var showDetail = false

    var body: some View {
        VStack {
            Button(action: { self.showDetail = true }) {
                Text("Show Detail")
            }
        }
            .betterSheet(isPresented: $showDetail) {
                DetailView()
            }
    }
}
```

## Advanced usage

So far we've only looked at the API that offers similar functionality to the default SwiftUI sheet functionality. BetterSheet however
offers some more advanced possibilities for if you don't want the user to simply dismiss your sheet with a swipe gesture.

For example:
```swift
struct Fruit {
    let name: String
}

extension Fruit: Identifiable {
    var id: String {
        name
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
                .betterSheetIsModalInPresentation(isModified)
                .onBetterSheetDidAttemptToDismiss {
                    self.showDismissActions = true
                }
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
        
        presentationMode.value.dismiss()
    }
    
    func cancel() {
        presentationMode.value.dismiss()
    }
}

struct ContentView: View {
    @State var fruits: [Fruit] = [Fruit(name: "Apple")]

    @State var addFruit = false
    @State var editFruit: Fruit? = nil

    var body: some View {
        NavigationView {
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
                    leading: Button(action: { self.addFruit = true }) { Text("Add") }
                )
                .betterSheet(isPresented: $addFruit) {
                    EditView(fruits: self.$fruits)
                }
                .betterSheet(item: $editFruit) { fruit in
                    EditView(fruits: self.$fruits, fruit: fruit)
                }
        }
    }
}
```

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.
