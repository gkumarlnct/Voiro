//
//  ViewController.swift
//  MoviesApp
//
//  Created by Gaurav Kumar on 20/09/22.
//

import UIKit
import SDWebImage

class movieCell :  UITableViewCell{
 
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var starRatingLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieListTblVw: UITableView!
    var movieListAry = [movieList]()
    var searchAry = [movieList]()
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.searchTextField.backgroundColor = UIColor.clear
        self.searchBar.delegate = self
        self.searchBar.searchTextField.addTarget(self, action: #selector(searchTextStarted), for: UIControl.Event.editingChanged)

        self.title = "Movies"
        // Do any additional setup after loading the view.
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.callMovieApi()
    }
    
    @objc func searchTextStarted(sender : UITextField){
        self.searchBrand(brandAry: self.movieListAry)
    }
        
    
    func searchBrand(brandAry : [movieList]) {
        if self.searchBar.searchTextField.text == "" {
            self.searchBar.searchTextField.resignFirstResponder()
            self.searching = false
            
        }else{
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
    }
    
    func callMovieApi(){
        self.movieListTblVw.separatorColor = UIColor.clear
        let dictTemp = NSMutableDictionary()
  
        moviesListI.getMoviesList(dictTemp) { result in
            print(result)
            if result.count > 0{
                let result = result.value(forKey: "results") as! NSArray
                for item in result{
                    let moviedetail = movieList()
                    
                    moviedetail.description = (item as! NSDictionary).object(forKey: "description") as? String
                    moviedetail.favorite_count = (item as! NSDictionary).object(forKey: "favorite_count") as? Int
                    moviedetail.id = (item as! NSDictionary).object(forKey: "id") as? Int
                    moviedetail.item_count = (item as! NSDictionary).object(forKey: "item_count") as? Int
                    moviedetail.name = (item as! NSDictionary).object(forKey: "name") as? String
                    moviedetail.poster_path = (item as! NSDictionary).object(forKey: "poster_path") as? String
                    self.movieListAry.append(moviedetail)
                }
                self.movieListTblVw.reloadData()
            }
        }
    }
}



