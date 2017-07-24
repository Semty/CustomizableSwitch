//
//  CustomizableSwitch.swift
//  CustomizableSwitch
//
//  Created by Ruslan Timchenko on 23/7/17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit

@IBDesignable
public class CustomizableSwitch: UIView {

    private var ball: SwitchBall!
    private var textView: TextView!
    private var textFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    internal var delegate: SwiftySwitchDelegate?
    private var shouldSkip: Bool = false
    private var isFirstLaunch: Bool = true
    
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var textIsOn: String = "" {
        didSet {
            config()
        }
    }
    @IBInspectable public var textIsOff: String = "" {
        didSet {
            config()
        }
    }
    @IBInspectable public var textColor: UIColor = .black {
        didSet {
            config()
        }
    }
    @IBInspectable public var textSize: CGFloat = 14.0 {
        didSet {
            config()
        }
    }
    
    @IBInspectable public var textString: String! {
        willSet {
            if let newFont = UIFont.init(name: newValue,
                                         size: textSize) {
                textFont = newFont
            }
        }
        didSet {
            config()
        }
    }
    
    @IBInspectable public var isOn: Bool = false {
        didSet {
            if !shouldSkip {
                if isOn {
                    isMoving = true
                    let firstLaunch = isFirstLaunch
                    DispatchQueue.main.async { [weak self] in
                        self?.textView.textLabel.isHidden = firstLaunch ? false : true
                        self?.isFirstLaunch = false
                        self?.ball.turnOn {
                            self?.isMoving = false
                            self?.config()
                        }
                    }
                } else {
                    isMoving = true
                    let firstLaunch = isFirstLaunch
                    DispatchQueue.main.async { [weak self] in
                        self?.textView.textLabel.isHidden = firstLaunch ? false : true
                        self?.isFirstLaunch = false
                        self?.ball.turnOff {
                            self?.isMoving = false
                            self?.config()
                        }
                    }
                }
            }
            shouldSkip = false
        }
    }
    @IBInspectable public var mySize: CGSize = CGSize(width: 66, height: 29) {
        didSet {
            config()
        }
    }
    @IBInspectable public var myColor: UIColor = UIColor(red: 35/255, green: 110/255, blue: 129/255, alpha: 1/1) {
        didSet {
            config()
        }
    }
    @IBInspectable public var corners0to1: CGFloat = 0.5 {
        didSet {
            if corners0to1 > 1 || corners0to1 < 0 {
                corners0to1 = 0.5
            }
            config()
        }
    }
    @IBInspectable public var dotTime: Double = 1 {
        didSet {
            if dotTime > 20 || dotTime < 0 {
                dotTime = 1
            }
            config()
        }
    }
    @IBInspectable public var dotSpacer: Int = 2 {
        didSet {
            config()
        }
    }
    @IBInspectable public var dotOffColor: UIColor = UIColor(red: 0/255, green: 66/255, blue: 99/255, alpha: 1/1) {
        didSet {
            config()
        }
    }
    @IBInspectable public var dotOnColor: UIColor = UIColor(red: 0/255, green: 199/255, blue: 170/255, alpha: 1/1) {
        didSet {
            config()
        }
    }
    @IBInspectable public var smallDotColor: UIColor = UIColor(red: 227/255, green: 49/255, blue: 67/255, alpha: 1/1) {
        didSet {
            config()
        }
    }
    @IBInspectable public var smallDot0to1: CGFloat = 0.36 {
        didSet {
            if smallDot0to1 > 0.99 || smallDot0to1 < 0 {
                smallDot0to1 = 0.36
            }
            config()
        }
    }
    
    private var isMoving: Bool = false
    private var tapRecognizer: UITapGestureRecognizer!
    private var swipeRecognizer: UISwipeGestureRecognizer!
    
    override public init(frame: CGRect) {
        print(frame)
        super.init(frame: frame)
        config()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    override public class var layerClass: AnyClass {
        get {
            return CALayer.self
        }
    }
    
    private func config() {
        let myFrame = CGRect(x: 0, y: 0, width: mySize.width, height: mySize.height)
        if CGFloat(dotSpacer) > (myFrame.height / 2) - 2 {
            dotSpacer = 2
        }
        self.backgroundColor = myColor
        self.layer.cornerRadius = myFrame.height * corners0to1
        var oldBall = ball
        ball = SwitchBall(dotOnColor, dotOffColor, smallDotColor, isOn, myFrame, dotSpacer, smallDot0to1, dotTime)
        textViewNear(ball: ball, withBallIsOn: isOn)
        self.addSubview(ball)
        oldBall?.removeFromSuperview()
        oldBall = nil
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        swipeRecognizer = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(self.onTap(_:)))
        swipeRecognizer.direction = [.left, .right]
        self.addGestureRecognizer(tapRecognizer)
        self.addGestureRecognizer(swipeRecognizer)
        self.isAccessibilityElement = true
        self.accessibilityLabel = "CustomSwitch"
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.isUserInteractionEnabled = true
    }
    
    private func textViewNear(ball: SwitchBall, withBallIsOn isOn: Bool) {
        var oldTextView = textView
        
        let textViewFrame = CGRect(x: isOn ? 0.0 : ball.frame.origin.x + ball.frame.width,
                                   y: 0.0,
                                   width: self.bounds.width - ball.bounds.width,
                                   height: self.bounds.height)
        
        textView = TextView(frame: textViewFrame,
                            text: isOn ? textIsOn : textIsOff,
                            textColor: textColor,
                            textFont: textFont,
                            spacing: CGFloat(dotSpacer))
        self.addSubview(textView)
        oldTextView?.removeFromSuperview()
        oldTextView = nil
    }
    
