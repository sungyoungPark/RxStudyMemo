//
//  SceneCoordinator.swift
//  RxStudyMemo
//
//  Created by 박성영 on 2021/01/23.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController{
    var sceneViewController : UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator : SceneCoordinatorType{  //화면 전환을 담당
    
    private let bag = DisposeBag() //리소스 정리를 위해 사용됨
    
    private var window : UIWindow  //화면 전환을 담당하므로 갖고 있어야 한다
    private var currentVC :UIViewController // 현재 화면
    
    required init(window : UIWindow){
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        
        let subject = PublishSubject<Void>()
        let target = scene.instantiate()  //Scene 열거형에서 구현함
        
        switch style {
        case .root:  //rootviewController만 바꿔주면 됨
            currentVC = target.sceneViewController
            window.rootViewController = target
            subject.onCompleted()
        case .push:  //navigationCotroller에 임베드 될때만 의미가 있음
            guard let nav = currentVC.navigationController  //navigationCotroller에 임베드 되어 있지 않다면 에러
            else{
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow //네비게이션뷰에 delegate 메소드가 호출되는 시점마다 next 이벤트를 방출하는 컨트롤 이벤트이다.
                .subscribe(onNext: { [unowned self] evt in
                    print(evt)
                    self.currentVC = evt.viewController.sceneViewController
                })  //currentVC 속성을 업데이트
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target.sceneViewController

        }
        
        return subject.ignoreElements().asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController{
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }
            else if let nav = self.currentVC.navigationController{
                guard nav.popViewController(animated: animated) !=  nil
                else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            }
            else{
                completable(.error(TransitionError.unknown))
            }
            return Disposables.create()
        }
    }
    
    
    
}
