//
//  URLResponse+.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/16.
//

import UIKit

extension URLResponse {
    
    fileprivate var successRange: ClosedRange<Int> {
        return 200...299
    }
    
    func checkResponse() -> NetworkResult {
        guard let httpResponse = self as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
            return NetworkResult.failure(NetworkError.outOfReponseCode)
        }
        return .success("Reponse 성공했습니다.")
    }
}
