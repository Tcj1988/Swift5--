//
//  FileManager+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import Foundation

extension FileManager
{
    
    /// 获取指定路径文件大小
    ///
    /// - Parameters:
    ///   - filePath: 文件路径
    ///   - completion: 完成回调
    open func getFileSize(filePath:String,completion:@escaping (_ fileSize:Int64) -> Void) -> Void
    {
        var fileSize:Int64 = 0
        var isDirectory:ObjCBool = ObjCBool(false)
        let isExists = fileExists(atPath: filePath, isDirectory: &isDirectory)
        DispatchQueue.global().async {
            if !isExists {
                // 文件不存在
                fileSize = -1
            } else if !isDirectory.boolValue {
                // 传入的是一个文件
                let attributes = try? self.attributesOfItem(atPath: filePath)
                fileSize = ((attributes?[FileAttributeKey.size] as? Int64) ?? 0)
            } else {
                // 传入的是一个文件夹
                let subPaths = self.subpaths(atPath: filePath)
                for subPath in subPaths ?? [] {
                    // 拼接完整路径
                    let fullPath = (filePath as NSString).appendingPathComponent(subPath)
                    self.fileExists(atPath: fullPath, isDirectory: &isDirectory)
                    if isDirectory.boolValue {
                        continue
                    } else {
                        let attributes = try? self.attributesOfItem(atPath: fullPath)
                        fileSize += ((attributes?[FileAttributeKey.size] as? Int64) ?? 0)
                    }
                }
            }
            
            completion(fileSize)
        }
    }
    
    
    /// 删除指定路径中所有文件
    ///
    /// - Parameters:
    ///   - filePath: 路径
    ///   - completion: 完成回调
    open func removeFilePath(filePath:String,completion:((_ error:NSError?) -> Void)?) -> Void
    {
        var isDirectory:ObjCBool = ObjCBool(false)
        let isExists = fileExists(atPath: filePath, isDirectory: &isDirectory)
        DispatchQueue.global().async {
            if !isExists {
                // 文件不存在
                completion?(NSError(domain: "error", code: 100000001, userInfo: ["reason" : "要删除的路径不存在"]))
            } else if !isDirectory.boolValue {
                // 传入的是一个文件
                try? self.removeItem(atPath: filePath)
                completion?(nil)
            } else {
                // 传入的是一个文件夹
                let subItems = try? self.contentsOfDirectory(atPath: filePath)
                for subItem in subItems ?? [] {
                    let fullPath = (filePath as NSString).appendingPathComponent(subItem)
                    try? self.removeItem(atPath: fullPath)
                }
            }
            
            completion?(nil)
        }
    }
}
