//
//  heatMap2.0.swift
//  HeatMap
//
//  Created by Ravi Patel on 5/18/19.
//  Copyright © 2019 Design Comeptition. All rights reserved.
//

import UIKit
import CoreGraphics

struct Point_3D{
    var x:CGFloat
    var y:CGFloat
    var z:CGFloat
}

public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

class HeatMap_2_0: UIViewController{
    
    @IBOutlet weak var right_sole_icon: UIImageView!
    
    var p0: Point_3D!
    var p1: Point_3D!
    var p2: Point_3D!
    
    let NOT_INSIDE_BOUNDARY = -1
    
    let num_Rows = 14
    let num_Cols = 5
    
    var image_width = 0
    var image_height = 0
    
    /**
        Matrix of pixel values for the heat map. Size 82 x 199
     */
    var pixelMatrix = [[PixelData]]()
    
    /**
        Raw data from sensors. Values between 0 and 99. Size 14 x 5
     */
    var pressure_Data = [[Int]](repeating: [Int](repeating: 0, count: 5), count: 14)
    
    /**
     Matrix of pressure values for the heat map. Size 82 x 199
     */
    var pressureMatrix: [[Int]]!

    
    /**
        Contains the x and y location for all 70 pressure points
     */
    var indexMatrix = [[Int]](repeating: [Int](repeating: 0, count: 2), count: 70)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p0 = Point_3D(x: 0, y: 0, z: 1)
        p1 = Point_3D(x: 0, y: 1, z: 0)
        p2 = Point_3D(x: 1, y: 0, z: 0)

        let soleImage: UIImage = UIImage(named: "right_sole_icon")!
        
        let pixelData = soleImage.pixelData()
        self.image_width = Int(soleImage.size.width)            // 82
        self.image_height = Int(soleImage.size.height)
        
        copy_outline(pixelData)
        get_PP_location()
        randomly_fill_pressure_data() //random set of pressure data
        pressureMatrix = fill_pressure_values_for_image(pixelMatrix)
        update_map_with_pressure_points()
        color_map()
        
        
        /*
         * convert the pixel array into an image
         */
        right_sole_icon.image = imageFromARGB32Bitmap(pixels: pixelMatrix, width: image_width, height: image_height)
        
        print("done!!")
        
    }
    
    /**
     Fill in the pixelMatrix with the values from the given shoe
     */
    func copy_outline(_ pixelData: [PixelData]?) {
        
        for j in 0..<self.image_height{
            var pixArray = [PixelData]()
            for i in 0..<self.image_width{
                let one_d_rep = j*Int(image_width) + i
                if let pix = pixelData?[one_d_rep]{//get corresponding pixel value from shoe outline matrix
                    if pix.r == 0 && pix.g == 0 && pix.b == 0 {
                        //if pixel belongs to outline, keep it
                        pixArray.append(pix)
                    }
                    else {
                        //otherwise append a white pixel
                        pixArray.append(PixelData(a: 255, r: 255, g: 255, b: 255))
                    }
                }
                else {
                    fatalError("pix cannot be found")
                }
            }
            pixelMatrix.append(pixArray)
        }
    }
    
    /**
     Reads JSON and updates the location of pressure points
     */
    func get_PP_location() {
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
    
    /**
     Randomly assigns each pressure point a value
     */
    func randomly_fill_pressure_data() {
        
        for j in 0..<num_Rows {
            for i in 0..<num_Cols {
                let randomInt = Int.random(in: 0..<100)
                pressure_Data[j][i] = randomInt
            }
        }
    }
    
    /**
        Assign each pixel whether it's inside or outside boundary
     */
    func fill_pressure_values_for_image(_ pixelMatrix: [[PixelData]]) -> [[Int]] {
        
        var pressureMatrix = [[Int]](repeating: [Int](repeating: 0, count: self.image_width), count: self.image_height)
        var trigger = false
        for j in 0..<self.image_height{
            trigger = false
            for i in 0..<self.image_width-1{
                let pix = pixelMatrix[j][i]
                let next_pix = pixelMatrix[j][i+1]
                if pix.r == 0 && pix.g == 0 && pix.b == 0 {
                    // set pressure to 'on boundary'
                    pressureMatrix[j][i] = NOT_INSIDE_BOUNDARY
                    if next_pix.r == 0 && next_pix.g == 0 && next_pix.b == 0 {
                        continue
                    }
                    
                    trigger = !trigger
                }
                else{
                    //white pixel
                    if trigger {
                        // set pressure to 'inside boundary'
                        pressureMatrix[j][i] = get_pressure_value_for_pixel(row: j, col: i)
                    }
                    else {
                        // set pressure to 'outside boundary'
                        pressureMatrix[j][i] = NOT_INSIDE_BOUNDARY
                    }
                    
                }
                
            }
            
            // edge case
            if trigger{
                for k in 0..<self.image_width{
                    pressureMatrix[j][k] = NOT_INSIDE_BOUNDARY
                }
            }
            pressureMatrix[j][image_width - 1] = NOT_INSIDE_BOUNDARY
        }
        
        return pressureMatrix
    }
    
    /**
        Algorithm to find pressure value based on distance
     */
    func get_pressure_value_for_pixel(row: Int, col: Int) -> Int{
        //TODO: algorithm to find pressure value based on distance
        return Int.random(in: 0..<100)
    }
    
    /**
        Renders the map with the location of the 70 pressure points
     */
    func update_map_with_pressure_points() {
        for j in 0..<(num_Cols*num_Rows) {
            var point = indexMatrix[j]
            pressureMatrix[point[0]][point[1]] = pressure_Data[j / 14][j % 5]
        }
    }
    
    func color_map(){
        
        for j in 0..<self.image_height {
            for i in 0..<self.image_width {
                if pressureMatrix[j][i] != NOT_INSIDE_BOUNDARY {
                    pixelMatrix[j][i] = from_pressure_data_to_pixel_data(pressureMatrix[j][i])
                }
            }
        }
    }
    
    func from_pressure_data_to_pixel_data(_ pressure_value: Int) -> PixelData{
        var pixelData = PixelData(a: 255, r: 255, g: 0, b: 0)
        
        let new_color = get_color_from_pressure_data(p0: self.p0, p1: self.p1, p2: self.p2, t: CGFloat(pressure_value) / 100)
        pixelData.r = UInt8(new_color.x * 255)
        pixelData.g = UInt8(new_color.y * 255)
        pixelData.b = UInt8(new_color.z * 255)
        
        return pixelData
    }
    
    func get_color_from_pressure_data(p0: Point_3D, p1: Point_3D, p2: Point_3D, t: CGFloat) -> Point_3D{
        var pFinal = Point_3D(x: 0, y: 0, z: 0)
        
        pFinal.x = sqrt(t)
        pFinal.y = -4 * pow(t - 0.5, 2) + 1
        pFinal.z = -pow(t, 2) + 1
        
        return pFinal
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
