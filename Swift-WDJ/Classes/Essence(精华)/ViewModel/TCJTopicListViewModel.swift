//
//  TCJTopicListViewModel.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJTopicListViewModel
{
    /// 数据模型数组
    private(set) open var topicList = [TCJTopicViewModel]()
}

// MARK: - 网络请求数据

extension TCJTopicListViewModel
{
    /// 获取自定义类型的帖子
    ///
    /// - Parameters:
    ///   - type: 帖子类型
    ///   - isNewTopocList: 是否是新帖 默认false
    ///   - maxId: 帖子id 加载比此id小的帖子 加载更多数据
    ///   - minId: 帖子id 加载比此id大的帖子 加载最新数据
    ///   - completion: 完成回调
    open func loadTopicList(type:TCJTopicType,isNewTopicList:Bool = false, maxId:Int = 0, minId:Int = 0, completion:@escaping (Bool)-> Void) -> Void
    {
        TCJTopicDAL.shared.loadTopicList(type: type, isNewTopicList: isNewTopicList, maxId: maxId, minId: minId) { (responseObject, error) in
            if responseObject == nil || error != nil {
                completion(false)
                return
            }
            
            let topicModelArr = TCJTopicModel.mj_objectArray(withKeyValuesArray: responseObject!) as? [TCJTopicModel]
            if minId != 0 {
                // 下拉刷新 加载最新帖子 删除之前的帖子 加载最新数据
                self.topicList.removeAll()
            }
            
            // 模型转视图模型
            for topicModel in topicModelArr ?? [] {
                self.topicList.append(TCJTopicViewModel(model: topicModel))
            }
            
            // 完成回调
            completion(true)
        }
    }
}
