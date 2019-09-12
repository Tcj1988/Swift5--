//
//  TCJSQLiteManager.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import FMDB

class TCJSQLiteManager {
    
    // MARK:- 内部私有属性
    /// 串行列队 执行sql语句
    private var queue:FMDatabaseQueue?
    /// 数据库缓存路径
    private var cachePath:String
    
    // MARK:- 构造方法
    init(path:String) {
        // 保存路径
        cachePath = path
        
        // 打开数据库
        queue = FMDatabaseQueue(path: path)
        let mesesage = (queue == nil ? "数据库打开失败!" : "数据库打开成功")
        TCJPrint(mesesage)
    }
    
    deinit {
        // 关闭数据库
        queue?.close()
    }
}

// MARK:- 数据库相关
extension TCJSQLiteManager
{
    /// 创建数据表
    open func createTable(sql:String) -> Bool
    {
        guard let queue = queue else {
            return false
        }
        
        var isSuccess:Bool = false
        queue.inDatabase { (db) in
            isSuccess = db.executeStatements(sql)
        }
        return isSuccess
    }
    
    /// 向数据库中查找数据
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - arguments: 参数
    /// - Returns: 查询结果
    open func query(sql:String,arguments:[Any]? = nil) -> [[String:Any]]
    {
        // 查找结果
        var statusList = [[String:Any]]()
        guard let queue = queue else {
            return statusList
        }
        
        queue.inDatabase { (db) in
            guard let result = db.executeQuery(sql, withArgumentsIn: arguments ?? []) else {
                return
            }
            
            while result.next() {
                var status = [String:Any]()
                for i in 0..<result.columnCount {
                    if let key = result.columnName(for: i),
                        let value = result.object(forColumnIndex: i) {
                        status[key] = value
                    }
                }
                statusList.append(status)
            }
        }
        
        return statusList
    }
    
    
    /// 向数据库中插入一条记录
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - arguments: 参数
    /// - Returns: 是否成功
    open func insert(sql:String,arguments:[Any]? = nil) -> Bool
    {
        var isSuccess:Bool = false
        queue?.inDatabase({ (db) in
            isSuccess = db.executeUpdate(sql, withArgumentsIn: arguments ?? [])
        })
        
        return isSuccess
    }
    
    /// 更新记录
    open func update(sql:String,arguments:[Any]? = nil) -> Bool
    {
        var isSuccess:Bool = false
        queue?.inDatabase({ (db) in
            db.executeUpdate(sql, withArgumentsIn: arguments ?? [])
            isSuccess = db.changes > 0
        })
        
        return isSuccess
    }
    
    /// 删除记录
    open func delete(sql:String,arguments:[Any]? = nil) -> Bool
    {
        var isSuccess:Bool = false
        queue?.inDatabase({ (db) in
            db.executeUpdate(sql, withArgumentsIn: arguments ?? [])
            isSuccess = db.changes > 0
        })
        
        return isSuccess
    }
    
    /// 事务方式执行
    open func inTransaction(block:(FMDatabase,UnsafeMutablePointer<ObjCBool>) -> Void) -> Void
    {
        guard let queue = queue else {
            return
        }
        
        queue.inTransaction(block)
    }
}
