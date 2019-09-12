//
//  TCJTopicDAL.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

public enum TCJTopicType:Int
{
    case All = 1       // 全部
    case Picture = 10  // 图片
    case Word = 29     // 段子
    case Voice = 31    // 声音
    case Video = 41    // 视频
}

class TCJTopicDAL {
    // MARK:- 创建单例
    
    /// 单例
    public static let shared:TCJTopicDAL = TCJTopicDAL()
    
    // MARK: - 通知监听方法
    
    /// 应用程序进入后台通知监听事件
    @objc private func applicationDidEnterBackgroundNotification() -> Void
    {
        clearCache()
    }
    
    /// 数据库管理
    private var SQLiteManager:TCJSQLiteManager
    /// 微博数据缓存路径
    private var cachePath:String
    /// 最大缓存时间3天
    private let kMaxCacheTime:CFTimeInterval = -3 * 24 * 60 * 60
    
    private init()
    {
        // 设置缓存路径
        let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        cachePath = (document as NSString).appendingPathComponent("Swift-TCJ")
        // 打开数据库
        SQLiteManager = TCJSQLiteManager(path: cachePath)
        
        // 创建数据表
        if let filePath = Bundle.main.path(forResource: "Swift-TCJ.sql", ofType: nil), let sql = try? String(contentsOfFile: filePath) {
            _ = SQLiteManager.createTable(sql: sql)
        }
    }
}

// MARK: - 网络请求数据相关方法

extension TCJTopicDAL
{
    /// 获取自定义类型的帖子
    ///
    /// - Parameters:
    ///   - type: 帖子类型
    ///   - isNewTopicList: 是否是新帖 默认false
    ///   - maxId: 帖子id 加载比此id小的帖子 加载更多数据
    ///   - minId: 帖子id 加载比此id大的帖子 加载最新数据
    ///   - completion: 完成回调
    open func loadTopicList(type:TCJTopicType,isNewTopicList:Bool = false, maxId:Int = 0, minId:Int = 0, completion:@escaping ([[String:Any]]?,Error?) -> Void) -> Void
    {
        if !isNewTopicList && minId == 0 {
            // 非新帖模块 非下拉刷新
            let dictArray = loadTopicListFromSqlite(maxId: maxId,topicType: type)
            if dictArray.count > 0 {
                completion(dictArray,nil)
                TCJPrint("从数据库加载\(dictArray.count)条数据")
                return
            }
        }
        
        var parameters:[String:Any] = ["c" : "data",
                                       "type" : type.rawValue]
        // 判断是否是新帖
        if isNewTopicList {
            parameters["a"] = "newlist"
        } else {
            parameters["a"] = "list"
        }
        
        // 判断是否是上拉加载更多数据
        if maxId != 0 {
            parameters["maxtime"] = maxId
        }
        
        TCJNetworkManager.request(type: .Get, URLString: kTopicListAPI, parameters: parameters) { (responseObject, error) in
            if responseObject == nil || error != nil {
                completion(nil,error)
                return
            }
            
            var dictArray = (responseObject as? [String:Any])?["list"] as? [[String:Any]]
            // 帖子按id进行排序 从服务器请求回来的数据并没有进行排序
            dictArray?.sort(by: { (dict1, dict2) -> Bool in
                return (dict1["t"] as! Int) > (dict2["t"] as! Int)
            })
            // 保存数据到数据库
            self.saveTopicListToSqlite(dictArray: dictArray)
            TCJPrint("从网络加载\(dictArray?.count ?? 0)条数据")
            completion(dictArray,nil)
        }
    }
    
    /// 获取标签订阅页面中推荐标签中的内容
    ///
    /// - Parameter completion: 完成回调
    open func loadNewTopicRecommendList(completion:@escaping ([[String:Any]]?,Error?) -> Void) -> Void
    {
        let parameters:[String:Any] = ["a" : "tag_recommend",
                                       "c" : "topic",
                                       "action" : "sub"]
        TCJNetworkManager.request(type: .Get, URLString: kNewTopicRecommendAPI, parameters: parameters) { (responseObject, error) in
            if responseObject == nil || error != nil {
                completion(nil,error)
                return
            }
            
            completion(responseObject as? [[String:Any]],nil)
        }
    }
    
