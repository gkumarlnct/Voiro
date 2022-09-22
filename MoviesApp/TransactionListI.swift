//
//  TransactionListI.swift
//  AdviSocial
//
//  Created by Wegile on 25/11/21.
//  Copyright © 2021 wegile. All rights reserved.
//

import Foundation
import UIKit
class TransactionListI
{
    class func getMoviesList(_ dict:NSDictionary, success:@escaping(NSDictionary)->Void)
    {
        WebService().requestWithBasicGET("https://api.themoviedb.org/3/movie/5/lists?api_key=394a65ca2bb613e4b6ff3ae3e24845e2&language=en-US&page=3", param: dict, success: { dict in
         
            DispatchQueue.main.async {
                
                success(dict)
                
            }
        }, failure: {
            DispatchQueue.main.async {
                
            }
        })
    }
}

