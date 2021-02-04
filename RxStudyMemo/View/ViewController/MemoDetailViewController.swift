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
        
        
    }
    
}
