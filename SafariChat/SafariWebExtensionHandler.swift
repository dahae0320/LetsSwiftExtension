//
//  SafariWebExtensionHandler.swift
//  SafariChat
//
//  Created by Da Hae Lee on 2022/11/24.
//

import SafariServices
import os.log
import Network

let SFExtensionMessageKey = "message"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    var connection : NWConnection?

    override init() {
        super.init()
        /// 로컬로 새로운 네트워크 connection 생성
        self.connection = NWConnection.init(host: .init(stringLiteral: "127.0.0.1"), port: .init(integerLiteral: 12022), using: .udp)
        /// ??
        connection?.start(queue: DispatchQueue.init(label: "sender.safarichat"))
        connection?.stateUpdateHandler = {newState in
            switch newState {
            case .ready:
                os_log(.default, "extension connection ready.")
            default:
                break
            }
        }
    }

    /// background에 메세지 보낼 수 있다.
	func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey] as! NSDictionary
        /// message로 받은 body, location 값 변수에 할당
        let body = message["body"] as! String
        let location = message["location"] as! String
        
        /// 파일 단위로 Shared Resource에 저장.
        /// 이곳에 저장하면 Contanining app의 app들은 공동의 소스 사용가능
        /// Shared Resource를 사용하려면 info 리스트에 설정을 해야함. (App Group)
        let cachePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.dadahae.letchat")?.path
        var fileURL = URL.init(fileURLWithPath: cachePath!)
        fileURL.appendPathComponent("body.txt")
        try? body.write(toFile: fileURL.path, atomically: true, encoding: .utf8)
        
        /// log 찍음
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
        /// Notification을 위해 네트워크로 정보 보냄, UDP는 이를 계속 감지하고 있기 때문에 알림을 받을 수 있음 (AppDelegate)
        self.connection?.send(content: "{ \"app\":\"Safari\", \"location\" : \"\(location)\", \"file\" : \"\(fileURL.path)\" }".data(using: .utf8), completion: NWConnection.SendCompletion.contentProcessed({ error in }))

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]
        
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
    
}
