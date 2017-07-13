import Foundation

var json: Any?

//json = "abc"
//Swift.print(json)
//
//json = [ "abc": "def" ]
//Swift.print(json)

var anyArray = [Any]()
anyArray.append("abc")
anyArray.append(["key": "def"])
anyArray.append(["key": "ghi"])
json = ["key": anyArray]
Swift.print(json ?? "")

//print(JSONSerialization.isValidJSONObject(json))
do {
    let data = try JSONSerialization.data(withJSONObject: json!)
    let string = String(data: data, encoding: .utf8)
    print(string!)
} catch {
    print("error \(error)")
}