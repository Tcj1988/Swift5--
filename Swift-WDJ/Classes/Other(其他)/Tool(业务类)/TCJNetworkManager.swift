//
//  TCJNetworkManager.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import AFNetworking

public enum HttpMethodType:String{
    case Get = "Get"
    case Post = "Post"
}

class TCJNetworkManager: AFHTTPSessionManager {
    
    // MARK:- 创建请求单例
    private static let sharedManager:TCJNetworkManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.requestCachePolicy = .useProtocolCachePolicy
        let manager = TCJNetworkManager(baseURL: URL(string: kBaseURLString), sessionConfiguration: config)
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html","application/json","text/json","text/javascript")
        return manager
    }()
    
    // MARK:- 请求方法
    
    /// 网络请求方法
    ///
    /// - Parameters:
    ///   - type: 方法类型Get or Post
    ///   - URLString: 请求地址
    ///   - parameters: 请求参数
    ///   - completion: 完成回调
    open class func request(type:HttpMethodType, URLString:String, parameters:[String:Any]?, completion:@escaping (Any?, Error?) ->Void) -> Void
    {
        let successCompletion = {(dateTask:URLSessionDataTask?, responseObject:Any?) ->Void in completion(responseObject, nil)}
        
        let failureCompletion = {(dataTask:URLSessionDataTask?, error:Error?) -> Void in completion(nil, error)}
        
        if type == HttpMethodType.Get {
            sharedManager.get(URLString, parameters: parameters, progress: nil, success: successCompletion, failure: failureCompletion)
        }else if type == HttpMethodType.Post {
            sharedManager.post(URLString, parameters: parameters, progress: nil, success: successCompletion, failure: failureCompletion)
        }
    }
    
    
    /// 上传文件
    ///
    /// - Parameters:
    ///   - URLString: 接口地址
    ///   - parameters: 参数
    ///   - fileData: 文件二进制数据
    ///   - fileName: 文件字段
    ///   - completion: 完成回调
    open class func uploadFile(URLString:String, parameters:[String:Any]?, fileData:Data, fileName:String, completion:@escaping (Any?, Error?) ->Void) -> Void {
        let successCompletion = {(dateTask:URLSessionDataTask?, responseObject:Any?) ->Void in completion(responseObject, nil)}
        
        let failureCompletion = {(dataTask:URLSessionDataTask?, error:Error?) -> Void in completion(nil, error)}
        
        sharedManager.post(URLString, parameters: parameters, constructingBodyWith: {(formData) in formData.appendPart(withFileData: fileData, name: fileName, fileName: "", mimeType: "application/octet-stream")}, progress: nil, success: successCompletion, failure: failureCompletion)
    }
}
