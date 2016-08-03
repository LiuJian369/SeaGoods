//
//  LJHttpRequest.swift
//  KitProject
//
//  Created by 刘建 on 16/7/4.
//  Copyright © 2016年 liujian. All rights reserved.
//

import UIKit

//该类是对AFNetworking3.0的二次封装
class LJHttpRequest: NSObject {
    
    //通过GET方式请求网络数据
    class func GET(success suc: (data: NSData) -> Void, failed fail:(reason: String) -> Void, url: String){
        //通过AFNetworking创建Session会话
        let manager = AFHTTPSessionManager()
        //设置获取的数据类型为二进制格式
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.GET(url, parameters: nil, progress: nil, success: { (dataTask, obj) in
            //通过闭包将数据返回给调用者
            suc(data: obj as! NSData)
            
            }) { (dataTask, error) in
                
            fail(reason: error.localizedFailureReason!)
        }

    }
    
    //通过POST方式请求网络数据
    class func POST(success suc: (data: NSData) -> Void, failed fail:(reason: String) -> Void, url: String, param: NSDictionary){
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.POST(url, parameters: param, progress: nil, success: { (resp, obj) in
                suc(data: obj as! NSData)
            }) { (resp, error) in
                fail(reason: error.localizedFailureReason!)
        }
    }

}