    func onTap(_ recognizer: UITapGestureRecognizer) {
        if !isMoving {
            if !isOn {
                isOn = true
                delegate?.valueChanged(sender: self)
            } else {
                isOn = false
                delegate?.valueChanged(sender: self)
            }
        }
    }
}

fileprivate class SwitchBall: UIView {
    
    private var centerBall: UIView!
    private var offColor: UIColor!
    private var onColor: UIColor!
    private var ballDiameter: CGFloat!
    private var dotSpacer: CGFloat!
    private var myFrame: CGRect!
    private var smallDotMultiplier: CGFloat!
    private var dotTravelTime: TimeInterval!
    
    fileprivate init(_ onColor: UIColor, _ offColor: UIColor, _ dotColor: UIColor, _ isOn: Bool, _ myFrame: CGRect, _ dotSpace: Int, _ smallDotMultiplier: CGFloat, _ dotTravelTime: TimeInterval) {
        self.myFrame = myFrame
        self.smallDotMultiplier = smallDotMultiplier
        self.dotTravelTime = dotTravelTime
        dotSpacer = CGFloat(dotSpace)
        ballDiameter = myFrame.height - (dotSpacer * 2)
        if isOn {
            super.init(frame: CGRect(x: myFrame.width - ballDiameter - dotSpacer, y: dotSpacer, width: ballDiameter, height: ballDiameter))
            self.backgroundColor = onColor
        } else {
            super.init(frame: CGRect(x: dotSpacer, y: dotSpacer, width: ballDiameter, height: ballDiameter))
            self.backgroundColor = offColor
        }
        
        self.offColor = offColor
        self.onColor = onColor
        
        self.layer.cornerRadius = ballDiameter / 2
        
        let centerBallDiameter = ballDiameter * smallDotMultiplier
        let centerBallSpacer = (ballDiameter - centerBallDiameter) / 2
        centerBall = UIView(frame: CGRect(x: centerBallSpacer, y: centerBallSpacer, width: centerBallDiameter, height: centerBallDiameter))
        centerBall.backgroundColor = dotColor
        centerBall.layer.cornerRadius = centerBallDiameter / 2
        centerBall.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(centerBall)
        NSLayoutConstraint(item: centerBall, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: centerBallDiameter).isActive = true
        NSLayoutConstraint(item: centerBall, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: centerBallDiameter).isActive = true
        NSLayoutConstraint(item: centerBall, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: centerBall, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        if isOn {
            centerBall.alpha = 1.0
        } else {
            centerBall.alpha = 0.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnOn(completion: @escaping () -> Void) {
        let tempView = UIView(frame: CGRect(x: ballDiameter / 2, y: ballDiameter / 2, width: 0, height: 0))
        tempView.backgroundColor = onColor
        tempView.layer.cornerRadius = ballDiameter / 2
        self.addSubview(tempView)
        
        UIView.animate(withDuration: dotTravelTime, animations: { [weak self] in
            if self != nil {
                tempView.frame = CGRect(x: 0, y: 0, width: self!.ballDiameter, height: self!.ballDiameter)
                tempView.layer.cornerRadius = self!.ballDiameter / 2
            }
            self?.frame.origin.x = self!.dotSpacer + (self!.myFrame.width - self!.ballDiameter - (self!.dotSpacer * 2))
            self?.layoutIfNeeded()
        }) { [weak self] _ in
            self?.backgroundColor = self!.onColor
            tempView.removeFromSuperview()
            completion()
        }
        
        UIView.animate(withDuration: (1 - Double(smallDotMultiplier!)) * dotTravelTime, delay: Double(smallDotMultiplier!) * dotTravelTime, options: [.transitionCrossDissolve], animations: { [weak self] in
            self?.centerBall.alpha = 1
            self?.bringSubview(toFront: self!.centerBall)
            self?.layoutIfNeeded()
            }, completion: nil)
    }
    
    func turnOff(completion: @escaping () -> Void) {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: ballDiameter, height: ballDiameter))
        tempView.backgroundColor = onColor
        self.addSubview(tempView)
        self.backgroundColor = offColor
        UIView.animate(withDuration: dotTravelTime, animations: { [weak self] in
            if self != nil {
                tempView.frame = CGRect(x: self!.ballDiameter / 2, y: self!.ballDiameter / 2, width: 0, height: 0)
                tempView.layer.cornerRadius = self!.ballDiameter / 2
            }
            self?.frame = CGRect(x: self!.dotSpacer, y: self!.dotSpacer, width: self!.ballDiameter, height: self!.ballDiameter)
            self?.layoutIfNeeded()
        }) { _ in
            tempView.removeFromSuperview()
            completion()
        }
        
        UIView.animate(withDuration: (1 - Double(smallDotMultiplier!)) * dotTravelTime) { [weak self] in
            self?.centerBall.alpha = 0.0
            self?.bringSubview(toFront: self!.centerBall)
            self?.layoutIfNeeded()
        }
    }
}

fileprivate class TextView: UIView {
    
    public var textLabel: UILabel!
    
    fileprivate init(frame: CGRect,
                     text: String,
                     textColor: UIColor,
                     textFont: UIFont,
                     spacing: CGFloat) {
        
        super.init(frame: frame)
        
        textLabel = UILabel(frame: CGRect.init(x: spacing,
                                               y: spacing,
                                               width: self.bounds.width - spacing*2,
                                               height: self.bounds.height - spacing*2))
        self.addSubview(textLabel)
        textLabel.font = textFont
        textLabel.text = text
        textLabel.textColor = textColor
        textLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SwiftySwitchDelegate {
    func valueChanged(sender: CustomizableSwitch)
}
