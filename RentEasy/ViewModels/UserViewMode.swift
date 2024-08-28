//
//  ProfileViewModel.swift
//  RentEasy
//
//  Created by Apple on 13/8/24.
//

import Foundation

class UserViewModel {
    var userInfo: UserInfo?
    var onUserInfoFetched: (() -> Void)?
    var onError: ((Error) -> Void)?

    func fetchUserInfo() {
        APICaller.getUserInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfo):
                    self?.userInfo = userInfo
                    self?.onUserInfoFetched?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
}
