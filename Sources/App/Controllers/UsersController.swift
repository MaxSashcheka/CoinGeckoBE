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
        
        let loginGroup = routes.grouped("login")
        loginGroup.post(use: loginHandler)
        
    }
    
    func createHandler(_ request: Request) async throws -> User.Public {
        let user = try request.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: request.db)
        return user.publicUser
    }
    
    func getAllHandler(_ request: Request) async throws -> [User.Public] {
        let users = try await User.query(on: request.db).all()
        return users.map { $0.publicUser }
    }
    
    func getHandler(_ request: Request) async throws -> User.Public {
        guard let user = try await User.find(request.parameters.get("id"), on: request.db) else {
            throw Abort(.notFound)
        }
        return user.publicUser
    }
}

extension UsersController {
    func loginHandler(_ request: Request) async throws -> User.Public {
        let creds = try request.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: request.db)
            .filter(\.$login == creds.login)
            .first() else {
            throw Abort(.notFound)
        }
        
        if try Bcrypt.verify(creds.password, created: user.password) {
            return user.publicUser
        }
        
        throw Abort(.notFound)
        
    }
}

final class LoginRequest: Content {
    var login: String
    var password: String
}
