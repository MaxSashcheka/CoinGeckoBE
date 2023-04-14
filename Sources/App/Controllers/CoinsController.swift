//
//  CoinsController.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Fluent
import Vapor

struct CoinsController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let coinsGroup = routes.grouped("coins")
        coinsGroup.post(use: createHandler)
        coinsGroup.get(use: getAllHandler)
        coinsGroup.get(":walletId", use: getHandler)
    }
    
    func createHandler(_ request: Request) async throws -> Coin {
        let coin = try request.content.decode(Coin.self)
        try await coin.save(on: request.db)
        return coin
    }
    
    func getAllHandler(_ request: Request) async throws -> [Coin] {
        try await Coin.query(on: request.db).all()
    }

    func getHandler(_ request: Request) async throws -> [Coin] {
        guard let walletIdString = request.parameters.get("walletId"),
              let walletId = UUID(uuidString: walletIdString) else {
            return []
        }
        return try await Coin
            .query(on: request.db)
            .filter(\.$walletId == walletId)
            .all()
    }
}


