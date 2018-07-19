//
//  JSonBaseObject.swift
//  MyIosAppTests
//
//  Created by Adrian Sanchis Serrano on 10/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol OptionalProtocol {
     func isNull() -> Bool
}
public protocol JsoneableProtocol {
    func toJson()->JSON
}

extension Optional : OptionalProtocol {
    func isNull() -> Bool {
        guard self == nil else {
            return false;
        }
        return true;
    }
}
//extension NSObject : JsoneableProtocol {}
extension Array : JsoneableProtocol {
    public func toJson() -> JSON {
        var ret : [JSON] = []
       // var ret = JSON();

        for item in self {
            let jitem  = item as? JsoneableProtocol;
            if(jitem != nil){
                ret.append(jitem!.toJson())
            }
        }
      
        return JSON(ret);
    }
}

extension Int : JsoneableProtocol{
    public func toJson() -> JSON {
        return JSON(self);
    }
}

extension String : JsoneableProtocol{
    public func toJson() -> JSON {
        return JSON(self);
    }
}

extension NSNumber : JsoneableProtocol{
    public func toJson() -> JSON {
        return JSON(self);
    }
    
    
}

extension Optional : JsoneableProtocol{
    public func toJson() -> JSON {
        if(self != nil){
            if( self! is JsoneableProtocol){
                let jsoneable = self! as! JsoneableProtocol;
                return jsoneable.toJson();
            }
        }
        return JSON.null;
    }
}


extension  Array where Element:JsoneableProtocol{
    mutating func fillFromJson(json: [JSON], className: String) {
        self.removeAll();
        //var itemX : JsoneableProtocol;
        //self.append(itemX as! Element);
        for jsonObject in json{
            let instance = ObjectFactory<JSonBaseObject>.createInstance(className: className)!;
            instance.fillFromJson(json: jsonObject);
            let item=instance  as! Element;
            self.append(item);
        }
        
    }
}

open class JSonBaseObject: NSObject,JsoneableProtocol {
    
    public func toJson() -> JSON {
        var ret = JSON()
        let aMirror = Mirror(reflecting: self)
        
        for case let (label?, value) in aMirror.children {
            if(value is JsoneableProtocol){
                ret[label] = (value as! JsoneableProtocol).toJson();
            }
        }
        
        return ret
    }

    public func fillFromJson(json: JSON) {
        let aMirror = Mirror(reflecting: self)

        for case let (label?, value) in aMirror.children {
            if((value is String) && json[label].string != nil){
                self.setValue(json[label].stringValue, forKey: label);
                continue;
            }
            
            if((value is Int) && json[label].int != nil){
                self.setValue(json[label].intValue, forKey: label);
                continue;
            }
            
            //let casted = value as? Optional<JSonBaseObject>
            
            if(value is JsoneableProtocol){
                let object=GGAJson.fromJson(className: String(reflecting:type(of:value)), jsonObject: json[label]);
                if(object is OptionalProtocol){
                    let o = object as! OptionalProtocol;
                    if !o.isNull() {
                        self.setValue(object, forKey: label)
                    }else{
                        self.setValue(nil, forKey: label)
                    }

                }else{
                    self.setValue(object, forKey: label)
                }
                continue;
            }
        
            if(value is [JsoneableProtocol]){
                let array=GGAJson.fromJson(className: String(reflecting:type(of:value)), jsonObject: json[label]);
                self.setValue(array, forKey: label)
            }

            if(value is OptionalProtocol){
                // TODO manege optional like array
                let mType = type(of: value)
                var className = String(reflecting:mType);
                className = className.replacingOccurrences(of: "Swift.Optional<", with: "");
                className = className.replacingOccurrences(of: ">", with: "");
                
                let testIntance = ObjectFactory<NSObject>.createInstance(className: className);
                if(testIntance is JSonBaseObject){
                    if json[label] == JSON.null{
                        self.setValue(nil, forKey: label);
                    }else{
                        let instance = ObjectFactory<JSonBaseObject>.createInstance(className: className);
                        instance!.fillFromJson(json: json[label]);
                        self.setValue(instance, forKey: label);
                    }
                }
            }
            
            if(value is JSonBaseObject ){
                
                let mType = type(of: value)                
                let className = String(reflecting:mType);
                let instance = ObjectFactory<JSonBaseObject>.createInstance(className: className);
                instance!.fillFromJson(json: json[label]);
                self.setValue(instance, forKey: label);
            }
            
            if(value is [String:String]){
            
                var newvalue = [String:String]();
                
                for (key, subJson) in json[label]{
                    newvalue[key] = subJson.stringValue;
                }
                
                
                self.setValue(newvalue, forKey: label)
            }
            
            print("name: \(label) type: \(type(of: value)) value: \(value)")
        }
        
    }
}
