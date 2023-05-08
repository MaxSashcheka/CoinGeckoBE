//
//  Post.swift
//  
//
//  Created by Maksim Sashcheka on 14.04.23.
//

import Vapor
import Fluent

final class Post: Model, Content {
    static var schema: String = "posts"
    
    @ID
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "author_id")
    var authorId: UUID
    
    @Field(key: "imageURL")
    var imageURL: String
}


