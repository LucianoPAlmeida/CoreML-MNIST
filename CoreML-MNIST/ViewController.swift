//
//  ViewController.swift
//  CoreML-MNIST
//
//  Created by Luciano Almeida on 6/27/18.
//  Copyright © 2018 Luciano Almeida. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var imgResized: UIImageView!
    @IBOutlet weak var drawerView: DrawerView!
    @IBOutlet weak var lblPrediction: UILabel!

    private var bottomLineLayer: CAGradientLayer = CAGradientLayer()
    
    var mnistModel: Mnist = Mnist()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawerView.delegate = self
        setupBottomLine()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutBottomLine()
    }

    private func setupBottomLine() {
        bottomLineLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor, UIColor.black.cgColor]
        bottomLineLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(bottomLineLayer)
    }
    
    private func layoutBottomLine() {
        let originY = drawerView.frame.origin.y + drawerView.frame.size.height - 1.0
        bottomLineLayer.frame = CGRect(origin: CGPoint(x: 0, y: originY),
                                       size: CGSize(width: drawerView.frame.size.width, height: 1.0))
    }
    
    fileprivate func predict() {
        guard let image = drawerView.snapshot, let buffer = preprocess(image: image) else { return }
        do {
            let prediction = try mnistModel.prediction(x__0: buffer)
            lblPrediction.text = "It's a \(prediction.classLabel)"
        } catch let error {
            print("\(error)")
        }
    }
    
    fileprivate func preprocess(image: UIImage) -> CVPixelBuffer? {
        let size = CGSize(width: 28, height: 28)
        let resized = image.resized(to: size)
        imgResized.image = resized
        return resized?.pixelBuffer()
    }
    
    fileprivate func clearPredictions() {
        lblPrediction.text = nil
        imgResized.image = nil
    }
}

extension ViewController: DrawerViewDelegate {
    func didEndDraw(view: DrawerView) {
        predict()
    }
    
    func didStartDraw(view: DrawerView) {
        clearPredictions()
    }
}

