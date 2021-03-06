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
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image(actions: { (context) in
           self.draw(in: CGRect(origin: .zero, size: size))
        })
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer? = nil
        
        let width = Int(size.width)
        let height = Int(size.height)
        
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, nil, &pixelBuffer)
        
        guard let unwrappedPixelBuffer = pixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(unwrappedPixelBuffer, CVPixelBufferLockFlags.readOnly)
        
        let colorspace = CGColorSpaceCreateDeviceGray()
        guard let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(unwrappedPixelBuffer),
                                            width: width, height: height,
                                            bitsPerComponent: 8,
                                            bytesPerRow: CVPixelBufferGetBytesPerRow(unwrappedPixelBuffer),
                                            space: colorspace, bitmapInfo: 0) else { return nil }
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        bitmapContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return pixelBuffer
    }
}
