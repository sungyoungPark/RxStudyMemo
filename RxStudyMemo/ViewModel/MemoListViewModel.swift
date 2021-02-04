//
//  MemoListViewModel.swift
//  RxStudyMemo
//
//  Created by 박성영 on 2021/01/22.
//

import Foundation
import RxCocoa
import RxSwift
import Action

class MemoListViewModel : CommonViewModel{  //의존성을 주입하는 생성자, 바인딩에 사용되는 속성과 메소드 구현
    var memoList : Observable<[Memo]> {
        return storage.memoList()
    }
    
    func performUpdate(memo : Memo) -> Action<String,Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in }
            //observable을 void로 형 변환 해주기 위해 map을 사용
        }
    }
    
    func performCancel(memo : Memo) -> CocoaAction{
        return Action { input in
            return self.storage.delete(memo: memo).map { _ in }
        }
    }
    
    
    func makeCreateAction() -> CocoaAction{
        return CocoaAction { _ in
            return self.storage.createMemo(content: "")  //내용이 없는 메모를 생성
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
    
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
                }
        }
    }
    
    //속성 형태
    lazy var detailAction : Action<Memo, Void> = {     //Action<입력형식, 출력 형식>
        return Action { memo in
            
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map { _ in }
        }
    }()
    
    
}
