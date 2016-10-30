//
//  CentralManager.swift
//  NexturnController
//
//  Created by Kengo Yokoyama on 2014/12/24.
//  Copyright (c) 2014年 Kengo Yokoyama. All rights reserved.
//

import Foundation
import CoreBluetooth

class CentralManager: CBCentralManager {
    
    fileprivate var nexturnObjectArray = [NexturnObject]()
    
    override init(delegate: CBCentralManagerDelegate?, queue: DispatchQueue?, options: [String : Any]? = nil) {
        super.init(delegate: delegate, queue: queue, options: options)
        self.delegate = self
    }
    
    // MARK: - Call from IBAction
    func ledButtonTapped(_ tag: NSInteger) {
        for nexturnObject in nexturnObjectArray {
            nexturnObject.ledButtonTapped(tag)
        }
    }
}

extension CentralManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            let options = ["CBCentralManagerScanOptionAllowDuplicatesKey" : true]
            scanForPeripherals(withServices: nil, options: options)
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else {
            return
        }
        
        switch name {
        case NexturnObject.Property.kName:
            let nexturnObject = NexturnObject()
            peripheral.delegate = nexturnObject
            nexturnObject.peripheral = peripheral
            connect(nexturnObject.peripheral!, options: nil)
            nexturnObjectArray.append(nexturnObject)
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let name = peripheral.name else {
            return
        }
        
        switch name {
        case NexturnObject.Property.kName:
            let UUID = CBUUID(string: NexturnObject.Property.kLEDServiceUUID)
            nexturnObjectArray.last?.peripheral?.discoverServices([UUID])
        default:
            break
        }
    }
}
