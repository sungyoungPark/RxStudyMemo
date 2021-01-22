//
//  TransitionModel.swift
//  RxStudyMemo
//
//  Created by 박성영 on 2021/01/22.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}


enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
