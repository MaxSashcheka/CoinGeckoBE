import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "coingecko_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "coingecko_password",
        database: Environment.get("DATABASE_NAME") ?? "coingecko_database"
    ), as: .psql)

    app.migrations.add(CreatePost())
    app.migrations.add(CreateCoin())
    app.migrations.add(CreateWallet())
    app.migrations.add(CreateUser())

    try app.autoMigrate().wait()

    try routes(app)
}
