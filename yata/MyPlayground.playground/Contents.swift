//: Playground - noun: a place where people can play


import Foundation

import RxSwift
import Moya

enum Telegraph {
    case getViews(path: String)
}

extension Telegraph: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.telegra.ph")!
    }
    
    var path: String {
        switch self {
        case .getViews:
            return "/getViews"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getViews:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getViews(let path):
            return ["path": path]
        
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getViews:
            return URLEncoding.queryString
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getViews:
            return "{\"ok\":true,\"result\":{\"views\":40}}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .getViews:
            return .request
        }
    }
}

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
     var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}

let bag = DisposeBag()

print("1")
let provider = RxMoyaProvider<Telegraph>()
provider.request(.getViews(path: "Sample-Page-12-15"))
    .subscribe(onNext: { moyaResponse in
        let json = try? moyaResponse.mapJSON()
        print(json as! [String: Any])
    }, onError: { error in
        print(error)
    })
    .addDisposableTo(bag)

print("2")
sleep(10)
print("3")
