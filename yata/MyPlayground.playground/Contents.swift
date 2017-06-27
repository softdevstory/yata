func increment(x: Int) -> Int {
  print("Computing next value of \(x)")
  return x+1
}

//let array = Array(0..<10)
//let incArray = array.map(increment)
//print("Result:")
//print(incArray[0], incArray[4])


let array = Array(0..<10)
let incArray = array.lazy.map(increment)
print("Result:")
print(incArray[0], incArray[4])
