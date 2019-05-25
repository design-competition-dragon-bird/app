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

class Parse {
    
    init() {
        self.initVar()
    }
    
    func initVar() {
        end_of_packet = false
        tempString = ""
    }
    
    func processData(string: String) {
        processString(string: string)
        if end_of_packet{
            // make a function call to parse array
            decodeStruct()
            end_of_packet = false
            tempString = ""
            print("package recieved: ", packetDict)
            decodeData()
            notify(value: packetDict)
        }
    }
    
    private func decodeStruct(){
        packetDict[tempString.first!] = String(tempString.dropFirst())
    }
    
    private func processString(string: String) {
        // append to the array
        tempString += string
        if string.last == "\u{04}" {
            tempString = String(tempString.dropLast(2))
            end_of_packet = true
        }
    }
    
    func attachObserver(observer: Observer){
        observerArray.append(observer)
    }
    
    private func notify(value: [Character: String]){
        for observer in observerArray{
            observer.update(value: value)
        }
    }
    
    private func decodeData() {
        //parse the data string into corresponding data type for each sensor
        
    }
    
    private var end_of_packet: Bool!
    private var packetDict = [Character: String]()
    private var tempString: String!
    private var observerArray = [Observer]()
    
    var dataStruct: DataStruct!
}
