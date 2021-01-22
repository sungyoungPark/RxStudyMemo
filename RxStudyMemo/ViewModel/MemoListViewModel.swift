//
//  MemoListViewModel.swift
//  RxStudyMemo
//
//  Created by 박성영 on 2021/01/22.
//

import Foundation
import RxCocoa
import RxSwift

class MemoListViewModel : CommonViewModel{  //의존성을 주입하는 생성자, 바인딩에 사용되는 속성과 메소드 구현
    var memoList : Observable<[Memo]> {
        return storage.memoList()
    }
}
