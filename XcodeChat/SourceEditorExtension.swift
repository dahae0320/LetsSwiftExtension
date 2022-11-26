//
//  SourceEditorExtension.swift
//  XcodeChat
//
//  Created by Da Hae Lee on 2022/11/25.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    
    /// Xcode Extension으로 사용할 command들을 배열로 리턴해주기
    /// 이때 command들은 Editor 탭에서 확인할 수 있다.
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        /// ChatCommand 등록
        let namespace = Bundle(for: type(of: self)).bundleIdentifier!
        let snapshotMarker = SnapshotCommand.className()
        let chatMarker = ChatCommand.className()
        return [[.identifierKey: namespace + chatMarker,
                 .classNameKey: chatMarker,
                 .nameKey: NSLocalizedString("Chat", comment: "Send the code to chat")],
                [.identifierKey: namespace + snapshotMarker,
                 .classNameKey: snapshotMarker,
                 .nameKey: NSLocalizedString("Snapshot", comment: "Snap code")]]
    }
    
}
