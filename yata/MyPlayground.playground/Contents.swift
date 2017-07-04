
import RxSwift

struct dumy {
    var a: Int
    var b: String
}

let bag = DisposeBag()

var array: Variable<[dumy]> = Variable([])

array.asObservable()
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: bag)


array.value.append(dumy(a: 1, b: "b"))
array.value.append(dumy(a: 1, b: "b"))
array.value.append(dumy(a: 1, b: "b"))

array.value[1].a = 2
array.value[1].b = "song"
