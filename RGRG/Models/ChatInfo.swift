//
//  ChatInfo.swift
//  RGRG
//
//  Created by (^ㅗ^)7 iMac on 2023/10/11.
//

import Foundation
import FirebaseFirestore

struct ChatInfo {
    var sender: String
    var date: String
    var read: Bool
    var content: String
}
