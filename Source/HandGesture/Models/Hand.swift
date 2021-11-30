import CoreGraphics

public enum VGKHandGuesture: String {
    case rock
    case victory
    case fist
}

struct VGKHand {
    var thumb: VGKFinger
    var index: VGKFinger
    var middle: VGKFinger
    var ring: VGKFinger
    var little: VGKFinger
    var wrist: CGPoint
    
    var isThumbClosed: Bool {
        distance(from: thumb.one, to: wrist) < distance(from: thumb.four, to: wrist)
    }
    var isIndexClosed: Bool {
        distance(from: index.one, to: wrist) < distance(from: index.four, to: wrist)
    }
    var isMiddleClosed: Bool {
        distance(from: middle.one, to: wrist) < distance(from: middle.four, to: wrist)
    }
    var isRingClosed: Bool {
        distance(from: ring.one, to: wrist) < distance(from: ring.four, to: wrist)
    }
    var isLittleClosed: Bool {
        distance(from: little.one, to: wrist) < distance(from: little.four, to: wrist)
    }
    
    var fingers: [VGKFinger] {
        [thumb, index, middle, ring, little]
    }
    
    var gesture: VGKHandGuesture? {
        if !isIndexClosed && isMiddleClosed && isRingClosed && !isLittleClosed {
            return .rock
        }
        if !isIndexClosed && !isMiddleClosed && isRingClosed && isLittleClosed {
            return .victory
        }
        if isIndexClosed && isMiddleClosed && isRingClosed && isLittleClosed {
            return .fist
        }
        return nil
    }
    
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y))
    }
}
