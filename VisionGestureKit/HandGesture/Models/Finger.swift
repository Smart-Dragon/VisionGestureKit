import CoreGraphics

enum VGKFingerName {
    case thumb
    case index
    case middle
    case ring
    case little
}

enum VGKPhalanx {
    case one
    case two
    case three
    case four
}

struct VGKFinger {
    var one: CGPoint
    var two: CGPoint
    var three: CGPoint
    var four: CGPoint
    
    var points: [CGPoint] {
        [one, two, three, four]
    }
}
