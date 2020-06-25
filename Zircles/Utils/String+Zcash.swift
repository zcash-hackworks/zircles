//
//  String+Zcash.swift
//  wallet
//
//  Created by Francisco Gindre on 1/22/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import Foundation


extension String {
    
    var isValidShieldedAddress: Bool {
           ZirclesEnvironment.shared.initializer.isValidShieldedAddress(self)
       }
    
    var shortZaddress: String? {
        guard isValidShieldedAddress else { return nil }
        return String(self[self.startIndex ..< self.index(self.startIndex, offsetBy: 8)])
            + "..."
            + String(self[self.index(self.endIndex, offsetBy: -8) ..< self.endIndex])
    }
}
