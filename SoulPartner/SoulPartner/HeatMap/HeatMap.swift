//
//  HeatMap.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation
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

let num_Rows = 14
let num_Cols = 5

class HeatMap {
    
    func updateHeatMap(pressureData: [[Int]]) -> UIImage{
        self.pressure_Data = pressureData
        
        self.pressureMatrix = fill_pressure_values_for_image()
//        print("pressure matrix = ", self.pressureMatrix)
        color_map()
        
        /*
         * convert the pixel array into an image
         */
        self.right_sole_icon = imageFromARGB32Bitmap(pixels: self.pixelMatrix, width: image_width, height: image_height)
        return self.right_sole_icon!
    }
    
    func performSetup(_ pixelData: [PixelData]?) {
        copy_outline(pixelData)
        get_PP_location()

        pressureMatrix = fill_pressure_values_for_image(pixelMatrix)
        color_map()
        
        /*
         * convert the pixel array into an image
         */
        right_sole_icon = imageFromARGB32Bitmap(pixels: pixelMatrix, width: image_width, height: image_height)
    }
    
    private var pixelData: [PixelData]
    
    init() {
        
        self.p0 = Point_3D(x: 0, y: 0, z: 1)
        self.p1 = Point_3D(x: 0, y: 1, z: 0)
        self.p2 = Point_3D(x: 1, y: 0, z: 0)
        
        let soleImage: UIImage = UIImage(named: "right_sole_icon")!
        
        self.pixelData = soleImage.pixelData()!
        self.image_width = Int(soleImage.size.width)            // 82
        self.image_height = Int(soleImage.size.height)
        
        self.right_sole_icon = soleImage
        
        self.pressureMatrix = [[Int]](repeating: [Int](repeating: 0, count: self.image_width), count: self.image_height)
        
//        self.k_array_index_for_image = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 2), count: self.K), count: self.image_width * self.image_height)
//        self.k_array_for_image = [[Int]](repeating: [Int](repeating: 0, count: self.K), count: self.image_width * self.image_height)
        
        randomly_fill_pressure_data() //random set of pressure data
        
        
        
        performSetup(self.pixelData)
        
        print("done!!")
    }
    
