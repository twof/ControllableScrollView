import SwiftUI
import Combine

public struct ControllableScrollView<Content: View>: View {
  @Binding var scrollModel: ScrollTrackerModel
  
  var content: Content
  
  public init(
    scrollModel: Binding<ScrollTrackerModel>,
    @ViewBuilder content: () -> Content
  ) {
    self._scrollModel = scrollModel
    self.content = content()
  }
  
  public var body: some View {
    ScrollView {
      ZStack {
        content
        ScrollTracker(offset: $scrollModel.position)
      }.scrollTargetLayout()
    }
    .scrollPosition(id: $scrollModel.trackerId)
  }
}

struct ScrollTracker: View {
  static let id = "tracker"
  @Binding var offset: Double
  
  var body: some View {
    VStack {
      GeometryReader { geometry in
        Rectangle()
          .frame(height: 0)
          .foregroundStyle(Color.red)
          .onChange(of: geometry.frame(in: .scrollView(axis: .vertical))) { oldValue, newValue in
            offset = newValue.origin.y
          }
      }
      Spacer(minLength: -offset)
      Rectangle()
        .frame(height: 0)
        .foregroundStyle(Color.red)
        .id(ScrollTracker.id)
      Spacer()
        .layoutPriority(1)
    }
  }
}

@Observable
public class ScrollTrackerModel {
  public internal(set) var position: Double = 0.0
  var trackerId: String? = nil
  
  public init(position: Double = 0.0, trackerId: String? = nil) {
    self.position = position
    self.trackerId = trackerId
  }
  
  public func scroll(position: Double) {
    self.trackerId = nil
    withAnimation(nil) {
      self.position = position
      self.trackerId = ScrollTracker.id
    }
  }
}

struct DemoView: View {
  @State var foo = ScrollTrackerModel()
  
  var body: some View {
    VStack {
      Button("Down") {
        foo.scroll(position: foo.position - 20)
      }
      ControllableScrollView(scrollModel: $foo, content: {
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

#Preview {
  DemoView()
}
