import UIKit
import RxSwift
import RxCocoa
import RxRelay

let behaviorRelay = BehaviorRelay<String>(value: "bRel E1 1")

let observe1 = behaviorRelay.subscribe(onNext: { element in
    print(element)
})

behaviorRelay.accept("bRel E1 2")
// bRel E1 1 -> Initial event
// bRel E1 2 -> lastest event also would be seen




