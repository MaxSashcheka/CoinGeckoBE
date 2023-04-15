//
//  CreatePost.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Vapor
import Fluent

struct CreatePost: AsyncMigration {
    func prepare(on database: Database) async throws {
        let schema = database.schema("posts")
            .id()
            .field("title", .string, .required)
            .field("content", .string, .required)
            .field("author_id", .uuid, .required)
            .field("imageURL", .string, .required)
        
        try await schema.create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("posts").delete()
    }
}
