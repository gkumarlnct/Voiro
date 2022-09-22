//
//  TransactionListI.swift
//  AdviSocial
//
//  Created by Wegile on 25/11/21.
//  Copyright © 2021 wegile. All rights reserved.
//

import Foundation
import UIKit
class moviesListI
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
extension ViewController : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searching{
            return searchAry.count
        }else{
            return movieListAry.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? movieCell
        cell?.selectionStyle = .none
        var movieDetailDic = movieList()
        if self.searching{
            movieDetailDic = self.searchAry[indexPath.row]
        }else{
            movieDetailDic = self.movieListAry[indexPath.row]
        }
        if self.movieListAry.count > 0 || searchAry.count > 0{
            cell!.movieTitle.text = movieDetailDic.name!
            cell!.starRatingLbl.text = "\(String(describing: movieDetailDic.item_count!))"
            if movieDetailDic.poster_path != "" && movieDetailDic.poster_path != nil{
                let dpUrl = "https://image.tmdb.org/t/p/w500\(movieDetailDic.poster_path!)"
                cell!.movieImg.sd_setImage(with: URL.init(string: "\(dpUrl)"),placeholderImage: #imageLiteral(resourceName: "star"), completed: nil)
            }else{
                cell?.movieImg.image = UIImage(named: "")
                
            }
            
        }
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "moviesDetailVC") as! moviesDetailVC

        if self.searching{
            vc.movieDetails = self.searchAry[indexPath.row]

        }else{
            vc.movieDetails = self.movieListAry[indexPath.row]

        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension ViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        mainView.searchBar.textField?.resignFirstResponder()
//        self.view.endEditing(true)
        searchAry.removeAll()
        let searchText = searchBar.searchTextField.text ?? ""
        if searchText != ""{
            self.searching = true
            for character in self.movieListAry {
                let dic = character as? movieList
                let value = dic!.name
                let value1 = value!.lowercased()
                if searchText.lowercased() == value!.lowercased().prefix(searchText.count){
                    self.searchAry.append(dic!)
                }else if value1.contains("\(searchText.lowercased())"){
                    self.searchAry.append(dic!)
                }
            }
            if self.searchAry.count > 0{
                self.searching = true
                self.movieListTblVw.reloadData()
            }else{
                self.searching = true
            }
        }else{
            self.searching = false
            self.movieListTblVw.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.searchTextField.text?.count == 0 {
            if searching == true{
                self.searching = false
                self.movieListTblVw.reloadData()
            }else{
                self.searching = false
                self.searchAry.removeAll()
                self.movieListTblVw.reloadData()
            }
        }else{
            self.searching = true
        }
    }
}

