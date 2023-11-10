//
//  Channel.swift
//  RGRG
//
//  Created by (^ㅗ^)7 iMac on 10/22/23.
//

import FirebaseFirestore
import Foundation

struct Channel: Hashable {
    var channelName: String
    var guest: String
    var host: String
    var channelID: String
    var currentMessage: String?
    var hostProfile: String
    var guestProfile: String
    var hostSender: Bool
    var guestSender: Bool
}
