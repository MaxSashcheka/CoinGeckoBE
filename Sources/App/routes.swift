import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UsersController())
    try app.register(collection: WalletsController())
    try app.register(collection: CoinsController())
}
