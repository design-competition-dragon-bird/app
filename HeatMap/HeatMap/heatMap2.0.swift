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
    
    let num_Rows = 14
    let num_Cols = 5
    
    var pixelMatrix = [[PixelData]]()
    var pressure_Data = [[CGFloat]]()
    
    var indexMatrix = [[Int]](repeating: [Int](repeating: 0, count: 2), count: 70)//contains the x and y location for all 70 pressure points
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let soleImage: UIImage = UIImage(named: "right_sole_icon")!
        
        let pixelData = soleImage.pixelData()
        let image_width = Int(soleImage.size.width)            // 82
        let image_height = Int(soleImage.size.height)          // 199
        
        /*
        * fill in the pixelMatrix with the values from the given shoe
        */
        for j in 0..<image_height{
            var pixArray = [PixelData]()
            for i in 0..<image_width{
                if let pix = pixelData?[j*Int(image_width) + i]{
                    if pix.r == 0 && pix.g == 0 && pix.b == 0 {
                        pixArray.append(pix)
                    }
                    else {
                        pixArray.append(PixelData(a: 255, r: 255, g: 255, b: 255))
                    }
                }
                else {
                    fatalError("pix cannot be found")
                }
            }
            pixelMatrix.append(pixArray)
        }
        
        update_index()
        print(indexMatrix)
        updateMap()
        
        /*
         * convert the pixel array into an image
         */
        right_sole_icon.image = imageFromARGB32Bitmap(pixels: pixelMatrix, width: image_width, height: image_height)
        
//        print(pixelMatrix.flatMap{$0}.count)
//        print(image_width)
//        print(image_height)
        print("done!!")
        
    }
    
    func update_index() {
        if let path = Bundle.main.path(forResource: "dataPoints", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, [String]> {
                    for point in jsonResult {
                        let row = Int(point.value[0])!
                        let col = Int(point.value[1])!
                        
                        indexMatrix[Int(point.key)!][0] = row
                        indexMatrix[Int(point.key)!][1] = col
                    }
                }
            } catch {
                // handle error
            }
        }
    }
    
    func updateMap() {
        for j in 0..<(num_Cols*num_Rows) {
            var point = indexMatrix[j]
            if var pix = pixelMatrix[point[0]][point[1]] as PixelData? {
                pix = PixelData(a: 255, r: 255, g: 0, b: 0) // update this according to recieved pressure data
                pixelMatrix[point[0]][point[1]] = pix
            }
        }
    }
    
}

extension HeatMap_2_0{
    func imageFromARGB32Bitmap(pixels: [[PixelData]], width: Int, height: Int) -> UIImage? {
        guard width > 0 && height > 0 else { return nil }
        guard (pixels.flatMap{$0}.count) == width * height else { return nil }
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        var temp_pixels = [PixelData]()
        for j in 0..<height {
            for i in 0..<width {
                if let pix = pixels[j][i] as PixelData? {
                    temp_pixels.append(pix)
                }
            }
        }
        
        var data = temp_pixels // Copy to mutable []
        guard let providerRef = CGDataProvider(data: NSData(bytes: &data,
                length: data.count * MemoryLayout<PixelData>.size)
            )
            else {
                print("provider ref failed")
                return nil }
        
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
            else {
                print("cgim failed")
                return nil }
        
        print("returning image")
        return UIImage(cgImage: cgim)
    }
}

extension UIImage {
    func pixelData() -> [PixelData]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 255, count: Int(dataSize))
        var pixelData2 = [PixelData]()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
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
