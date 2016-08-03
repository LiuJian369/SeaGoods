//
//  MyLayout.swift
//  cWaterFall
//
//  Created by 刘建 on 16/6/22.
//  Copyright © 2016年 liujian. All rights reserved.
//

import UIKit

class MyLayout: UICollectionViewFlowLayout {
    
    //记录每一列的高度
    var columnArr = [CGFloat].init(count: Int(ViewController.columnCount), repeatedValue: 0)
    //记录所有cell的布局信息
    var layoutDic = [NSIndexPath: String]()
    

//MARK:计算所有cell的布局信息
    override func prepareLayout() {
        //谁用layout就是哪个collectionView
        //collectionView里共有多少个cell
        let number = self.collectionView!.numberOfItemsInSection(0)
        
        for i in 0..<number{
            self.layoutItemAt(NSIndexPath(forItem: i, inSection: 0))
        }
    }
    
    func layoutItemAt(indexPath: NSIndexPath) -> Void {
        
        //拿到viewController的指针
        let delegate = self.collectionView?.delegate as! UICollectionViewDelegateFlowLayout
        //根据indexPath拿到对应cell的大小
        let size = delegate.collectionView!(self.collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
        //找到最短的一列
        var minColumn = 0
        var minHeight = columnArr[0]
        for i in 1..<columnArr.count{
            if  minHeight > columnArr[i]{
                minHeight = columnArr[i]
                minColumn = i
            
            }
        
        }
        //将新cell的高度添加到最短的一列里,cell间隔5
        columnArr[minColumn] += (size.height + 5)
        
        //计算cell的frame
        let frame = CGRectMake(ViewController.columnFar + CGFloat(minColumn) * (ViewController.columnFar + size.width), minHeight + 5, size.width, size.height)
        //记录到字典里
        layoutDic[indexPath] = NSStringFromCGRect(frame)
        
    }
    
    
//MARK: 用第一步算出的信息,对cell进行布局
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print(rect)
        //collectionView每个新页面即将出现时触发,rect就是新页面的contentFrame
        var tmpArr = [UICollectionViewLayoutAttributes]()
        
        
        //拿到所有当前页应该展示的indexPath
        let indexPathArr = self.indexPathAt(rect)
        //利用所有应该展示的indexPath创建布局属性
        for indexPath in indexPathArr{
            let attribue = UICollectionViewLayoutAttributes.init(forCellWithIndexPath: indexPath)
            attribue.frame = CGRectFromString(layoutDic[indexPath]!)
            tmpArr.append(attribue)
        
        }
        return tmpArr
        
    }
    
    func indexPathAt(rect: CGRect) -> [NSIndexPath] {
        var tmpArr = [NSIndexPath]()
        for (key, value) in layoutDic{
            let cellFrame = CGRectFromString(value)
            //判断两个页面是否有交叉
            if CGRectIntersectsRect(cellFrame, rect){
                tmpArr.append(key)
            
            }

        }
        return tmpArr
    }
   
//MARK: 设置contentSize
    override func collectionViewContentSize() -> CGSize {
        var size = self.collectionView!.frame.size
        size.height = columnArr[0]
        for height in columnArr{
            if size.height < height{
                size.height = height
            
            }
        
        }
        return size
    }
    
}
