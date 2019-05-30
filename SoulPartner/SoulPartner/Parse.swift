//
//  Parse.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation

struct DataStruct {
    var pressureData:[[Int]]
    var sample: Int
    
}

var val: String!

class Parse {
    
    static let instance = Parse()
    
    init() {
        self.initVar()
    }
    
    func initVar() {
        end_of_packet = false
        tempString = ""
        temp = true
    }
    
    func processData(string: String) {
        processString(string: string)
        if end_of_packet{
            // make a function call to parse array
            decodeStruct()
            end_of_packet = false
            tempString = ""
//            print("package recieved: ", packetDict)
//            decodeData()
            notify(value: packetDict)
        }
    }
    
    private func decodeStruct(){
        packetDict[tempString.first!] = String(tempString.dropFirst())
    }
    
    private func processString(string: String) {
        // append to the array
        if string.contains("#"){
            for i in string {
                if i == "#" {
                    end_of_packet = true
                    break;
                }
                tempString += String(i)
            }
        }
        else {
            tempString += string
        }
    }
    
    func attachObserver(observer: Observer){
        Parse.observerArray.append(observer)
    }
    
    private func notify(value: [Character: String]){
//        print("notifyig ovserasf")
        
        
        for observer in Parse.observerArray{
            observer.update(value: value)
        }
    }
    
    private func decodeData() {
        //parse the data string into corresponding data type for each sensor
//        print("decode data")
        
//        print(packetDict["G"])
    }
    
    private var end_of_packet: Bool!
    private var packetDict = [Character: String]()
    private var tempString: String!
    static var observerArray = [Observer]()
    
    var dataStruct: DataStruct!
    
    var temp: Bool!
}
