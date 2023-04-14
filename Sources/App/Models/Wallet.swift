//
//  Wallet.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Vapor
import Fluent

final class Wallet: Model, Content {
    static var schema: String = "wallets"
    
    @ID
    var id: UUID?
    
    @Field(key: "user_id")
    var userId: UUID
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "color_hex")
    var colorHex: String
}
