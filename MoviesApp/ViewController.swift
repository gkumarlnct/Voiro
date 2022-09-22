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
    
    @IBOutlet weak var movieListTblVw: UITableView!
    var movieListAry = [movieList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        // Do any additional setup after loading the view.
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.movieListTblVw.separatorColor = UIColor.clear
        let dictTemp = NSMutableDictionary()
  
        TransactionListI.getMoviesList(dictTemp) { result in
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
    
    
    func getMovieDetails(movie: Int, completion: @escaping (Result?) -> ()) {

        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/5/lists?api_key=394a65ca2bb613e4b6ff3ae3e24845e2&language=en-US&page=3") else {
            fatalError("Invalid URL")
        }
        
    
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            // Check for errors
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            // Check that data has been returned
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                //                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetails = try decoder.decode(Result.self, from: data)
                
                DispatchQueue.main.async {
                    
                    completion(movieDetails)
                    print(movieDetails)
                    
                }
                
            } catch let err {
                print("Err", err)
            }
        }
        // execute the HTTP request
        task.resume()
    }
}

extension ViewController : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? movieCell
        cell?.selectionStyle = .none
        if self.movieListAry.count > 0{
            let movieDetailDic = self.movieListAry[indexPath.row]
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
        vc.movieDetails = self.movieListAry[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

