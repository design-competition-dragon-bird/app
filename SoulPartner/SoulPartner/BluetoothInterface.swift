//
//  BluetoothInterface.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothInterface: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate {
    
    override init() {
        super.init()
        print("Stella Manager init")
        centralManager = CBCentralManager(delegate: self, queue: nil)
        initVar()
    }
    
    func initVar() {
        peripheral = nil
        connectedPeripheral = nil
        self.serviceDictionary = [:]
        parser = Parse()
    }
    
    //This is a required function of the CBCentralManager
    //Called when state of CBCentralanager is updated (when it is initialized)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Starting Scan")
            startScan()
        }
        else {
            print("Turn on Bluetooth on phone and Stella")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //        print(peripheral.name ?? "nil")
        if  peripheral_Name == peripheral.name {
            if self.peripheral == nil {
                self.peripheral = peripheral
                self.centralManager.connect(peripheral, options: nil)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.centralManager?.stopScan()
        if nil == self.connectedPeripheral {
            self.connectedPeripheral = peripheral
            self.connectedPeripheral.delegate = self        //Allowing the peripheral to discover services
            print("connected to: \(peripheral.name!)")
            self.connectedPeripheral.discoverServices(nil)      //look for services for the specified peripheral
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        initVar()
        //Do Something
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        //Do nothing for now
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Listing all available services")
        print(peripheral.services)
        if let services = peripheral.services {
            for service in services{
                self.connectedPeripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            self.serviceDictionary[service] = service.characteristics
            for characteristic in characteristics{
                self.connectedPeripheral.setNotifyValue(true, for: characteristic)
                
                //                let data = "a\n".data(using: .utf8)!
                //                writeData(data: data, characteristic: characteristic)
            }
            print(serviceDictionary);
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            notifyObservers(data: data)
            let val = String.init(data: data, encoding: .utf8) ?? "nil"
            //            print("val = ", val)
            self.parser.processData(string: val)
        }
        //        print(serviceDictionary)
    }
    
    private func notifyObservers(data: Data) {
        //        print("notifying observer")
        
    }
    
    func writeData(data: Data, characteristic: CBCharacteristic) {
        connectedPeripheral?.writeValue(data, for: characteristic, type: .withoutResponse)
    }
    
    private func startScan() {
        centralManager?.stopScan()
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    var connectedPeripheral: CBPeripheral!
    
    private var parser: Parse!
    private var peripheral_Name = "SAI"
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var serviceDictionary: [CBService: [CBCharacteristic]]!
    
}