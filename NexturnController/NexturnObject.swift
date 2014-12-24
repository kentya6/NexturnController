//
//  NexturnObject.swift
//  NexturnController
//
//  Created by Y.K on 2014/12/24.
//  Copyright (c) 2014年 Yokoyama Kengo. All rights reserved.
//

import Foundation
import CoreBluetooth

class NexturnObject: NSObject, CBPeripheralDelegate {
    // MARK: - Please Replace This UUID to Your's Nexturn UUID
    let kNexturnUUID = "F71FCA69-78A5-B654-9667-F27BF8E5CAC9"
    let kNexturnName = "Nexturn"
    let kNexturnLEDServiceUUID = "FFE0"
    var peripheral: CBPeripheral?
    private var characteristicArray = [CBCharacteristic]()
    
    private enum ledButtonTag: Int {
        case Red, Green, Blue, White, Random, Off

        private var type: NSData {
            get {
                switch self {
                case .Red, .Green, .Blue, .White:
                    return createLedData(UInt8(arc4random_uniform(255)))
                case .Random:
                    return createLedData(arc4random_uniform(UInt32.max))
                case .Off:
                    return createLedData(UInt32(0))
                }
            }
        }
        
        // LEDデータを作成
        func createLedData(hexData: UInt32) -> NSData {
            var red   = Byte((hexData & 0xFF000000) >> 24)
            var green = Byte((hexData & 0x00FF0000) >> 16)
            var blue  = Byte((hexData & 0x0000FF00) >> 8)
            var white = Byte(hexData & 0x000000FF)
            var data  = [red, green, blue, white]
            
            return NSData(bytes: &data, length: 4)
        }
        
        // LEDデータを作成
        func createLedData(hexData: UInt8) -> NSData {
            var data = Byte(hexData)
            
            return NSData(bytes: &data, length: 1)
        }
    }
    
    // 押されたボタンに対応したデータをNexturnに送信
    func ledButtonTapped(tag: NSInteger) {
        let buttonTag = ledButtonTag(rawValue: tag)!
        
        switch buttonTag {
        case .Red, .Green, .Blue, .White:
            self.peripheral?.writeValue(buttonTag.type, forCharacteristic: characteristicArray[tag], type: .WithResponse)
        case .Random, .Off:
            self.peripheral?.writeValue(buttonTag.type, forCharacteristic: characteristicArray[4], type: .WithResponse)
        }
    }
    
    // MARK: - CBPeripheralDelegate
    // Service発見時に呼ばれる
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services {
            self.peripheral?.discoverCharacteristics(nil, forService: service as CBService)
        }
    }
    
    // Characteristic発見時に呼ばれる
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        for characteristic in service.characteristics {
            self.characteristicArray.append(characteristic as CBCharacteristic)
        }
    }
}