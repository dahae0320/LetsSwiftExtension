//
//  AppDelegate.swift
//  DefaultMacApp
//
//  Created by Da Hae Lee on 2022/11/24.
//

import Cocoa
// 네트워크 모듈
import Network
// 사용자 알림 모듈
import UserNotifications

// ?
struct Command: Decodable {
    let app: String
    let location: String?
    let file: String?
    let code: String?
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var listener: NWListener?
    /// Native 앱(DefaultMacApp) 네트워크 작업을 담을 큐
    let networkQueue = DispatchQueue.init(label: "com.dadahae.DefaultMacApp")


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NotificationManager.registNotification()
        configureNetwork()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    /// Network 환경설정
    func configureNetwork() {
        /// UDP 통신 준비
        let parameters = NWParameters.udp
        parameters.acceptLocalOnly = true
        parameters.allowLocalEndpointReuse = true
        /// UDP를 통해 요청을 계속 들을 수 있도록 listener 초기화
        self.listener = try? NWListener.init(using: parameters, on: .init(integerLiteral: 12022))
        listener?.stateUpdateHandler = {(newState) in
            switch newState {
            case .ready:
                print("listen ready")
            default:
                break
            }
        }
        /// listener에 네트워크 통신 핸들러 구축
        listener?.newConnectionHandler = {(newConnection) in
            /// 네트워크 통신 핸들러 구축
            newConnection.stateUpdateHandler = {newState in
                switch newState {
                case .ready:
                    newConnection.receive(minimumIncompleteLength: 10, maximumLength: 1024) { data, context, isContinue, error in
                        guard let receive = try? JSONDecoder().decode(Command.self, from: data!) else { return }
                        /// 어떤 앱에서 보낸 알람인지 구분하여 노티 보냄
                        switch receive.app {
                        case "Safari":
                            DispatchQueue.main.async {
                                NotificationManager.sendNotification(with: "👻 Safari Chat Noti")
                            }
                        case "SafariApp":
                            DispatchQueue.main.async {
                                NotificationManager.sendNotification(with: "🤡 Safari-App Chat Noti")
                            }
                        case "Xcode":
                            DispatchQueue.main.async {
                                NotificationManager.sendNotification(with: "🤖 Xcode Chat Noti")
                            }
                        default:
                            break
                        }
                    }
                default:
                    break
                }
            }
            /// 네트워크 통신 시작
            newConnection.start(queue: self.networkQueue)
        }
        /// listener 시작
        listener?.start(queue: networkQueue)
    }

}

enum NotificationManager {
    /// notification을 보냅니다.
    static func sendNotification(with ment: String) {
        let uuidString = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Default Mac App"
        content.body = "\(ment)"
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil { }
        }
    }
    
    /// Notification을 등록합니다.
    static func registNotification() {
        let center = UNUserNotificationCenter.current()
        /// 알림 + 사운드 + 배지를 옵션으로 가지는 노티를 등록합니다.
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print(error)
            }
            print("user notification", granted)
        }
    }
}
