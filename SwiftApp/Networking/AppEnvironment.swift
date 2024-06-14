//
//  AppEnvironment.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/17.
//

import Foundation

enum AppEnvironment {
    static var instance = Environment()
}

struct Environment {
    let service: NetworkingService
    init(service: NetworkingService = NetworkingServiceIMP()) {
        self.service = service
    }
}
