import PlaygroundSupport
import SwiftUI

struct MeasureBehavior<Content: View>: View {
    @State private var width: CGFloat = 100
    @State private var height: CGFloat = 100
    var content: Content
    var body: some View {
        VStack {
            content
                .border(Color.gray)
                .frame(width: width, height: height)
                .border(Color.black)
            Slider(value: $width, in: 0...500)
            Slider(value: $height, in: 0...200)
        }
    }
}

var someV: some View {
    HStack {
        Rectangle()
            .fill(Color.red)
            .frame(minWidth: 200)
        Text("Hello, World")
    }
}

PlaygroundPage.current.setLiveView(MeasureBehavior(content: someV))
