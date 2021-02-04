//
//  MemoListViewController.swift
//  RxStudyMemo
//
//  Created by 박성영 on 2021/01/22.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
   
    var viewModel: MemoListViewModel!

   
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func bindViewModel() {
        viewModel.title   //뷰모델에 타이틀이 네비게이션에 추가
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) {
                row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
        
        
        addButton.rx.action = viewModel.makeCreateAction()
    }

}
