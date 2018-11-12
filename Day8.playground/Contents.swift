//importing libraries
import UIKit
import PlaygroundSupport
/*
 Today we are going to learn about CAShape Layer
*/


//Source: https://collectiveidea.com/blog/archives/2017/12/04/cabasicanimation-for-animating-strokes-plus-a-bonus-gratuitous-ui-interaction and some of my ideas


class PopView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        isUserInteractionEnabled = false
        
        let bubble = Bubble()
        bubble.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        layer.addSublayer(bubble)
        bubble.animate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07, execute: {
            for number in 1...6 {
                let line = Line()
                line.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                line.transform = CATransform3DMakeRotation(CGFloat.pi * 2 / CGFloat(6) * CGFloat(number), 0, 0, 1)
                self.layer.addSublayer(line)
                line.animate()
            }
        })
        
        let minOffset: UInt32 = 0
        let maxOffset: UInt32 = 400
        let rotation = CGFloat(arc4random_uniform(maxOffset - minOffset) + minOffset) / CGFloat(100)
        transform = CGAffineTransform(rotationAngle: rotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class Line: CAShapeLayer {
    
    override init() {
        super.init()
        
        createLine()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLine() {
        let bezPath = UIBezierPath()
        bezPath.move(to: CGPoint(x: 15, y: 0))
        let distance = CGFloat(arc4random_uniform(65 - 25) + 25)
        bezPath.addLine(to: CGPoint(x: distance, y: 0))
        
        lineWidth = 5
        lineCap = kCALineCapSquare
        //for randomizing color
        var randomColor =  arc4random_uniform(2) == 0 ? UIColor.red : UIColor.yellow
        let color2 = arc4random_uniform(2) == 0 ? UIColor.blue : UIColor.purple
        let color3 = arc4random_uniform(2) == 0 ? UIColor.orange : UIColor.green
        let color4 = arc4random_uniform(2) == 0 ? randomColor : color2
        let finalColor = arc4random_uniform(2) == 0 ? color4 : color3
        strokeColor = finalColor.cgColor
        path = bezPath.cgPath
    }
    
    func animate() {
        let duration: CFTimeInterval = 1.5
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.fromValue = 0
        end.toValue = 1.075
        end.beginTime = 0
        end.duration = duration * 0.75
        end.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        end.fillMode = kCAFillModeForwards
        
        let begin = CABasicAnimation(keyPath: "strokeStart")
        begin.fromValue = 0
        begin.toValue = 1.075
        begin.beginTime = duration * 0.15
        begin.duration = duration * 0.85
        begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        begin.fillMode = kCAFillModeBackwards
        
        let group = CAAnimationGroup()
        group.animations = [end, begin]
        group.duration = duration
        
        strokeEnd = 1
        strokeStart = 1
        
        add(group, forKey: "move")
    }
    
}

class Bubble: CAShapeLayer, CAAnimationDelegate {
    
    override init() {
        super.init()
        
        addCircle()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCircle() {
        let circlePath = UIBezierPath(ovalIn: CGRect(x: -15, y: -15, width: 33, height: 33))
        
        path = circlePath.cgPath
        strokeColor = UIColor.orange.cgColor
        fillColor = UIColor.clear.cgColor
        lineWidth = 3
    }
    
    func animate() {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 1
        scaleAnim.toValue = 1.25
        scaleAnim.duration = 0.1
        
        scaleAnim.delegate = self
        
        add(scaleAnim, forKey: "scaleCircle")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            opacity = 0
            CATransaction.commit()
        }
    }
    
}

class view : UIView{
 public init(){
        super.init(frame:CGRect(x:0,y:0,width:500,height:400))
    self.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(performAnim))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Perforum the animation
    @objc func performAnim(_ sender: UITapGestureRecognizer){
        switch sender.state {
        case .ended:
            let pop = PopView()
            pop.center = sender.location(in: self)
            self.addSubview(pop)
            
        default:
            print("Unhandled state of mind")
        }
    }
}




///displaying the class on the screen


var show = view()
PlaygroundPage.current.liveView = show
