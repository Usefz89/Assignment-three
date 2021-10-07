//
//  AspectVGrid.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable  {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    var body: some View {
        
        GeometryReader { geometry in
            let width: CGFloat = widthThatFits(in: geometry.size, itemsCount: items.count)
            if width > geometry.size.width / 6 {
                VStack {
                    LazyVGrid(columns: [getGridItem(width: width)], spacing: 0) {
                        ForEach(items) { item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                       }
                   }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [getGridItem(width: geometry.size.width / 6 )], spacing: 0) {
                        ForEach(items) { item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                       }
                    }
                }
            }
        }
    }
      
    func getGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    func widthThatFits(in size: CGSize, itemsCount: Int) -> CGFloat {
        var columnsCount = 1
        var rowsCount =  itemsCount
        
        repeat {
            let itemWidth = size.width /  CGFloat( columnsCount)
            let itemHeight = itemWidth / aspectRatio
            if (itemHeight * CGFloat( rowsCount)) < size.height {
                break
            }
            columnsCount += 1
            rowsCount = (itemsCount + (columnsCount - 1)) / columnsCount
            
        } while columnsCount < itemsCount
        if (columnsCount > itemsCount) {
            columnsCount = itemsCount
        }
        return floor(size.width / CGFloat(columnsCount))
       
    }
}