    /// 获取“我”板块功能列表
    ///
    /// - Parameter completion: 完成回调
    open func loadSquareList(completion:@escaping ([String:Any]?,Error?) -> Void) -> Void
    {
        let parameters:[String:Any] = ["a" : "square",
                                       "c" : "topic"]
        TCJNetworkManager.request(type: .Get, URLString: kSquareListAPI, parameters: parameters) { (responseObject, error) in
            if responseObject == nil || error != nil {
                completion(nil,error)
                return
            }
            
            completion(responseObject as? [String:Any],nil)
        }
    }
    
    /// 获取“推荐关注”中左侧标签的列表
    ///
    /// - Parameter completion: 完成回调
    open func loadRecommendCategoryList(completion:@escaping ([String:Any]?,Error?) -> Void) -> Void
    {
        let parameters:[String:Any] = ["a" : "category",
                                       "c" : "subscribe"]
        TCJNetworkManager.request(type: .Get, URLString: kRecommendCategoryAPI, parameters: parameters) { (responseObject, error) in
            if responseObject == nil || error != nil {
                completion(nil,error)
                return
            }
            
            completion(responseObject as? [String:Any],nil)
        }
    }
    
    /// 获取“推荐关注”中左侧标签每个标签对应的推荐用户组
    ///
    /// - Parameters:
    ///   - categoryId: 分类ID
    ///   - page: 页码
    ///   - completion: 完成回调
    open func loadRecommendItemList(categoryId:Int,page:Int = 1, completion:@escaping ([String:Any]?,Error?) -> Void) -> Void
    {
        let parameters:[String:Any] = ["a" : "list",
                                       "c" : "subscribe",
                                       "category_id": categoryId,
                                       "page": page]
        TCJNetworkManager.request(type: .Get, URLString: kRecommendCategoryAPI, parameters: parameters) { (responseObject, error) in
            if responseObject == nil || error != nil {
                completion(nil,error)
                return
            }
            
            completion(responseObject as? [String:Any],nil)
        }
    }
}

// MARK: - 数据库相关方法

private extension TCJTopicDAL
{
    /// 从数据库中加载缓存数据
    func loadTopicListFromSqlite(maxId:Int = 0,topicType:TCJTopicType) -> [[String:Any]]
    {
        var topicList = [[String:Any]]()
        var sql = "SELECT topic FROM T_Topic\n"
        
        if maxId > 0 {
            sql += "WHERE id < \(maxId)\n"
        }
        
        if topicType != .All {
            sql += "AND topicType = \(topicType.rawValue)\n"
            if !sql.contains("WHERE") {
                let range = sql.range(of: "AND")
                sql.replaceSubrange(range!, with: "WHERE")
            }
        }
        
        sql += "ORDER BY id DESC LIMIT 20;\n"
        let result = SQLiteManager.query(sql: sql)
        for dictionary in result {
            if let str = dictionary["topic"] as? String,  // 取出字符串
                let data = str.data(using: .utf8),        // 字符串转二进制数据
                let topic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any]  {
                // 二进制json序列化成字典
                topicList.append(topic)
            }
        }
        
        return topicList
    }
    
    /// 将帖子数据存入数据库
    ///
    /// - Parameter dictArray: 帖子字典数组
    func saveTopicListToSqlite(dictArray:[[String:Any]]?) -> Void
    {
        guard let dictArray = dictArray else {
            return
        }
        
        SQLiteManager.inTransaction { (db, stop) in
            for dict in dictArray {
                // 遍历数组字典 将字典序列化成二进制数据 二进制再转成字符串存入数据库
                if let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted]),
                    let str = String(data: data, encoding: .utf8),
                    let id = dict["t"] as? Int,
                    let topicType = dict["type"] as? String {
                    let sql = "INSERT OR REPLACE INTO T_Topic (id,topic,topicType) VALUES (?,?,?);"
                    let isSuccess = db.executeUpdate(sql, withArgumentsIn: [id,str,topicType])
                    
                    if isSuccess == false {
                        // 插入错误 进行回滚
                        stop.pointee = true
                        break
                    }
                }
            }
        }
    }
    
    /// 清除过期数据
    func clearCache() -> Void
    {
        let dateStr = Date.dateToString(sinceNow: kMaxCacheTime)
        let sql = "DELETE FROM T_status WHERE createTime < ?;"
        _ = SQLiteManager.delete(sql: sql, arguments: [dateStr])
    }
}
