//
//  ViewController.swift
//  CapstoneProject
//
//  Created by Yerin Kim on 2023/04/08.
//

import UIKit
import SwiftUI

class ViewControllor: UIViewController {
    private let gesture = RightToLeftSwipeGestureRecogizer()
    private var animator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mainView1.view)
        self.view.addSubview(mainView2.view)
        self.view.addGestureRecognizer(self.gesture)
        
        self.gesture.addTarget(self, action: #selector(handleGesture(_:)))
    }
    
    @IBSegueAction func showMainView(_ coder: NSCoder) -> UIViewController? {return UIHostingController(coder: coder, rootView:CalendarView())}
    

    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            self.view.isUserInteractionEnabled = false
//            self.animator = self.getNextAnimator()
        case .changed:
            let translationX = -gesture.translation(in: self.view).x / self.view.bounds.width
            let fractionComplete = translationX.clamped(to: 0...1)
            guard self.animator?.fractionComplete != fractionComplete else {break}
            self.animator?.fractionComplete = fractionComplete
        case
            .ended,
            .cancelled
        :
            self.animator?.isReversed = gesture.velocity(in:self.view).x > -200 || gesture.state == .cancelled
            self.animator?.startAnimation() // isReversed를 사용하면 다시 active 해야 함
        default:
            break
        }
    }
    
    private func getNextAnimator() -> UIViewPropertyAnimator? {
        self.animator?.stopAnimation(false) // true인 경우 comletionHandler 호출 없이 inactive 상태, false인 경우 애니메이션이 멈춘 Stopped 상태 (finishAnimation과 같이 사용)
        self.animator?.finishAnimation(at: .end) // completion handler 호출, inactive 상태로 전환
        
        let currentView = mainView1.view
        let nextView = mainView2.view
        
        // Init
        let animator = UIViewPropertyAnimator(
            duration: 0.5, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        
        // Completion
        animator.addCompletion {
            [weak self, weak currentView] position in self?.view.isUserInteractionEnabled = true
            guard
                position == .end && animator.isReversed == false,
                let currentView = currentView
            else {return}
            
            currentView.removeFromSuperview()
            
            guard self?.animator === animator else {return}
            self?.animator = nil
            
        }
        
        return animator
    }
 }
