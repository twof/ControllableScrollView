# WHOAMI?
`ControllableScrollView` is a pure SwiftUI view that allows tracking absolute scroll offset and programatically scrolling to an arbitrary offset.

## Usage
```swift
import SwiftUI
import ControllableScrollView

struct ContentView: View {
  @State var vm = ScrollTrackerModel()
  
  var body: some View {
    VStack {
      Button("Down") {
        vm.scroll(position: vm.position - 20)
      }
      ControllableScrollView(scrollModel: $vm, content: {
        LazyVStack {
          ForEach(0..<100) { index in
            Rectangle()
              .fill(Color.green.gradient)
              .frame(height: 30)
              .id(index)
          }
        }
      })
    }
  }
}
```

Scroll offset can be read from `ScrollTrackerModel.position` and you can scroll to an arbitrary offset using `ScrollTrackerModel.scroll(position:)`. 
If a vertical `ScrollView` is scrolled all the way to the top, the offset will be 0 and if it's scrolled down, the offset will be negative.

## Constraints
- Only vertical scroll views are supported
- The allowed platforms are iOS 17 and macOS 14, but I think this should work a few versions back as well. 

PRs are welcome!

### How does this work?
Out of the box, SwiftUI allows developers to scroll until an element with a given ID is on screen, but doesn't provide support for arbitrary programatic 
scrolling. This library works by creating two invisible views in the view hierarchy. One is placed at the top of the `ScrollView` with a `GeometryReader` and
reports its own offset within the `ScrollView`. Another view is given an ID, and when `ScrollTrackerModel.scroll(position:)` is called, it's moved to the
given offset within the `ScrollView`, and the `ScrollView` is told to scroll to it by ID.
