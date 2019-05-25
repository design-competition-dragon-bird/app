//
//  BluetoothInterface.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BluetoothInterface: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate {
    
    
    static let bt_instance = BluetoothInterface()
    
    override init() {
        super.init()
        print("Stella Manager init")
        centralManager = CBCentralManager(delegate: self, queue: nil)
//        initVar()
//        let storyboard = UIStoryboard(name: "tabBar", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "gyroModel") as! Model3DViewController
//        controller.addToObserver()
//        Model3DViewController.instance.addToObserver()
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
            print("Turn on Bluetooth on phone.")
            notifyBTConnectionObservers(value: "Bluetooth connection could not be established. Make the the bluetooth on phone is ON.")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //        print(peripheral.name ?? "nil")
        notifyBTConnectionObservers(value: "Searching for nearby compatable bluetooth devices.")
        if  peripheral_Name == peripheral.name {
            if self.peripheral == nil {
                self.peripheral = peripheral
                self.centralManager.connect(peripheral, options: nil)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.centralManager?.stopScan()
        notifyBTConnectionObservers(value: "Nearby bluetooth device found.")
        if nil == self.connectedPeripheral {
            self.connectedPeripheral = peripheral
            self.connectedPeripheral.delegate = self    //Allowing the peripheral to discover services
            notifyBTConnectionObservers(value: "Connected") // swtch screen if this gets called
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
            print("serviceDictionary", serviceDictionary);
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            notifyObservers(data: data)
            let val = String.init(data: data, encoding: .utf8) ?? "nil"
//            print("val = ", val)
            self.parser.processData(string: val)
//            Parse.instance.processData(string: val)
        }
        //        print(serviceDictionary)
    }
    
    private func notifyObservers(data: Data) {
        //        print("notifying observer")
        
    }
    
    func writeData(data: Data, characteristic: CBCharacteristic) {
        connectedPeripheral?.writeValue(data, for: characteristic, type: .withoutResponse)
    }
    
    func addBTConnectionObserver(observer: BT_Connection_Observer){
        bt_connection_observers.append(observer)
        initVar()
    }
    
    private func notifyBTConnectionObservers(value: String){
        for i in bt_connection_observers{
            i.update(value: value)
        }
    }
    
    private func startScan() {
        notifyBTConnectionObservers(value: "Starting scan...")
        centralManager?.stopScan()
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    var connectedPeripheral: CBPeripheral!
    
    private var parser: Parse!
    private var peripheral_Name = "SAI"
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var serviceDictionary: [CBService: [CBCharacteristic]]!
    private var bt_connection_observers = [BT_Connection_Observer]()
}
