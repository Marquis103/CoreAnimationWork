/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ViewController: UIViewController {
  
  // MARK: ui outlets
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!
  
  var didInitialLayout = false
  let info = UILabel()
  
  // MARK: view controller lifecycle
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if !didInitialLayout {
      presentationAnimations()
      didInitialLayout = true
    }
	
	animateInfo()
  }
	
	override func viewDidLoad() {
		username.delegate = self
		password.delegate = self
	}
  
  func presentationAnimations() {
	let flyRight = CASpringAnimation(keyPath: "position.x")
	
	//damping
	flyRight.damping = 250.0 //positive float default is 10
	flyRight.mass = 50.0 //defaults to 1
	flyRight.stiffness = 800.0//defaults to 100
	flyRight.initialVelocity = 1.0 //defaults to 0
	
	flyRight.duration = flyRight.settlingDuration
	flyRight.toValue = view.bounds.size.width / 2
	flyRight.fromValue = -view.bounds.size.width / 2
	flyRight.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
	//flyRight.timingFunction = CAMediaTimingFunction(controlPoints: 0.11, 1, 0.83, 0.67)
	//flyRight.speed = 0.5
	
	flyRight.fillMode = kCAFillModeBackwards
	flyRight.delegate = self
	
	flyRight.setValue("form", forKey: "name")
	flyRight.setValue(heading.layer, forKey: "layer")
	
	heading.layer.addAnimation(flyRight, forKey: nil)
	
	let time = CACurrentMediaTime()
	
	flyRight.beginTime = time + 0.33
	flyRight.setValue(username.layer, forKey: "layer")
	username.layer.addAnimation(flyRight, forKey: nil)
	
	flyRight.beginTime = time + 0.5
	flyRight.setValue(password.layer, forKey: "layer")
	password.layer.addAnimation(flyRight, forKey: nil)
	
	/*
	//let flyRight = CABasicAnimation(keyPath: "position.x")
	
	flyRight.toValue = view.bounds.size.width / 2
	flyRight.fromValue = -view.bounds.size.width / 2
	flyRight.duration = 0.5
	//flyRight.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
	flyRight.timingFunction = CAMediaTimingFunction(controlPoints: 0.11, 1, 0.83, 0.67)
	//flyRight.speed = 0.5
	
	flyRight.fillMode = kCAFillModeBackwards
	flyRight.delegate = self
	
	flyRight.setValue("form", forKey: "name")
	flyRight.setValue(heading.layer, forKey: "layer")
	
	heading.layer.addAnimation(flyRight, forKey: nil)
	
	let time = CACurrentMediaTime()
	
	flyRight.beginTime = time + 0.33
	flyRight.setValue(username.layer, forKey: "layer")
	username.layer.addAnimation(flyRight, forKey: nil)
	
	flyRight.beginTime = time + 0.5
	flyRight.setValue(password.layer, forKey: "layer")
	password.layer.addAnimation(flyRight, forKey: nil)
	*/
	animateLoginButton()
	animateCloud(cloud1.layer)
	animateCloud(cloud2.layer)
	animateCloud(cloud3.layer)
	animateCloud(cloud4.layer)
	
	animateHotAirBallon()
	
  }
	
	func animateHotAirBallon() {
		let balloon = CALayer()
		balloon.contents = UIImage(named: "balloon")!.CGImage
		balloon.frame = CGRect(x: -50.0, y: 0, width: 50.0, height: 65.0)
		view.layer.insertSublayer(balloon, above: username.layer)
		
		//key frame animation
		let flight = CAKeyframeAnimation(keyPath: "position")
		flight.duration = 12.0
		flight.keyTimes = [0, 0.5, 1.0]
		flight.values = [
			CGPoint(x: -50.0, y: 0.0),
			CGPoint(x: view.frame.size.width + 50.0, y: 160.0),
			CGPoint(x: -50.0, y: view.frame.size.width/2)
			].map {(NSValue(CGPoint: $0))}
		
		balloon.addAnimation(flight, forKey: nil)
	}
	
	func animateLoginButton() {
		let groupAnimation = CAAnimationGroup()
		groupAnimation.duration = 0.5
		groupAnimation.beginTime = CACurrentMediaTime() + 0.5
		groupAnimation.fillMode = kCAFillModeBackwards
		groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		
		let scaleDown = CABasicAnimation(keyPath: "transform.scale")
		scaleDown.fromValue = 3.5
		scaleDown.toValue = 1.0
		
		let rotate = CABasicAnimation(keyPath: "transform.rotation")
		rotate.fromValue = CGFloat(M_PI_4)
		rotate.toValue = 0.0
		
		let fadeIn = CABasicAnimation(keyPath: "opacity")
		fadeIn.fromValue = 0.0
		fadeIn.toValue = 1.0
		
		groupAnimation.animations = [scaleDown, rotate, fadeIn]
		loginButton.layer.addAnimation(groupAnimation, forKey: nil)
	}
	
	func animateCloud(cloudLayer: CALayer) {
		let cloudSpeed = 30.0 / Double(view.frame.size.width)
		let duration = NSTimeInterval(view.frame.size.width - cloudLayer.frame.origin.x) * cloudSpeed
		
		let cloudMove = CABasicAnimation(keyPath: "position.x")
		cloudMove.duration = duration
		cloudMove.fromValue = cloudLayer.frame.origin.x
		cloudMove.toValue = view.frame.size.width + cloudLayer.frame.size.width
		cloudMove.delegate = self
		cloudMove.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		
		cloudMove.setValue("cloud", forKey: "name")
		cloudMove.setValue(cloudLayer, forKey: "layer")
		
		cloudLayer.addAnimation(cloudMove, forKey: nil)
	}
  
  func animateInfo() {
    //add text info
    info.frame = CGRect(x: 0.0, y: loginButton.center.y + 30.0,
                                width: view.frame.size.width, height: 30)
    info.backgroundColor = UIColor.clearColor()
    info.font = UIFont(name: "HelveticaNeue", size: 12.0)
    info.textAlignment = .Center
    info.textColor = UIColor.whiteColor()
    info.text = "Tap on a field and enter username and password"
    view.insertSubview(info, belowSubview: loginButton)
	
	let infoGroup = CAAnimationGroup()
	infoGroup.beginTime = CACurrentMediaTime() + 0.5
	infoGroup.duration = 10.0
	infoGroup.fillMode = kCAFillModeBackwards
	infoGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
	
	let flyLeft = CABasicAnimation(keyPath: "position.x")
	flyLeft.fromValue = info.layer.position.x + view.frame.size.width
	flyLeft.toValue = info.layer.position.x
	
	let fadeIn = CABasicAnimation(keyPath: "opacity")
	fadeIn.fromValue = 0.0
	fadeIn.toValue = 1.0
	fadeIn.duration = 5.0
	
	infoGroup.animations = [flyLeft, fadeIn]
	info.layer.addAnimation(infoGroup, forKey: nil)
	/*
	let flyLeft = CABasicAnimation(keyPath: "position.x")
	flyLeft.fromValue = info.layer.position.x + view.frame.size.width
	flyLeft.toValue = info.layer.position.x
	flyLeft.duration = 10.0
	info.layer.addAnimation(flyLeft, forKey: nil)
	
	let fadeIn = CABasicAnimation(keyPath: "opacity")
	fadeIn.fromValue = 0.0
	fadeIn.toValue = 1.0
	fadeIn.duration = 5.0
	info.layer.addAnimation(fadeIn, forKey: nil)*/
    
  }
  
  @IBAction func actionLogin(sender: AnyObject) {
    let startColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0).CGColor
	let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0).CGColor
	
	//update animation model tree
	loginButton.layer.backgroundColor = tintColor
	
	//send core animation to core animation server
	let tint = CABasicAnimation(keyPath: "backgroundColor")
	tint.fromValue = startColor
	tint.toValue = tintColor
	tint.duration = 1.0
	loginButton.layer.addAnimation(tint, forKey: nil)
	
	delay(seconds: 5) { 
		self.loginButton.layer.backgroundColor = startColor
		
		tint.fromValue = tintColor
		tint.toValue = startColor
		self.loginButton.layer.addAnimation(tint, forKey: nil)
	}
	
	let fade = CAKeyframeAnimation(keyPath: "opacity")
	fade.duration = 5
	fade.keyTimes = [0.0, 0.1, 0.9, 1.0]
	fade.values = [1.0, 0.33, 0.33, 1.00]
	loginButton.layer.addAnimation(fade, forKey: nil)
	info.layer.addAnimation(fade, forKey: nil)
	
  }
}

