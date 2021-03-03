//
//  WatchItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 10.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItem: Equatable {
//    var movie: Movie
    var id: Int
    var imageURL: URL
    var localTitle: String
    var originalTitle: String
    var year: String
    
    init(id: Int, imageURL: URL, localTitle: String, originalTitle: String, year: String) {
        self.id = id
        self.imageURL = imageURL
        self.localTitle = localTitle
        self.originalTitle = originalTitle
        self.year = year
    }
    
    static func == (lhs: WatchItem, rhs: WatchItem) -> Bool {
        return lhs.localTitle == rhs.localTitle && lhs.originalTitle == rhs.originalTitle && lhs.id == rhs.id
    }
}

//var toWatchItems: [WatchItem] = [WatchItem(movie: Movie(id: 111, originalTitle: "Человек-паук. Возвращение домой", title: "Spider-Man: Homecoming", releaseDate: "2013-07-26"))]
//var watchedItems: [WatchItem] = [WatchItem(movie: Movie(id: 222, originalTitle: "Снежные ангелы", title: "Snow Angels", releaseDate: "2007-04-20"))]

var toWatchItems: [WatchItem] = [WatchItem(id: 315635, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/9xj4OXUbX2FYorf6Vat6Rlq1u01.jpg")!, localTitle: "Человек-паук. Возвращение домой", originalTitle: "Spider-Man: Homecoming", year: "2017")]//,
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/5r2BZajlRZqnOc6s2BS0aiFDcne.jpg")!, localTitle: "Как трусливый Роберт Форд убил Джесси Джеймса", originalTitle: "The Assassination of Jesse James by the Coward Robert Ford", year: "2007"),
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/5tFt6iuGnKapHl5tw0X0cKcnuVo.jpg")!, localTitle: "Дамбо", originalTitle: "Dumbo", year: "2019"),
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/5eb7l7AE2yU0mvb38fR5qLNhDDH.jpg")!, localTitle: "Король говорит!", originalTitle: "The King's Speech", year: "2010"),
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/ngBFDOsx13sFXiMweDoL54XYknR.jpg")!, localTitle: "Стекло", originalTitle: "Glass", year: "2019"),
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/dpJq6trUDOutSPSLrFdROPmzaVn.jpg")!, localTitle: "Кладбище домашних животных", originalTitle: "Pet Sematary", year: "2019"),
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/ejaBMLY1IlNdmpgDD4Vy4xhdlkR.jpg")!, localTitle: "Наёмные убийцы", originalTitle: "Assassins", year: "1995")]

var watchedItems: [WatchItem] = []
//    [WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/kx4HKFpIMzTIB6KsDG6m7mlCNc8.jpg")!, localTitle: "Снежные ангелы", originalTitle: "Snow Angels", year: "2007"),
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/3pvIMjJps4uJr5NOmolY0MXvTYD.jpg")!, localTitle: "Мэри Поппинс возвращается", originalTitle: "Mary Poppins Returns", year: "2018"),
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780//cjFawSYprlCnrlCm85PbcTWlIg1.jpg")!, localTitle: "Кредо убийцы", originalTitle: "Assassin's Creed", year: "2016"),
//                                 WatchItem(id: 1, imageURL: URL(string: "https://image.tmdb.org/t/p//w780/aiM3XxYE2JvW1vJ4AC6cI1RjAoT.jpg")!, localTitle: "Снегоуборщик", originalTitle: "Cold Pursuit", year: "2019")]

