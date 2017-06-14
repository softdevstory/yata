//: Playground - noun: a place where people can play

import ObjectMapper

enum Data {
    case value(String)
    case cat(MainCatModel)
}


class MainCatModel: Mappable {
    var id: String!
    var name: String!

    required init?(map: Map) {}
    
    func mapping(map : Map){
        id <- map["id"]
        name <- map["name"]
    }
}

class ResponseModel: Mappable {
    var data: Data?
    var code: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map["code"]

        let value = map["data"].currentValue
        if let string = value as? String {
            data = Data.value(string)
        } else if let dict = value as? [String: Any] {
            if let cat = MainCatModel(JSON: dict) {
                data = Data.cat(cat)
            }
        }
    }
}

func printModel(model: ResponseModel) {
    print("code: \(model.code)")
    switch model.data! {
    case .value(let text):
        print("data: \(text)")
    case .cat(let cat):
        print("data: {id: \(cat.id!), name: \(cat.name!)}")
    }
}

let a = ResponseModel(JSONString: "{\"code\":0,\"data\":{\"id\":\"1\",\"name\":\"Pop\"} }")
printModel(model: a!)
print("----")

let b = ResponseModel(JSONString: "{\"code\":0,\"data\":\"fdasf\"}")
printModel(model: b!)