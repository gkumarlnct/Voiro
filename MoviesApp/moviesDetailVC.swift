//
//  moviesDetailVC.swift
//  MoviesApp
//
//  Created by Gaurav Kumar on 20/09/22.
//

import UIKit

class movieDetailCell :  UITableViewCell{
 
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var castLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class moviesDetailVC: UIViewController {
    @IBOutlet weak var movieDetailTblVw: UITableView!
    var movieDetails = movieList()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movies Details"
        self.movieDetailTblVw.separatorColor = UIColor.clear

        // Do any additional setup after loading the view.
    }
 

}

extension moviesDetailVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieDetailCell") as? movieDetailCell
        if movieDetails.poster_path != "" && movieDetails.poster_path != nil{
        let dpUrl = "https://image.tmdb.org/t/p/w500\(movieDetails.poster_path!)"
        cell?.movieImg.sd_setImage(with: URL.init(string: "\(dpUrl)"),placeholderImage: #imageLiteral(resourceName: "star"), completed: nil)
        }else{
            cell?.movieImg.image = UIImage(named: "")
        }
        cell?.movieTitle.text = movieDetails.name
        cell?.aboutLbl.text = movieDetails.description
//        cell?.castLbl.text = movieDetails.description

        cell?.selectionStyle = .none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 742
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
