//
//  PostsController.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Fluent
import Vapor


struct PostsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let postsGroup = routes.grouped("posts")
        postsGroup.post(use: createHandler)
        postsGroup.get(use: getAllHandler)
        postsGroup.get(":userId", use: getByAuthorIdHandler)
        let moreGroyp = routes.grouped("posts/authorId")
        moreGroyp.get(":userId", use: getByIdHandler)
    }
    
    func createHandler(_ request: Request) async throws -> Post {
        let post = try request.content.decode(Post.self)
        try await post.save(on: request.db)
        return post
    }
    
    func getAllHandler(_ request: Request) async throws -> [Post] {
        try await Post.query(on: request.db).all()
    }
    
    func getByAuthorIdHandler(_ request: Request) async throws -> [Post] {
        guard let userIdString = request.parameters.get("userId"),
              let userId = UUID(uuidString: userIdString) else {
            return []
        }

        return try await Post
            .query(on: request.db)
            .filter(\.$authorId == userId)
            .all()
    }
    
    func getByIdHandler(_ request: Request) async throws -> Post {
        guard let post = try await Post.find(request.parameters.get("id"), on: request.db) else {
            throw Abort(.notFound)
        }
        return post
    }
}
