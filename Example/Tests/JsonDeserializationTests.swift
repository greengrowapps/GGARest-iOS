//
//  MyIosAppTests.swift
//  MyIosAppTests
//
//  Created by Pablo Apellidos on 8/6/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import XCTest
import SwiftyJSON
import GGARest
class JsonDeserializationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testSerialization() {
        let jsonString = "{ \"name\":\"name123\",\"id\":123,\"child\":{\"id\":13},\"child2\":{\"id\":14},\"childList\":[{\"id\":15},{\"id\":16}]}"

        let object=GGAJson.fromJson(type: MyClass.self, jsonString: jsonString);
        assert(object.name == "name123");
        assert(object.id == 123);
        assert(object.child.id == 13)
        assert(object.child2 != nil);
        assert(object.child2!.id == 14);
        assert(object.childList.count == 2);
        var count : Int = 15;
        for var item in object.childList{
            assert(item.id == count);
            count+=1;
        }
        print(object);
    }
    
    func testSerializationNullObject() {
        let jsonString = "{ \"name\":\"name123\",\"id\":123,\"child\":{\"id\":13},\"childList\":[{\"id\":15},{\"id\":16}]}"
        
       // let object=GGAJson.fromJson(type: MyClass.self, jsonString: jsonString);
        let object=GGAJson.fromJson(type: MyClass.self, jsonString: jsonString);
        assert(object.name == "name123");
        assert(object.id == 123);
        assert(object.child.id == 13)
        XCTAssertTrue(object.child2 == nil);
        assert(object.childList.count == 2);
        var count : Int = 15;
        for var item in object.childList{
            assert(item.id == count);
            count+=1;
        }
        print(object);
    }
    
    func testSerializationArray() {
        let jsonString = "[{\"id\":15},{\"id\":16},{\"id\":17},{\"id\":18},{\"id\":19},{\"id\":20}]"
        
        let object=GGAJson.fromJson(type: Array<MyChild>.self, jsonString: jsonString);
        assert(object.count == 6);
        var count : Int = 15;
        for var item in object{
            assert(item.id == count);
            count+=1;
        }
       // let object=GGAJson.fromJson(type: Array<NSString>.self, jsonString: jsonString);

        print(object);
    }
    
    func testSerializationArrayMulti() {
        let jsonString = "[[{\"id\":15},{\"id\":16},{\"id\":17},{\"id\":18},{\"id\":19},{\"id\":20}],[{\"id\":15},{\"id\":16},{\"id\":17},{\"id\":18},{\"id\":19},{\"id\":20}]]"
        
        let object=GGAJson.fromJson(type: Array<Array<MyChild>>.self, jsonString: jsonString);
        assert(object.count == 2);

        for var object2 in object{
            assert(object2.count == 6);
            var count : Int = 15;
            for var item in object2{
                assert(item.id == count);
                count+=1;
            }
        }
        
        print(object);
    }
    
    func testSerializeJsonString(){
        let jsonString = "\"hola\""
        
        let object=GGAJson.fromJson(type: String.self, jsonString: jsonString);

        XCTAssertEqual(object, "hola");
    }

 

}
