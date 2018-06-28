//
//  DrawerView.swift
//  CoreML-MNIST
//
//  Created by Luciano Almeida on 6/27/18.
//  Copyright © 2018 Luciano Almeida. All rights reserved.
//

import UIKit
import QuartzCore

protocol DrawerViewDelegate: AnyObject {
    func didStartDraw(view: DrawerView)
    func didEndDraw(view: DrawerView)
}

class DrawerView: UIView {

    var currentPath: UIBezierPath = UIBezierPath()
    var startPoint: CGPoint = CGPoint.zero
    
    var lineColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var delegate: DrawerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentPath.lineWidth = 5.0

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        currentPath.lineWidth = 5.0
    }
    
    private func startDraw(at point: CGPoint) {
        currentPath.move(to: point)
        delegate?.didStartDraw(view: self)
    }
    
    private func clearCurrentDrawing() {
        currentPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    private func endDrawing() {
        delegate?.didEndDraw(view: self)
    }
    
    // MARK: Overrides
    override func draw(_ rect: CGRect) {
        lineColor.setStroke()
        UIColor.clear.setFill()
        self.currentPath.stroke()
        self.currentPath.fill()
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        clearCurrentDrawing()
        let point = touch.location(in: self)
        startPoint = point
        startDraw(at: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentPath.addLine(to: touch.location(in: self))
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        if point != startPoint {
            endDrawing()
        }
    }

}
