//
//  Account.swift
//  Final
//
//  Created by Yuqing Yang on 3/29/23.
//

import Foundation
import SwiftUI


struct Account: Decodable {
    var id: Int
    var account: String
    var psw: String
    var cards_id: Int?
}
    
    
