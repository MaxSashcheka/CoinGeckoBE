//
//  CreateCoin.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Vapor
import Fluent

struct CreateCoin: AsyncMigration {
    func prepare(on database: Database) async throws {
        let schema = database.schema("coins")
            .id()
            .field("wallet_id", .uuid, .required)
            .field("identifier", .string, .required)
        
        try await schema.create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("coins").delete()
    }
}
