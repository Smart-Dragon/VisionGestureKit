import UIKit
import Vision

public final class VGKHandGestureDetector: NSObject {
    
    // MARK: - Public properties
    
    public weak var delegate: VGKHandGestureDetectorDelegate?
    public var frameLayer: CGRect?
    
    
    // MARK: - Private properties
    
    private var lastDetectedGesture: VGKHandGuesture?
    private let actionQueue = DispatchQueue(label: "VGKHand.gesture.action", qos: .userInteractive)
    
    private var fingerLayer = CAShapeLayer()
    private let handRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    
    // MARK: - Internal methods
    
    public func update(sampleBuffer: CMSampleBuffer) {
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: .init())
        
        do {
            try handler.perform([handRequest])
            if let result = handRequest.results?.first {
                let handVision = try! result.recognizedPoints(.all)
                let hand = createHand(handVision)
                
                if let hand = hand {
                    if hand.gesture != nil && lastDetectedGesture != hand.gesture {
                        trySendHandAction()
                    }
                    if hand.gesture == nil && lastDetectedGesture != hand.gesture {
                        cancelHandAction()
                    }
                    lastDetectedGesture = hand.gesture
                    
                    delegate?.gestureDetected(gesture: lastDetectedGesture)
                    if let layer = drawLines(hand) {
                        delegate?.drawDetectedHand(layer: layer)
                    }
                } else {
                    cancelHandAction()
                }
            } else {
                cancelHandAction()
                delegate?.gestureDetectingFail()
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Private methods
    
    private func trySendHandAction() {
        cancelHandAction()
        DispatchQueue.main.async {
            self.perform(#selector(self.sendHandAction), with: nil, afterDelay: 1.0)
        }
    }
    
    private func cancelHandAction() {
        DispatchQueue.main.async {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.sendHandAction), object: nil)
        }
    }
    
    @objc private func sendHandAction() {
        if let gesture = lastDetectedGesture {
            delegate?.gestureActionDetected(gesture: gesture)
        }
    }
    
    private func drawLines(_ hand: VGKHand) -> CAShapeLayer? {
        guard let frameLayer = frameLayer else { return nil }
        
        let fingerLayer = CAShapeLayer()
        
        let path = UIBezierPath()
        for finger in hand.fingers {
            for (index, point) in finger.points.enumerated() {
                if index == 0 {
                    path.move(to: CGPoint(x: frameLayer.width * point.x, y: frameLayer.height * point.y))
                } else {
                    path.addLine(to: CGPoint(x: frameLayer.width * point.x, y: frameLayer.height * point.y))
                }
            }
            path.addLine(to: CGPoint(x: frameLayer.width * hand.wrist.x, y: frameLayer.height * hand.wrist.y))
        }
        
        fingerLayer.path = path.cgPath
        fingerLayer.lineJoin = .round
        fingerLayer.fillColor = UIColor.clear.cgColor
        fingerLayer.strokeColor = UIColor.yellow.cgColor
        fingerLayer.lineWidth = 3
        fingerLayer.zPosition = 100
        
        return fingerLayer
    }
    
    private func createHand(_ handVision: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]) -> VGKHand? {
        guard let thumb = createFinger(name: .thumb, hand: handVision),
              let index = createFinger(name: .index, hand: handVision),
              let middle = createFinger(name: .middle, hand: handVision),
              let ring = createFinger(name: .ring, hand: handVision),
              let little = createFinger(name: .little, hand: handVision),
              let wrist = handVision[.wrist]
        else { return nil }
        
        return VGKHand(thumb: thumb,
                    index: index,
                    middle: middle,
                    ring: ring,
                    little: little,
                    wrist: createPoint(wrist))
    }
    
    private func createFinger(name: VGKFingerName, hand: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]) -> VGKFinger? {
        switch name {
        case .thumb:
            guard let one = hand[.thumbTip],
                  let two = hand[.thumbIP],
                  let three = hand[.thumbMP],
                  let four = hand[.thumbCMC]
            else { return nil }
            return VGKFinger(one: createPoint(one),
                          two: createPoint(two),
                          three: createPoint(three),
                          four: createPoint(four))
        case .index:
            guard let one = hand[.indexTip],
                  let two = hand[.indexDIP],
                  let three = hand[.indexPIP],
                  let four = hand[.indexMCP]
            else { return nil }
            return VGKFinger(one: createPoint(one),
                          two: createPoint(two),
                          three: createPoint(three),
                          four: createPoint(four))
        case .middle:
            guard let one = hand[.middleTip],
                  let two = hand[.middleDIP],
                  let three = hand[.middlePIP],
                  let four = hand[.middleMCP]
            else { return nil }
            return VGKFinger(one: createPoint(one),
                          two: createPoint(two),
                          three: createPoint(three),
                          four: createPoint(four))
        case .ring:
            guard let one = hand[.ringTip],
                  let two = hand[.ringDIP],
                  let three = hand[.ringPIP],
                  let four = hand[.ringMCP]
            else { return nil }
            return VGKFinger(one: createPoint(one),
                          two: createPoint(two),
                          three: createPoint(three),
                          four: createPoint(four))
        case .little:
            guard let one = hand[.littleTip],
                  let two = hand[.littleDIP],
                  let three = hand[.littlePIP],
                  let four = hand[.littleMCP]
            else { return nil }
            return VGKFinger(one: createPoint(one),
                          two: createPoint(two),
                          three: createPoint(three),
                          four: createPoint(four))
        }
    }
        
    private func createPoint(_ pointVision: VNRecognizedPoint) -> CGPoint {
        CGPoint(x: 1 - pointVision.location.y, y: pointVision.location.x)
    }
}
