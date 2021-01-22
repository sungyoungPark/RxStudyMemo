//
//  MemoryStorage.swift
//  RxStudyMemo
//
//  Created by 박성영 on 2021/01/22.
//

import Foundation
import RxSwift


class MemoryStorage : MemoStorageType {   //메모리에 메모 저장
    
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "psy can do it", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> { //새로운 메모를 생성하고 배열에 추가
        let memo = Memo(content: content)
        list.insert(memo, at: 0)
        store.onNext(list)     //subject에서 새로운 next 이벤트 방출
        
        return Observable.just(memo)  //한개의 요소만 방출, 배열로 들어오면 배열로 방출
    }
    
    @discardableResult
    func memoList() -> Observable<[Memo]> {  //클래스 외부에서는 이 메소드를 이용해서 subject에 접근한다.
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)  //업데이트 되는 메모 인스턴스 생성
        
        if let index = list.firstIndex(where: { $0 == memo }){
            list.remove(at: index)
            list.insert(updated, at: index)
        }
        
        store.onNext(list)   //subject에서 새로운 next 이벤트 방출
        
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: { $0 == memo}) {
            list.remove(at: index)
        }
        
        store.onNext(list)
        
        return Observable.just(memo)
    }
    
    
}
