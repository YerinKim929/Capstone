//
//  ViewController.swift
//  CapstoneProject
//
//  Created by Yerin Kim on 2023/04/08.
//

import UIKit
import SwiftUI

class PageViewControllor: UIViewController {
    private let gesture = RightToLeftSwipeGestureRecogizer()
    private var animator: UIViewPropertyAnimator?
    private var views = [mainView1.view, mainView2.view]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.views.forEach {
            self.view.addSubview($0!)
            $0!.alpha = 0
            $0!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([$0!.leftAnchor.constraint(equalTo: self.view.leftAnchor),$0!.rightAnchor.constraint(equalTo: self.view.rightAnchor),$0!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),$0!.topAnchor.constraint(equalTo: self.view.topAnchor)])
        }
        
        self.views.first??.alpha = 1
        self.view.addGestureRecognizer(self.gesture)
        self.gesture.addTarget(self, action: #selector(handleGesture(_:)))
    }
    

    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            self.view.isUserInteractionEnabled = false
            self.animator = self.getNextAnimator()
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
        
        let currentView = self.views[0]
        let nextView = self.views[1]
        
        // Init
        let animator = UIViewPropertyAnimator(
            duration: 0.5, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        
        // Animation
        animator.addAnimations {
            UIView.animate(withDuration: 1) {
                currentView?.transform = .init(translationX: -UIScreen.main.bounds.width, y: 0)
                nextView?.alpha = 1
            }
        }
        
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
