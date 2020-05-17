//
//  WatchItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 10.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItem: Equatable {
    var image: UIImage
    var localTitle: String
    var originalTitle: String
    var year: String
    
    
    init(image: UIImage, localTitle: String, originalTitle: String, year: String) {
        self.image = image
        self.localTitle = localTitle
        self.originalTitle = originalTitle
        self.year = year
    }
    
    static func == (lhs: WatchItem, rhs: WatchItem) -> Bool {
        return lhs.localTitle == rhs.localTitle && lhs.originalTitle == rhs.originalTitle && lhs.year == rhs.year
    }
}


var toWatchItems: [WatchItem] = [WatchItem(image: #imageLiteral(resourceName: "6"), localTitle: "Человек-паук. Возвращение домой", originalTitle: "Spider-Man: Homecoming", year: "2017"),
                                 WatchItem(image: #imageLiteral(resourceName: "2"), localTitle: "Как трусливый Роберт Форд убил Джесси Джеймса", originalTitle: "The Assassination of Jesse James by the Coward Robert Ford", year: "2007"),
                                 WatchItem(image: #imageLiteral(resourceName: "7"), localTitle: "Дамбо", originalTitle: "Dumbo", year: "2019"),
                                 WatchItem(image: #imageLiteral(resourceName: "1"), localTitle: "Король говорит!", originalTitle: "The King's Speech", year: "2010"),
                                 WatchItem(image: #imageLiteral(resourceName: "3"), localTitle: "Стекло", originalTitle: "Glass", year: "2019"),
                                 WatchItem(image: #imageLiteral(resourceName: "4"), localTitle: "Кладбище домашних животных", originalTitle: "Pet Sematary", year: "2019"),
                                 WatchItem(image: #imageLiteral(resourceName: "5"), localTitle: "Наёмные убийцы", originalTitle: "Assassins", year: "1995"),
                                 WatchItem(image: #imageLiteral(resourceName: "8"), localTitle: "Кредо убийцы", originalTitle: "Assassin's Creed", year: "2016"),
                                 WatchItem(image: #imageLiteral(resourceName: "11"), localTitle: "Снегоуборщик", originalTitle: "Cold Pursuit", year: "2019")]

var watchedItems: [WatchItem] = [WatchItem(image: #imageLiteral(resourceName: "9"), localTitle: "Снежные ангелы", originalTitle: "Snow Angels", year: "2007"),
                                 WatchItem(image: #imageLiteral(resourceName: "10"), localTitle: "Мэри Поппинс возвращается", originalTitle: "Mary Poppins Returns", year: "2018"),
                                 WatchItem(image: #imageLiteral(resourceName: "8"), localTitle: "Кредо убийцы", originalTitle: "Assassin's Creed", year: "2016"),
                                 WatchItem(image: #imageLiteral(resourceName: "11"), localTitle: "Снегоуборщик", originalTitle: "Cold Pursuit", year: "2019")]

