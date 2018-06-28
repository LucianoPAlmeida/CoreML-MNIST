//
//  UIImage+Extensions.swift
//  CoreML-MNIST
//
//  Created by Luciano Almeida on 6/27/18.
//  Copyright © 2018 Luciano Almeida. All rights reserved.
//

import UIKit
import CoreML

extension UIImage {
    
    func resized(to size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), false, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer? = nil
        
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, nil, &pixelBuffer)
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.readOnly)
        
        let colorspace = CGColorSpaceCreateDeviceGray()
        let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer!), width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: colorspace, bitmapInfo: 0)!
        
        guard let cg = self.cgImage else {
            return nil
        }
        
        bitmapContext.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return pixelBuffer
    }
}
