//
//  Politician.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/21/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import Foundation

class Politician {
    var firstName: String
    var fullName: String
    var lastName: String
    var party: String
    var partyLetter: String
    var position: String
    var state: String
    var voteSmartID: String
    
    init(firstName:String, fullName:String, lastName:String, party:String, partyLetter:String, position:String, state:String, voteSmartID:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.party = party
        self.partyLetter = partyLetter
        self.position = position
        self.state = state
        self.voteSmartID = voteSmartID
    }
}