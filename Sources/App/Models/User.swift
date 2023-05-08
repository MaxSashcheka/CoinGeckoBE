//
//  User.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Vapor
import Fluent

final class User: Model, Content {
    static var schema: String = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "login")
    var login: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "role")
    var role: String
    
    @Field(key: "email")
    var email: String
    
    @OptionalField(key: "personal_web_page_url")
    var personalWebPageURL: String?
    
    @OptionalField(key: "image_url")
    var imageURL: String?
    
    init(id: UUID? = nil, name: String, login: String, password: String, role: String, email: String, personalWebPageURL: String, imageURL: String?) {
        self.id = id
        self.name = name
        self.login = login
        self.password = password
        self.role = role
        self.email = email
        self.personalWebPageURL = personalWebPageURL
        self.imageURL = imageURL
    }
    
    init() { }
}

extension User {
    final class Public: Content {
        var id: UUID?
        var name: String
        var login: String
        var role: String
        var email: String
        var personalWebPageURL: String?
        var imageURL: String?
        
        init(id: UUID? = nil,
             name: String,
             login: String,
             role: String,
             email: String,
             personalWebPageURL: String? = nil,
             imageURL: String? = nil) {
            self.id = id
            self.name = name
            self.login = login
            self.role = role
            self.email = email
            self.personalWebPageURL = personalWebPageURL
            self.imageURL = imageURL
        }
    }
    
    var publicUser: Public {
        Public(
            id: id,
            name: name,
            login: login,
            role: role,
            email: email,
            personalWebPageURL: personalWebPageURL,
            imageURL: imageURL
        )
    }
}
