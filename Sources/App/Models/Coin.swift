//
//  Coin.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Vapor
import Fluent

final class Coin: Model, Content {
    static var schema: String = "coins"
    
    @ID
    var id: UUID?
    
    @Field(key: "wallet_id")
    var walletId: UUID
    
    @Field(key: "identifier")
    var identifier: String
    
    @Field(key: "amount")
    var amount: Float
}