    /**
     Fill in the pixelMatrix with the values from the given shoe
     */
    func copy_outline(_ pixelData: [PixelData]?) {
        
        for j in 0..<self.image_height{
            var pixArray = [PixelData]()
            for i in 0..<self.image_width{
                let one_d_rep = j*Int(self.image_width) + i
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
        var count: Double = 0
        for j in 0..<num_Rows {
            for i in 0..<num_Cols {
                let randomInt = Int.random(in: 0..<100)
                pressure_Data[j][i] = randomInt
                pressure_Data[j][i] = Int(count / Double(num_Rows * num_Cols) * 100)
                count += 1
            }
        }
    }
    
    /**
     Assign each pixel whether it's inside or outside boundary
     */
    func fill_pressure_values_for_image() -> [[Int]] {
        
        for j in 0..<self.image_height{
            for i in 0..<self.image_width-1{
                if pressureMatrix[j][i] != NOT_INSIDE_BOUNDARY {
                    pressureMatrix[j][i] = get_pressure_value_for_pixel_2(row: j, col: i)
                }
            }
        }
        
        return pressureMatrix
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
                if (pix.r == 0 && pix.g == 0 && pix.b == 0) || pix.a == 0 {
                    // set pressure to 'on boundary'
                    pressureMatrix[j][i] = NOT_INSIDE_BOUNDARY
                    if (next_pix.r == 0 && next_pix.g == 0 && next_pix.b == 0) || next_pix.a == 0 {
                        continue
                    }
                    
                    trigger = !trigger
                }
                else{
                    //white pixel
                    if trigger {
                        //                        if let index = indexMatrix.firstIndex(of: [j,i]){
                        //                            pressureMatrix[j][i] = pressure_Data[index/5][index%5]
                        //                        }
                        //
                        //                        else{
                        //                            // set pressure to 'inside boundary'
                        //                            pressureMatrix[j][i] = get_pressure_value_for_pixel(row: j, col: i)
                        //                        }
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
    func get_pressure_value_for_pixel_2(row: Int, col: Int) -> Int{
        //TODO: algorithm to find pressure value based on distance
        
        let k_array = k_array_for_image[row * col]
        let k_array_index = k_array_index_for_image[row * col]
        
        // calculate pressure based on k-neareast PP
        let totalDistance = k_array.reduce(0, +)
        
//        print("totalDistance = ", k_array)
        
        if totalDistance == 0{
            return self.pressure_Data[k_array_index[0][0]][k_array_index[0][1]]
        }
        
        var pressureVal: Double = 0
        
        for i in 0..<self.K{
            let pressure_row = k_array_index[i][0]
            let pressure_col = k_array_index[i][1]
            let pressure = self.pressure_Data[pressure_row][pressure_col]
            pressureVal += Double(pressure) * (Double(k_array[i]) / Double(totalDistance))
        }
        
        return Int(pressureVal)
        
    }
    
    /**
     Algorithm to find pressure value based on distance
     */
    func get_pressure_value_for_pixel(row: Int, col: Int) -> Int{
        //TODO: algorithm to find pressure value based on distance
        
        /** Distance to each pressure points */
        var dist_array = [Int](repeating: 0, count: num_Cols * num_Rows)
        
        /** K closest distance value */
        var k_array = [Int](repeating: 1000000, count: self.K)
        
        /** K closest indexes */
        var k_array_index = [[Int]](repeating: [Int](repeating: 0, count: 2), count: self.K)
        
        // KNN algorithm
        // finding distance to each PP
        var count = 0
        for k in indexMatrix{
            let x = k[0]
            let y = k[1]

            //            let dist = abs(x - row) + abs(y - col)
            let dist = sqrt(pow((CGFloat(x-row)),2) + pow((CGFloat(y - col)),2))
            //            print(dist)
            dist_array[count] = Int(dist)
            count += 1
        }

        // finding the k-nearest PP
        for i in 0..<dist_array.count {
            let max_in_k = k_array.max()!
            if dist_array[i] < max_in_k {
                let max_index = k_array.firstIndex(of: max_in_k)!
                k_array[max_index] = dist_array[i]
                k_array_index[max_index][0] = i / 5
                k_array_index[max_index][1] = i % 5
            }
        }
        
        // calculate pressure based on k-neareast PP
        let totalDistance = k_array.reduce(0, +)
        
        if totalDistance == 0{
            return self.pressure_Data[k_array_index[0][0]][k_array_index[0][1]]
        }
        
        var pressureVal: Double = 0
        
        for i in 0..<self.K{
            let pressure_row = k_array_index[i][0]
            let pressure_col = k_array_index[i][1]
            let pressure = self.pressure_Data[pressure_row][pressure_col]
            pressureVal += Double(pressure) * (Double(k_array[i]) / Double(totalDistance))
        }
        
        self.k_array_for_image.append(k_array)
        self.k_array_index_for_image.append(k_array_index)
        
        return Int(pressureVal)
        
    }
    
    /**
     sets the color of the pixel given the pressure matrix
     */
    func color_map(){
        
        for j in 0..<self.image_height {
            for i in 0..<self.image_width {
                if self.pressureMatrix[j][i] != NOT_INSIDE_BOUNDARY {
                    pixelMatrix[j][i] = from_pressure_data_to_pixel_data(pressureMatrix[j][i])
                }
                else{
//                    1E1B2F
//                    pixelMatrix[j][i] = PixelData(a: 1, r: 0x1e/255, g: 0x1b/255, b: 0x2f/255)
                      pixelMatrix[j][i] = PixelData(a: 0, r: 0/255, g: 0/255, b: 0/255)

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
    
    func randomize_data(){
        for j in 0..<num_Rows {
            for i in 0..<num_Cols {
                let randomInt = Int.random(in: 0..<100)
                pressure_Data[j][i] = randomInt
                
            }
        }
        
        pressureMatrix = fill_pressure_values_for_image(pixelMatrix)
        color_map()
        
        
        /*
         * convert the pixel array into an image
         */
        right_sole_icon = imageFromARGB32Bitmap(pixels: pixelMatrix, width: image_width, height: image_height)
    }
    
    private var p0: Point_3D!
    private var p1: Point_3D!
    private var p2: Point_3D!
    
    /** K used for KNN*/
    private let K = 7
    
    private let NOT_INSIDE_BOUNDARY = -1
    
    private var image_width = 0
    private var image_height = 0
    
    public var right_sole_icon: UIImage?
    
    
    /**
     Matrix of pixel values for the heat map. Size 82 x 199
     */
    private var pixelMatrix = [[PixelData]]()
    
    /**
     Raw data from sensors. Values between 0 and 99. Size 14 x 5
     */
    private var pressure_Data = [[Int]](repeating: [Int](repeating: 0, count: 5), count: 14)
    
    /**
     Matrix of pressure values for the heat map. Size 82 x 199
     */
    private var pressureMatrix: [[Int]]!
    
    
    /**
     Contains the x and y location for all 70 pressure points
     */
    private var indexMatrix = [[Int]](repeating: [Int](repeating: 0, count: 2), count: 70)
    
    /**
     Contains the K closest pressure point index for the entire image
     */
    private var k_array_index_for_image =  [[[Int]]]()
    
    /**
     Contains the K closest distance value
     */
    private var k_array_for_image = [[Int]]()
    
}

extension HeatMap{
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
