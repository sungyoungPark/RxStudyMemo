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
        
    }
    
}
