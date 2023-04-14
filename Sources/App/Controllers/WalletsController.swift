//
//  WalletsController.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Fluent
import Vapor

struct WalletsController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let walletsGroup = routes.grouped("wallets")
        walletsGroup.post(use: createHandler)
        walletsGroup.get(":userId", use: getHandler)
    }
    
    func createHandler(_ request: Request) async throws -> Wallet {
        let wallet = try request.content.decode(Wallet.self)
        try await wallet.save(on: request.db)
        return wallet
    }

    func getHandler(_ request: Request) async throws -> [Wallet] {
        guard let userIdString = request.parameters.get("userId"), let userId = UUID(uuidString: userIdString) else {
            return []
        }
        return try await Wallet
            .query(on: request.db)
            .filter(\.$userId == userId)
            .all()
    }
}

