//
//  heatMap2.0.swift
//  HeatMap
//
//  Created by Ravi Patel on 5/18/19.
//  Copyright © 2019 Design Comeptition. All rights reserved.
//

import UIKit
import CoreGraphics


public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

class HeatMap_2_0: UIViewController{
    
    @IBOutlet weak var right_sole_icon: UIImageView!
    
    var pixelMatrix = [[PixelData]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let width = self.view.bounds.width
//        let height = self.view.bounds.height
//
//        let image_width: CGFloat = 50
//        let image_height: CGFloat = 140
//
//        var pixels = [PixelData]()
//
//        let red = PixelData(a: 255, r: 255, g: 0, b: 0)
//        let green = PixelData(a: 255, r: 0, g: 255, b: 0)
//        let blue = PixelData(a: 255, r: 0, g: 0, b: 255)
//
//        for _ in 1...2333 {
//            pixels.append(red)
//        }
//        for _ in 1...2333 {
//            pixels.append(green)
//        }
//        for _ in 1...2334 {
//            pixels.append(blue)
//        }
//
//        let image = imageFromARGB32Bitmap(pixels: pixels, width: Int(image_width), height: Int(image_height))
//        let imageView = UIImageView(frame: CGRect(x: width * 0.5 - image_width * 0.5, y: height * 0.5 - image_height * 0.5, width: image_width, height: image_height))
//        imageView.image = image
        //        self.view.addSubview(imageView)

        
        let pixelData = right_sole_icon.image?.pixelData()
        let image_width = right_sole_icon.image!.size.width             // 82
        let image_height = right_sole_icon.image!.size.height          // 199
        
        for j in 0..<Int(image_height){
            var pixArray = [PixelData]()
            for i in 0..<Int(image_width){
                if let pix = pixelData![j*Int(image_height) + i]{
                
                }
                pixArray.append(PixelData(a: 255, r: 255, g: 255, b: 255))
            }
            pixelMatrix.append(pixArray)
        }
        
        for i in pixelData! {
            if i.r != 0 && i.b != 0 && i.g != 0{
                print(i)
            }
        }
        print(pixelData?.count)
        print(image_width)
        print(image_height)
        print("done!!")
    }
}

extension HeatMap_2_0{
    func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
        guard width > 0 && height > 0 else { return nil }
        guard pixels.count == width * height else { return nil }
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        var data = pixels // Copy to mutable []
        guard let providerRef = CGDataProvider(data: NSData(bytes: &data,
                                                            length: data.count * MemoryLayout<PixelData>.size)
            )
            else { return nil }
        
        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * MemoryLayout<PixelData>.size,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
            )
            else { return nil }
        
        print("returning image")
        return UIImage(cgImage: cgim)
    }
}

extension UIImage {
//    func pixelData() -> [UInt8]? {
//        let size = self.size
//        let dataSize = size.width * size.height * 4
//        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: &pixelData,
//                                width: Int(size.width),
//                                height: Int(size.height),
//                                bitsPerComponent: 8,
//                                bytesPerRow: 4 * Int(size.width),
//                                space: colorSpace,
//                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
//        guard let cgImage = self.cgImage else { return nil }
//        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//
//        return pixelData
//    }
    func pixelData() -> [PixelData]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        var pixelData2 = [PixelData]()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        CGImageAlphaInfo.premultipliedFirst.rawValue
        
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let split = 4
        for i in 0..<pixelData.count/split{
            let red = pixelData[split*i]
            let green = pixelData[split*i + 1]
            let blue = pixelData[split*i + 2]
            let alpha = pixelData[split*i + 3]
            pixelData2.append(PixelData(a: alpha, r: red, g: green, b: blue))
        }
        
        return pixelData2
    }
}
