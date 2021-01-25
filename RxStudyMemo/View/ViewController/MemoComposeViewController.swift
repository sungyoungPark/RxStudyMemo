//
//  MemoComposeViewController.swift
//  RxStudyMemo
//
//  Created by 박성영 on 2021/01/22.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var cancelBTN: UIBarButtonItem!
    @IBOutlet weak var saveBTN: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    var viewModel: MemoComposeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)  //바인딩 할 주체
            .disposed(by: rx.disposeBag)   //title을 바인딩
        
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        
        //액션 패턴으로 액션을 구현할때는 액션 속성에 저장하는 식으로 바인드
        cancelBTN.rx.action = viewModel.cancelAction
        
        saveBTN.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)  // 더블 탭을 막기 위해, 0.5초마다 한번씩만 탭을 처리
            .withLatestFrom(contentTextView.rx.text.orEmpty)  //탭 액션과 함께 contentTextView 내용도 함께 방출 , orEmpty는 nil이 되지 않게 만든다.
            .bind(to: viewModel.saveAction.inputs) //방출된 텍스트를 saveAction과 바인딩
            .disposed(by: rx.disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()  //텍스트 뷰에 키보드를 활성화 시키기 위함
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
    
    
}
