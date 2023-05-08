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
        postsGroup.get(use: getHandler)
        postsGroup.delete(":postId", use: deleteHandler)
    }
    
    func createHandler(_ request: Request) async throws -> Post {
        let post = try request.content.decode(Post.self)
        try await post.save(on: request.db)
        return post
    }
    
    func deleteHandler(_ request: Request) async throws -> Post {
        guard let post = try await Post.find(request.parameters.get("postId"), on: request.db) else {
            throw Abort(.notFound)
        }
        try await post.delete(on: request.db)
        return post
    }
    
    func getHandler(_ request: Request) async throws -> [Post] {
        let queryContent = try request.query.decode(PostQueryContent.self)
        
        if let authorIdString = queryContent.authorId {
            if let authorId = UUID(uuidString: authorIdString) {
                return try await Post
                    .query(on: request.db)
                    .filter(\.$authorId == authorId)
                    .all()
            }
        }
        
        if let postIdString = queryContent.postId {
            if let postId = UUID(uuidString: postIdString) {
                return try await Post
                    .query(on: request.db)
                    .filter(\.$id == postId)
                    .all()
            }
        }
        
        return try await Post.query(on: request.db).all()
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

final class PostQueryContent: Content {
    var authorId: String?
    var postId: String?
}
