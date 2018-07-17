import XCTest
import GGARest


class ObjectFactoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testListInfo1() {
        let className=String(reflecting: [MyChild].self);

        let listInfo=ObjectFactory<JSonBaseObject>.getListInfo(className: className);
        
        XCTAssert(listInfo.level == 1);
        let targetInnerType=String(reflecting: MyChild.self)
        let currentType=String(reflecting: listInfo.innerType);
        XCTAssert(targetInnerType == currentType)
    }
    
    func testListInfo2() {
        let className=String(reflecting: [[MyChild]].self);
        
        let listInfo=ObjectFactory<JSonBaseObject>.getListInfo(className: className);
        
        XCTAssert(listInfo.level == 2);
        let targetInnerType=String(reflecting: MyChild.self)
        let currentType=String(reflecting: listInfo.innerType);
        XCTAssert(targetInnerType == currentType)
    }
    
    func testListInfo3() {
        let className=String(reflecting: [[[MyChild]]].self);
        
        let listInfo=ObjectFactory<JSonBaseObject>.getListInfo(className: className);
        
        XCTAssert(listInfo.level == 3);
        let targetInnerType=String(reflecting: MyChild.self)
        let currentType=String(reflecting: listInfo.innerType);
        XCTAssert(targetInnerType == currentType)
    }
    
    func testListInfo4() {
        let className=String(reflecting: [[[[MyChild]]]].self);
        
        let listInfo=ObjectFactory<JSonBaseObject>.getListInfo(className: className);
        
        XCTAssert(listInfo.level == 4);
        let targetInnerType=String(reflecting: MyChild.self)
        let currentType=String(reflecting: listInfo.innerType);
        XCTAssert(targetInnerType == currentType)
    }
}
