//
//  NetworkResult.swift
//  28th_BESOPT_2ndWeek_Assignment
//
//  Created by λΈνμ on 2021/05/12.
//

import Foundation

enum NetworkResult<T> {
  case success(T)
  case success(T,T)
  case requestErr(T)
  case pathErr
  case serverErr
  case networkFail
}
