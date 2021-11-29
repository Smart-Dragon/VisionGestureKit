import UIKit

protocol VGKHandGestureDetectorDelegate: AnyObject {
    func drawDetectedHand(layer: CAShapeLayer)
    func gestureDetectingFail()
    func gestureDetected(gesture: VGKHandGuesture?)
    func gestureActionDetected(gesture: VGKHandGuesture)
}

extension VGKHandGestureDetectorDelegate {
    func gestureDetected(gesture: VGKHandGuesture?) {
    }
}
