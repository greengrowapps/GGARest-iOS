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
            .onSuccess(resultType: HttpBinResponse.self, objectListener: {(objectStorer:ObjectStorer,fullResponse:FullRepsonse) -> Void in
                let object = objectStorer.getObject(type: HttpBinResponse.self);
                XCTAssertNotNil(object)
                XCTAssertNotNil(object.origin)
                XCTAssertNotNil(object.url)
                XCTAssertEqual(url, object.url)
                XCTAssertEqual(object.headers["Host"], "httpbin.org")
                expectation.fulfill();
            })
            .onOther(simpleListener: {(response: FullRepsonse) -> Void in
                expectation.fulfill();
                XCTFail()
            })
            .execute();
        
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testSendHeaders(){
        let expectation = XCTestExpectation(description: "Finish request")
        
        let url="https://httpbin.org/get";
        GGARest.ws()
            .get(url:url)
            .with(headers:
                ("X-Test-Header1","header1Value"),
                ("X-Test-Header2","header2Value"),
                ("X-Test-Header3","header3Value")
            )
            .onSuccess(resultType: HttpBinResponse.self, objectListener: {(objectStorer:ObjectStorer,fullResponse:FullRepsonse) -> Void in
                let object = objectStorer.getObject(type: HttpBinResponse.self);
                XCTAssertNotNil(object)
                XCTAssertNotNil(object.origin)
                XCTAssertNotNil(object.url)
                XCTAssertEqual(url, object.url)
                XCTAssertEqual(object.headers["Host"], "httpbin.org")
                XCTAssertEqual(object.headers["X-Test-Header1"], "header1Value")
                XCTAssertEqual(object.headers["X-Test-Header2"], "header2Value")
                XCTAssertEqual(object.headers["X-Test-Header3"], "header3Value")


                expectation.fulfill();
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
        let toSend = MyClass()
        toSend.name="name 1234"
        toSend.id = 1234
        toSend.child.id=12345
        toSend.child2 = MyChild()
        toSend.child2?.id = 123456
        toSend.childList.append(MyChild());
        toSend.childList.append(MyChild());
        toSend.childList[0].id=1
        toSend.childList[1].id=2
    
        
        let url="https://httpbin.org/anything";
        GGARest.ws()
            .post(url: url)
            .withJson(object:toSend)
            .onSuccess(resultType: EchoResponse_MyClass.self, objectListener: {(objectStorer: ObjectStorer ,response:FullRepsonse) -> Void in
                
                let object = objectStorer.getObject(type: EchoResponse_MyClass.self)
                XCTAssertNotNil(object)
                XCTAssertNotNil(object.json)
                self.assertAreEqual(obj: toSend, obj2: object.json!)
                
             //   XCTAssertEqual(object.headers["Host"], "httpbin.org")
             //   XCTAssertEqual(object.headers["Content-Type"], "application/json")

                expectation.fulfill();
            })
            .onOther(simpleListener: {(response: FullRepsonse) -> Void in
                expectation.fulfill();
                XCTFail()
            })
            .execute();
        
        wait(for: [expectation], timeout: 30.0)
    }
    
    func assertAreEqual(obj:MyClass , obj2:MyClass) {
        XCTAssertEqual(obj.id, obj2.id);
        XCTAssertEqual(obj.name, obj2.name)
        XCTAssertEqual(obj.child.id, obj2.child.id)
        if(obj.child2 == nil){
            XCTAssertTrue(obj2.child2 == nil)
        }else{
            XCTAssertTrue(obj2.child2 != nil)
            XCTAssertEqual(obj.child2!.id, obj2.child2!.id)
        }
        XCTAssertEqual(obj.childList.count, obj2.childList.count);
       
        for i in 0...obj.childList.count-1{
            XCTAssertEqual(obj.childList[i].id, obj2.childList[i].id)
        }
    }
}
