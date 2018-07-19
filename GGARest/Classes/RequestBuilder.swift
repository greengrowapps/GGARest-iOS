//
//  RequestBuilder.swift
//  MyIosApp
//
//  Created by Adrian Sanchis Serrano on 11/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



public class ObjectStorer{
    private var object : Any ;
    init(object: Any) {
        self.object=object;
    }
    public func getObject<T>(type: T.Type) -> T{
        return self.object as! T;
    }
}

private class ListenerStorer{
    var simpleListener : ((FullRepsonse)->Void)? = nil;
    var objectListener : ((ObjectStorer,FullRepsonse)->Void)? = nil;
    var className : String = "";
    init(simpleListener: @escaping (FullRepsonse)->Void) {
        self.simpleListener=simpleListener;
    }
    init(objectListener: @escaping (ObjectStorer,FullRepsonse)->Void, className:String) {
        self.objectListener=objectListener;
        self.className=className;
    }
    
    public func isObjectListener() -> Bool{
        return self.objectListener != nil;
    }
    
    public func getSimpleListener() -> (FullRepsonse)->Void {
        return self.simpleListener!;
    }
    public func getObjectListener() -> (ObjectStorer,FullRepsonse)->Void{
        return self.objectListener!;
    }
    public func getClassName() -> String{
        return self.className;
    }
}

public class RequestBuilder {
    var method : ReqestMethod;
    var url : String;
    private var objectListeners = [Int : ListenerStorer]()
    private var headers :[(String,String)] = []
    
    init(url:String ,method: ReqestMethod) {
        self.url=url;
        self.method=method;
    }
    
    public enum ReqestMethod {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    public func onSuccess<T:JsoneableProtocol,J:RequestBuilder>(resultType:T.Type, objectListener: @escaping (ObjectStorer,FullRepsonse)->Void) -> J {
        return onResponse(code: 200, resultType:resultType, objectListener: objectListener);
    }
    public func onSuccess<J:RequestBuilder>(simpleListener: @escaping (FullRepsonse)->Void) -> J {
        return onResponse(code: 200, simpleListener: simpleListener);
    }
    public func onResponse<T:JsoneableProtocol,J:RequestBuilder>(code : Int, resultType:T.Type, objectListener: @escaping (ObjectStorer,FullRepsonse)->Void) -> J {
       // let result = GGAJson.fromJson(type:resultType, jsonString: "{}")

        let className=String(reflecting: resultType);
        self.objectListeners[200]=ListenerStorer(objectListener: objectListener, className: className);
        return self as! J;
    }
    public func onResponse<J:RequestBuilder>(code : Int, simpleListener: @escaping (FullRepsonse)->Void) -> J {
        self.objectListeners[code] = ListenerStorer(simpleListener: simpleListener);
        return self as! J;
    }
   /* public func onOther<T:JsoneableProtocol,J:RequestBuilder>(resultType:T.Type, objectListener: @escaping (ObjectStorer,FullRepsonse)->Void) -> J {
        return self.onResponse(code: -1, resultType: resultType, objectListener: objectListener);
       // return self as! J;
    }*/
    public func onOther<J:RequestBuilder>(simpleListener: @escaping (FullRepsonse)->Void) -> J {
        return self.onResponse(code: -1, simpleListener: simpleListener);
        //return self as! J;
    }
    public func with<J:RequestBuilder>(headers:(String,String)...) -> J{
        self.headers=headers;
        return self as! J;
    }
    
    public func execute(){
        if let response=GGARest.getMockedContentFor(url: self.url){
            publishResponse(code: response.code, content: response.content)
        }else{
            self.executeRealRequest();
        }
    }
    
    private func executeRealRequest(){
        guard let url = URL(string: self.url ) else {
            publishError(msg:"Bad url \(self.url)");
            return
        }

        
        var request = URLRequest(url: url)
        
        switch self.method {
        case .GET:
            request.httpMethod = HTTPMethod.get.rawValue
        case .POST:
            request.httpMethod = HTTPMethod.post.rawValue
        default:
            publishError(msg:"Invalid method: \(self.method)");
            return;
        }
        
        for header in self.headers{
            request.setValue(header.1, forHTTPHeaderField: header.0);
        }
        
        if(self is PostRequestBuilder){
            let post : PostRequestBuilder = self as! PostRequestBuilder;
            if(post.contentJson != nil){
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let json=post.contentJson!.toJson()
                let pjson = json.rawString(String.Encoding.utf8, options: .prettyPrinted)
                request.httpBody = (pjson?.data(using: .utf8))! as Data
            }else if(post.plainText != nil){
                request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = (post.plainText!.data(using: .utf8))! as Data
            }
        }
    
 
        
  
        
        Alamofire.request(request)
            .response { response in
                
                if(response.error != nil){
                    self.publishError(msg: response.error.debugDescription);
                    return;
                }
                
                let status_code=response.response!.statusCode
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    //print("Data: \(utf8Text)")
                    self.publishResponse(code: status_code, content: utf8Text)
                }else{
                    self.publishError(msg: "response data not convertible to utf8 string")
                }
        }
        
        print("execute");
    }
    
    private func publishError(msg:String){
        if let listener=objectListeners[-1] {
            listener.getSimpleListener()(FullRepsonse(code: -1, content: msg))
        }
    }
    
    private func publishResponse(code : Int , content: String) -> Void{
        if let listener=objectListeners[code]{
            if(listener.isObjectListener()){
                let result = GGAJson.fromJson(className:listener.getClassName(), jsonString: content)
                listener.getObjectListener()(ObjectStorer(object:result),FullRepsonse(code: code, content: content))
            }else{
                listener.getSimpleListener()(FullRepsonse(code: code, content: content))
            }
        }else if let listener=objectListeners[-1] {
            listener.getSimpleListener()(FullRepsonse(code: code, content: content))
        }
    }

}

public class GetRequestBuilder : RequestBuilder{
    init(url: String) {
        super.init(url: url, method: .GET);
    }
}
public class PostRequestBuilder : RequestBuilder{
    var contentJson : JsoneableProtocol?
    var plainText : String?
    init(url: String) {
        super.init(url: url, method: .POST);
    }
    public func withJson(object:JsoneableProtocol) -> RequestBuilder{
        self.contentJson=object;
        return self;
    }
    public func withPlainText(text:String) -> RequestBuilder{
        self.plainText=text;
        return self;
    }
}
