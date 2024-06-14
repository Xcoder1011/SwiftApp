//
//  NetworkingAPI.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import Foundation
import Moya
import RxSwift

public protocol NetworkingAPI: Moya.TargetType {}

public extension NetworkingAPI {
    @discardableResult
    func rx_request(callbackQueue: DispatchQueue? = .none,
                    progress: Moya.ProgressBlock? = .none) -> RxSwift.Single<Moya.Response> {
        RxSwift.Single.create { single in
            let cancellableToken = request(callbackQueue: callbackQueue, progress: progress) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }

    @discardableResult
    func request(callbackQueue: DispatchQueue? = .none,
                 progress: Moya.ProgressBlock? = .none,
                 completion: @escaping Moya.Completion) -> Moya.Cancellable {
        let provider = MoyaProvider<Self>()
        return provider.request(self, callbackQueue: callbackQueue, completion: completion)
    }
}
