//
//  MemoDetailViewController.swift
//  RxStudyMemo
//
//  Created by 박성영 on 2021/01/22.
//

import UIKit

class MemoDetailViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoDetailViewModel!
    @IBOutlet weak var listTableView: UITableView!
 
    @IBOutlet weak var deleteBTN: UIBarButtonItem!
    @IBOutlet weak var editBTN: UIBarButtonItem!
    @IBOutlet weak var shareBTN: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        
        viewModel.contents
            .bind(to: listTableView.rx.items) { tableview, row, value in
                switch row {
                case 0: //첫번째 셀이면 contents를 꺼냄
                    let cell = tableview.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableview.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                    
                }
            }.disposed(by: rx.disposeBag)
        
        /* 교체식 구현
        //title이 drive 형태로 제공되기 때문에 생성자로는 전달할 수 없으므로 이렇게 구현
        var backBTN = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        
        viewModel.title.drive(backBTN.rx.title)  //viewModel에 있는 타이틀과 버튼 타이틀을 연결
            .disposed(by: rx.disposeBag)
        
        backBTN.rx.action = viewModel.popAction
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBTN  //기본으로 제공되는 back 버튼 대체
        */
    }
    
}
