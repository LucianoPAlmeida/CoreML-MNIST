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
    
    @IBOutlet weak var imgREsized: UIImageView!
    @IBOutlet weak var drawerView: DrawerView!
    @IBOutlet weak var lblPrediction: UILabel!
    
    var mnistModel: Mnist = Mnist()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func preprocess(image: UIImage) -> CVPixelBuffer? {
        let size = CGSize(width: 28, height: 28)
        let resized = image.resized(to: size)
        imgREsized.image = resized
        return resized?.pixelBuffer()
    }
    
}

extension ViewController: DrawerViewDelegate {
    func didEndDraw(view: DrawerView) {
        predict()
    }
    
    func didStartDraw(view: DrawerView) {
        lblPrediction.text = nil
    }
}

