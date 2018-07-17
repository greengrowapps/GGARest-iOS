//
//  GGARest.swift
//  MyIosApp
//
//  Created by Adrian Sanchis Serrano on 11/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit

public class MockedResponse{
    public var content : String;
    public var code : Int;
    
    init(content: String, code: Int) {
        self.content=content;
        self.code=code;
    }
}

public class GGARest {
    private static var  mockedResponses = [String : MockedResponse]();
    
    public static func mockedContent(url: String, code: Int, response:String ){
        mockedResponses[url] = MockedResponse(content: response, code: code);
    }
    public static func getMockedContentFor(url:String) -> MockedResponse?{
        return mockedResponses[url];
    }
    
    
    public static func ws() -> GGARest{
        return GGARest();
    }
    
    public func get(url: String) -> GetRequestBuilder {
        return GetRequestBuilder(url:url)
    }
    public func post(url: String) -> PostRequestBuilder{
        return PostRequestBuilder(url:url)
    }
}
