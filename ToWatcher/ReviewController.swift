//
//  ReviewController.swift
//  ToWatcher
//
//  Created by Alex Delin on 25.04.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation
import StoreKit

class ReviewController {
    private let isReviewAlreadyShownKey = "key_isReviewAlreadyShown"
    private var isReviewAlreadyShown: Bool {
        get { UserDefaults.standard.bool(forKey: isReviewAlreadyShownKey) ? true : false }
        set { UserDefaults.standard.set(newValue, forKey: isReviewAlreadyShownKey) }
    }
    
    //MARK: - Public methods
    func checkForReview(screen: ScreenType, type: WatchItemEditState) {
        guard !isReviewAlreadyShown else { return }
        
        let isNeededToShowReview = screen == .toWatch && type == .toWatched && DBManager.shared.getWatchItems(.toWatch).count >= 2
        
        if isNeededToShowReview {
            showReview()
        }
    }
    
    //MARK: - Private methods
    private func showReview() {
        SKStoreReviewController.requestReview()
        isReviewAlreadyShown = true
    }
}
