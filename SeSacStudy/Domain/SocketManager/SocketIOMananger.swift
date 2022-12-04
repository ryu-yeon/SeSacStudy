//
//  SocketIOMananger.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/01.
//

import Foundation

import SocketIO

final class SocketIOMananger {
    
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    init(myUID: String) {
        
        manager = SocketManager(socketURL: URL(string: EndPoint.baseURL)!, config: [
            .forceWebsockets(true)
        ])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            self.socket.emit("changesocketid", myUID)
        }

        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        socket.on("chat") { dataArray, ack in
            print("CHAT RECEIVED", dataArray, ack)

            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            
            print("CHECK >>>", chat, from, to, createdAt)

            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["id": id, "chat": chat, "createdAt": createdAt, "from": from, "to": to])
        }
    }
    
    func establishConnection() {

        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }

}
