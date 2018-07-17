//
//  GGarestTests.swift
//  MyIosAppTests
//
//  Created by Adrian Sanchis Serrano on 11/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import XCTest
import GGARest
class GGarestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        GGARest.mockedContent(url: "http://mytest.com", code: 200, response: "{ \"name\":\"name123\",\"id\":123,\"child\":{\"id\":13},\"childList\":[{\"id\":15},{\"id\":16}]}");
        
        GGARest.ws()
            .get(url:"http://mytest.com")
            .onSuccess(resultType:MyClass.self, objectListener: {( responseObject : ObjectStorer, response : FullRepsonse) -> Void in
                let c = responseObject.getObject(type: MyClass.self);
                XCTAssert(c.id == 123);
                print(c)
                })
            .onOther(simpleListener: {(response: FullRepsonse) -> Void in
                XCTFail()
            })
            .execute();
    }
    
    func testExampleList() {
        GGARest.mockedContent(url: "http://mytest.com", code: 200, response: "[{\"id\":15},{\"id\":16}]");
        
        GGARest.ws()
            .get(url:"http://mytest.com")
            .onSuccess(resultType:[MyChild].self, objectListener: {( responseObject : ObjectStorer, response : FullRepsonse) -> Void in
                let c = responseObject.getObject(type: [MyChild].self);
                XCTAssert(c.count == 2);
                XCTAssert(c[0].id == 15);
                XCTAssert(c[1].id == 16);                
                print(c)
            })
            .onOther(simpleListener: {(response: FullRepsonse) -> Void in
                XCTFail()
            })
            .execute();
    }
    
    func testExampleMultiList() {
        GGARest.mockedContent(url: "http://mytest.com", code: 200, response: "[[{\"id\":15},{\"id\":16}],[{\"id\":15},{\"id\":16}]]");
        
        GGARest.ws()
            .get(url:"http://mytest.com")
            .onSuccess(resultType:[[MyChild]].self, objectListener: {( responseObject : ObjectStorer, response : FullRepsonse) -> Void in
                let c = responseObject.getObject(type: [[MyChild]].self);
                XCTAssert(c.count == 2);
                for var inner in c{
                    XCTAssert(inner[0].id == 15);
                    XCTAssert(inner[1].id == 16);
                }
            })
            .onOther(simpleListener: {(response: FullRepsonse) -> Void in
                XCTFail()
            })
            .execute();
    }
    
    func testGetHttpBin(){
        let expectation = XCTestExpectation(description: "Finish request")

        let url="https://httpbin.org/get";
        GGARest.ws()
            .get(url:url)
            .onSuccess(simpleListener: {(response: FullRepsonse) -> Void in
                
                expectation.fulfill();
                print(response)
            })
            .onOther(simpleListener: {(response: FullRepsonse) -> Void in
                expectation.fulfill();
                XCTFail()
            })
            .execute();
        
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testPostHttpBin(){
        let expectation = XCTestExpectation(description: "Finish request")
        
        let url="https://httpbin.org/anything";
        GGARest.ws()
            .post(url: url)
            .withJson(object: MyClass())
            .onSuccess(resultType: MyClass.self, objectListener: {(object: ObjectStorer ,response:FullRepsonse) -> Void in
                
                expectation.fulfill();
                print(response)
            })
            .onSuccess(simpleListener: {(response: FullRepsonse) -> Void in
                
                expectation.fulfill();
                print(response)
            })
            .onOther(simpleListener: {(response: FullRepsonse) -> Void in
                expectation.fulfill();
                XCTFail()
            })
            .execute();
        
        wait(for: [expectation], timeout: 30.0)
    }
    
  
    
  
    
}
