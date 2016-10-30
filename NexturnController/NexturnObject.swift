//
//  NexturnObject.swift
//  NexturnController
//
//  Created by Kengo Yokoyama on 2014/12/24.
//  Copyright (c) 2014年 Kengo Yokoyama. All rights reserved.
//

import Foundation
import CoreBluetooth

class NexturnObject: NSObject {
    
    enum Property {
        static let kName = "Nexturn"
        static let kLEDServiceUUID = "FFE0"
    }

    var peripheral: CBPeripheral?
    fileprivate var characteristicArray = [CBCharacteristic]()
    
    fileprivate enum ledButtonTag: Int {
        case red, green, blue, white, random, off

        fileprivate var type: Data {
            get {
                switch self {
                case .red, .green, .blue, .white:
                    return createLedData(UInt8(arc4random_uniform(UInt32(UInt8.max))))
                case .random:
                    return createLedData(arc4random_uniform(UInt32.max))
                case .off:
                    return createLedData(UInt32(0))
                }
            }
        }
        
        func createLedData(_ hexData: UInt32) -> Data {
            let red   = UInt8((hexData & 0xFF000000) >> 24)
            let green = UInt8((hexData & 0x00FF0000) >> 16)
            let blue  = UInt8((hexData & 0x0000FF00) >>  8)
            let white = UInt8( hexData & 0x000000FF)
            let data  = [red, green, blue, white]
        
            return Data(data)
        }
        
        func createLedData(_ hexData: UInt8) -> Data {
            let data = UInt8(hexData)
            
            return Data([data])
        }
    }
    
    func ledButtonTapped(_ tag: NSInteger) {
        guard let buttonTag = ledButtonTag(rawValue: tag) else {
            return
        }
        
        if characteristicArray.count <= tag {
            return
        }
        
        switch buttonTag {
        case .red, .green, .blue, .white:
            peripheral?.writeValue(buttonTag.type, for: characteristicArray[tag], type: .withResponse)
        case .random, .off:
            peripheral?.writeValue(buttonTag.type, for: characteristicArray[4], type: .withResponse)
        }
    }
}

extension NexturnObject: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach {
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach {
            characteristicArray.append($0)
        }
    }
}
