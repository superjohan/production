//
//  UdpLightUpdater.swift
//  production
//
//  Created by Johan Halin on 02/03/2018.
//  Copyright © 2018 Jumalauta. All rights reserved.
//

import Foundation

/*
 this.dataPacket = new Uint8Array(this.headerSize + 6 * this.lightCount);
 this.dataPacket[ 0] = 1; // spec version
 for (var i = 0; i < this.lightCount; i++) {
 var light = this.headerSize + 6 * i;
 this.dataPacket[light + 0] = 1; // type = light
 this.dataPacket[light + 1] = i; // light id
 this.dataPacket[light + 2] = 0; // light type (0 = RGB)
 this.dataPacket[light + 3] = 0x00; // Red
 this.dataPacket[light + 4] = 0x00; // Green
 this.dataPacket[light + 5] = 0x00; // Blue
 }
 */

class UdpLightUpdater {
    let socket: GCDAsyncUdpSocket = GCDAsyncUdpSocket()
    
    func send(leftColorR: UInt8,
              leftColorG: UInt8,
              leftColorB: UInt8,
              middleColorR: UInt8,
              middleColorG: UInt8,
              middleColorB: UInt8,
              rightColorR: UInt8,
              rightColorG: UInt8,
              rightColorB: UInt8) {
        var dataPacket = Array<UInt8>()
        dataPacket.append(1)
        
        for i in 0..<24 {
            dataPacket.append(1)
            dataPacket.append(UInt8(i))
            dataPacket.append(0)
            
            let r: UInt8
            let g: UInt8
            let b: UInt8

            if i >= 0 && i < 8 {
                r = leftColorR;
                g = leftColorG;
                b = leftColorB;
            } else if i >= 8 && i < 16 {
                r = middleColorR;
                g = middleColorG;
                b = middleColorB;
            } else {
                r = rightColorR;
                g = rightColorG;
                b = rightColorB;
            }
                        
            dataPacket.append(r)
            dataPacket.append(g)
            dataPacket.append(b)
        }
        
        let data = Data(bytes: dataPacket)
        self.socket.send(data, toHost: "valot.party", port: 9909, withTimeout: -1, tag: 1)
    }
    
    func send(on: Bool) {
        let component: UInt8 = on ? 0xff : 0x00

        send(
            leftColorR: component,
            leftColorG: component,
            leftColorB: component,
            middleColorR: component,
            middleColorG: component,
            middleColorB: component,
            rightColorR: component,
            rightColorG: component,
            rightColorB: component
        )
    }
}
