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
        walletsGroup.get(use: getAllHandler)
        walletsGroup.get(":userId", use: getHandler)
        walletsGroup.delete(":walletId", use: deleteHandler)
    }
    
    func createHandler(_ request: Request) async throws -> Wallet.DetailedInfo {
        let wallet = try request.content.decode(Wallet.self)
        try await wallet.save(on: request.db)
        
        let coins = try await Coin.query(on: request.db).all()
        
        return Wallet.DetailedInfo(
            id: wallet.id,
            name: wallet.name,
            colorHex: wallet.colorHex,
            userId: wallet.userId,
            coinsCount: coins.filter { $0.walletId == wallet.id }.count
        )
    }
    
    func getAllHandler(_ request: Request) async throws -> [Wallet] {
        try await Wallet.query(on: request.db).all()
    }

    func getHandler(_ request: Request) async throws -> [Wallet.DetailedInfo] {
        guard let userIdString = request.parameters.get("userId"),
              let userId = UUID(uuidString: userIdString) else {
            return []
        }
        
        let wallets = try await Wallet
            .query(on: request.db)
            .filter(\.$userId == userId)
            .all()
        
        let coins = try await Coin.query(on: request.db).all()
        
        return wallets.map { wallet in
            Wallet.DetailedInfo(
                id: wallet.id,
                name: wallet.name,
                colorHex: wallet.colorHex,
                userId: wallet.userId,
                coinsCount: coins.filter { $0.walletId == wallet.id }.count
            )
        }
    }
    
    func deleteHandler(_ request: Request) async throws -> Wallet.DetailedInfo {
        guard let wallet = try await Wallet.find(request.parameters.get("walletId"), on: request.db) else {
            throw Abort(.notFound)
        }
        try await wallet.delete(on: request.db)
        return Wallet.DetailedInfo(
            id: wallet.id,
            name: wallet.name,
            colorHex: wallet.colorHex,
            userId: wallet.userId,
            coinsCount: .zero
        )
    }
}

extension Wallet {
    final class DetailedInfo: Content {
        var id: UUID?
        var name: String
        var colorHex: String
        var userId: UUID
        var coinsCount: Int
        
        init(id: UUID? = nil,
             name: String,
             colorHex: String,
             userId: UUID,
             coinsCount: Int) {
            self.id = id
            self.name = name
            self.colorHex = colorHex
            self.userId = userId
            self.coinsCount = coinsCount
        }
    }
}

