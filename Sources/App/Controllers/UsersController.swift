//
//  UsersController.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Fluent
import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.post(use: createHandler)
        usersGroup.get(use: getAllHandler)
        usersGroup.get(":id", use: getHandler)
    }
    
    func createHandler(_ request: Request) async throws -> User {
        let user = try request.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: request.db)
        return user
    }
    
    func getAllHandler(_ request: Request) async throws -> [User] {
        let users = try await User.query(on: request.db).all()
        return users
    }
    
    func getHandler(_ request: Request) async throws -> User {
        guard let user = try await User.find(request.parameters.get("id"), on: request.db) else {
            throw Abort(.notFound)
        }
        return user
    }
}
