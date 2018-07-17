//
//  ObjectFactory.swift
//  SwiftFactory
//
//  Created by Joshua Smith on 6/4/14.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

/*
This class requires:
#import "OBJCObjectFactory.h"
in your project's bridging header file.
*/

import Foundation
import SwiftyJSON

public class ListInfo<T:NSObject> {
    public var level : Int;
    public var innerType : T.Type;
    var instance : T;
    init(level:Int,Type:T.Type,instance: T) {
        self.level=level;
        self.innerType=Type;
        self.instance=instance;
    }
    
    func level1Type() -> [T].Type {
        
        return type(of:[instance]);
    }
}

/** Instantiates NSObject subclasses by name. */
public class ObjectFactory<TBase: NSObject>
{
    class func isList(className: String) -> Bool{
        return className.contains("Array");
    }
    /**
    Returns a new instance of the specified class,
    which should be `TBase` or a subclass thereof.
    Uses the parameterless initializer.
    */
    class func createInstance(className: String!) -> TBase?
    {
        return OBJCObjectFactory.create(className) as! TBase?
    }
    
    /**
    Returns a new instance of the specified class,
    which should be `TBase` or a subclass thereof.
    Uses the specified single-parameter initializer.
    */
    class func createInstance(
        className:  String!,
        initializer: Selector!,
        argument:    AnyObject) -> TBase?
    {
        return OBJCObjectFactory.create(
                         className,
            initializer: initializer,
            argument:    argument) as! TBase?
    }
   
    
    class func getType(className: String) -> TBase.Type{
        let tempInstance=createInstance(className: className);
        let instanceType=type(of:tempInstance!);
        return instanceType;        
    }

    
   public class func getListInfo(className: String) -> ListInfo<TBase>{
        
        var level=0;
        var innerCLass=className;
        
        while isList(className: innerCLass) {
            innerCLass=extractFirstArrayFromType(className: innerCLass);
            level+=1;
        }        
        let instance = createInstance(className: innerCLass);
        let instanceType=type(of: instance!)

        return ListInfo<TBase>(level: level, Type: instanceType, instance:instance!);
    }
    
    private static func extractFirstArrayFromType(className: String)->String{
        let s = className
        let pattern = "Swift.Array<(.*)>"
        // our goal is capture group 3, "h" in "ha"
        let regex = try! NSRegularExpression(pattern: pattern)
        let result = regex.matches(in:s, range:NSMakeRange(0, s.utf16.count))
        let firstMatch = result[0].range(at: 1) // <-- !!
        let myNSString = s as NSString
        let name=myNSString.substring(with: NSRange(location: firstMatch.location, length: firstMatch.length))
        return name;
    }
}
