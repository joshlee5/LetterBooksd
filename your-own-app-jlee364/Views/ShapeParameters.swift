import CoreGraphics

struct ShapeParameters {
    struct Segment {
        let line: CGPoint
        let curve: CGPoint
        let control: CGPoint
    }


    static let adjustment: CGFloat = 0.085


    static let segments = [
        Segment(
            line:    CGPoint(x: 0.50, y: 0.20),
            curve:   CGPoint(x: 0.50, y: 0.20),
            control: CGPoint(x: 0.50, y: 0.00)
        ),
        Segment(
            line:    CGPoint(x: 0.00, y: 0.80 - adjustment),
            curve:   CGPoint(x: 0.10, y: 0.60 - adjustment),
            control: CGPoint(x: 0.00, y: 0.75 - adjustment)
        ),

        Segment(
            line:    CGPoint(x: 0.90, y: 0.75 - adjustment),
            curve:   CGPoint(x: 1.00, y: 0.65 - adjustment),
            control: CGPoint(x: 1.00, y: 0.80 - adjustment)
        )
    ]
}