extension ViewController {
	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		guard let name = anim.valueForKey("name") as? String,
			let layer = anim.valueForKey("layer") as? CALayer else {
				return
		}
		
		if name == "form" {
			let bounce = CABasicAnimation(keyPath: "transform.scale")
			bounce.fromValue = 1.2
			bounce.toValue = 1.0
			bounce.duration = 0.5
			layer.addAnimation(bounce, forKey: nil)
		} else if name == "cloud" {
			layer.frame.origin.x = -layer.frame.size.width
			delay(seconds: 0.1, completion: {
				self.animateCloud(layer)
			})
		}
	}
}

extension ViewController : UITextFieldDelegate {
	func textFieldDidBeginEditing(textField: UITextField) {
		textField.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).CGColor
		textField.layer.shadowOffset = CGSize(width: 5, height: 5)
		textField.layer.masksToBounds = false
		
		textField.layer.shadowOpacity = 1.0
		let fadeIn = CABasicAnimation(keyPath: "opacity")
		fadeIn.fromValue = 0
		fadeIn.toValue = 1
		fadeIn.duration = 1.0
		textField.layer.addAnimation(fadeIn, forKey: nil)
		
		textField.layer.shadowOffset = CGSize(width: 5, height: 7)
		
		let shadowBounce = CASpringAnimation(keyPath: "shadowOffset")
		shadowBounce.fromValue = NSValue(CGSize: .zero)
		shadowBounce.toValue = NSValue(CGSize: CGSize(width: 5, height: 7))
		shadowBounce.damping = 6.0
		shadowBounce.duration = shadowBounce.settlingDuration
		textField.layer.addAnimation(shadowBounce, forKey: nil)
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		textField.layer.shadowOpacity = 0.0
	}
}