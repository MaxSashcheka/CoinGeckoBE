//
//  CreateUser.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Vapor
import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        let schema = database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("login", .string, .required)
            .field("password", .string, .required)
            .field("role", .string, .required)
            .field("personal_web_page_url", .string, .required)
            .field("email", .string, .required)
            .field("image_url", .string)
            .unique(on: "login")
        
        try await schema.create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}
