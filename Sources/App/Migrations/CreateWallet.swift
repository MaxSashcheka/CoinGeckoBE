//
//  CreateWallet.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Vapor
import Fluent

struct CreateWallet: AsyncMigration {
    func prepare(on database: Database) async throws {
        let schema = database.schema("wallets")
            .id()
            .field("name", .string, .required)
            .field("user_id", .uuid, .required)
            .field("color_hex", .string, .required)
        
        try await schema.create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("wallets").delete()
    }
}
