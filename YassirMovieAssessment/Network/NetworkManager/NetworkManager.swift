//
//  NetworkManager.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 15/11/2022.
//

import Foundation
import RxSwift
import Alamofire

class NetworkManager {
    
    func exec<ResponseDto: Decodable>(url: String,
                                      dto: ResponseDto.Type) -> Observable<ResponseDto> {
        return Observable.create { observer in
            let params = ["api_key":"c9856d0cb57c3f14bf75bdc6c063b8f3"]
            
            let request = AF.request(url,
                                     method: .get,
                                     parameters: params)
            
            request.responseDecodable(of: dto.self) { (response) in
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
                        
            return Disposables.create()
        }
    }
}
