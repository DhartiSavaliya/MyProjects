
import UIKit


class ViewController: UIViewController {

    var myTeam : Team?
    var arradata = [GameSection]()
    var gameData = [Game]()
    var gameData1 = [Game]()
  
    // -------------------------------------------------------------------------------------------------------//
   //NOTE : I am having issue with my terminal so i am not able to install pod file named "SDwebimage" for save load image locally--------------------------                                                          //
  //---------------------------------------------------------------------------------------------------------//

    
    
//------------------outlets-------------------
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var lblschdl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet weak var tbView: UITableView!
    
    
    //------------ViewDidLoad----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        tbView.delegate = self
        tbView.dataSource = self
        getdata()
      //  self.nsCache.setObject(UIImage(), forKey: "testKey")
       
    }
    
    
 // ************************************************************************//
//----Function isoDateFormatter to gate date and Time from Timestamp-------//
//************************************************************************//
    func isoDateFormatter() -> ISO8601DateFormatter {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime]
            //.withDashSeparatorInDate]
        return isoDateFormatter
        
    }
   
    
        
     // *****************************************************//
    //----Function Getdata For get the data from Json-------//
   //******************************************************//
       
    func getdata() {
        
            let url = URL(string : "http://files.yinzcam.com.s3.amazonaws.com/iOS/interviews/ScheduleExercise/schedule.json")
        URLSession.shared.dataTask(with: url!) { [self] (data, response, error) in
                do {
                    if (error == nil) {
                       // print(url!)
                        let Schedual = try JSONDecoder().decode(schedule.self, from: data!)
                        myTeam = Schedual.Team
                    //    myTeamName = Schedual.Team?.Name
                        self.arradata = Schedual.GameSection!
                        print(arradata.count)
                        
                        gameData = self.arradata[0].Game!
                        gameData1 = self.arradata[1].Game!
                        
                        
                       DispatchQueue.main.async() {
                        self.tbView.reloadData()
                       }
                        
                        
                        
                    }
                } catch {
                    print("Error In Json Data")
                }
            }.resume()
        }
    
    // *****************************************************//
   //--Function getImage for fetch the image from url------//
  //******************************************************//
    
    func getImage(from string: String) -> UIImage? {
        
      
        let url = URL(string: string)
          
        var image: UIImage? = nil
      
            // Get valid data
            let data = try? Data(contentsOf: url!)

            //4. Make image
        if let imagedata = data {
            image = UIImage(data: imagedata)
        }
           
        return image
    }

    
    
    
    
}
    // *******************************************************//
   //------------TableView Methods--------------------------//
  //******************************************************//
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height : CGFloat = 213
        
        
        return 213
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gameData.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
            
        let cell = tbView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell // Initialize cell
   
        cell.byeView.isHidden = true // Hide the View for Type B
        cell.CellView.isHidden = false
        
        let myTeamName = myTeam?.Name
        let myRecord = myTeam?.Record
        let mytriCode = myTeam?.TriCode
        let week = gameData[indexPath.row].Week
        let oppo_TriCode = gameData[indexPath.row].Opponent?.TriCode
        let Type = gameData[indexPath.row].Type
        let TimeStamp = gameData[indexPath.row].Date?.Timestamp
        var timeStampArr : [String.SubSequence] = []
        let oppoRecord = gameData[indexPath.row].Opponent?.Record
        
        if TimeStamp != nil {
            let realDate = isoDateFormatter().date(from: TimeStamp!)
                let str = "\(realDate!)"
                timeStampArr = str.split(separator: " ")
                cell.lbl_date.text = String(timeStampArr[0])
           // print(timeStampArr[1])
            
        }
      
    //--------load values into the cell --------------------------//
        cell.lbl_myTeamName.text = myTeamName!
        cell.lbl_OppoName.text = gameData[indexPath.row].Opponent?.Name
        cell.lbl_week.text = week
        cell.lbl_week.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        cell.lbl_myTeamName.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        cell.lbl_date.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        cell.lbl_OppoName.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    
       

        
            if Type == "F" { // check for Type
               
                cell.lbl_Final.text = gameData[indexPath.row].GameState// game - state
                // find score for both the teams
                let isHome = gameData[indexPath.row].IsHome
                let homeScore = gameData[indexPath.row].HomeScore
                let AwayScore = gameData[indexPath.row].AwayScore


                if isHome == true { // check condition for team and opponant team score
                    
                    cell.lbl_Score.text = homeScore!
                    cell.lbl_oppoScore.text = AwayScore!
                    
                    } else {
                    cell.lbl_Score.text = AwayScore!
                    cell.lbl_oppoScore.text = homeScore!
                        
                    }
                
                // ------------for image--------
                   
                   if oppo_TriCode != nil {
    /*---------------NOTE--------------------------------------------------------------------------------------
        NOTE : ------ Here for logo I am using tempString URL because Using urlString I have isuue which says access denied from s3 services.
    ---------------------------------------------------------------------------------------------------------*/
                    let urlString = "http://yc-app-resources.s3.amazonaws.com/nfl/logos/nfl_phi_\(oppo_TriCode!).png"
                    
                    let tempString = "http://yc-app-resources.s3.amazonaws.com/nfl/logos/nfl_phi_light.png"
                    
                       if let image = getImage(from: tempString) {
                           //5. Apply image
                           cell.img_oppoLogo.image = image
                        cell.img_myLogo.image = image
                       }
                   
                      
                   }
                
                
            }else if Type == "B" { // If Type  = "B"
                
                cell.byeView.isHidden = false
                cell.CellView.isHidden = true // display view for Type B
                cell.lbl_Bye.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
                
               cell.lbl_bye_2.text = gameData[indexPath.row].Week
               cell.lbl_bye_2.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)

                
            } else { // Type = "S"
                cell.lbl_Final.text = String(timeStampArr[1])
                cell.lbl_Score.text = myRecord
                cell.lbl_oppoScore.text = oppoRecord
                print(timeStampArr[1])
            }
            
            
          return cell
   
  
    }
    
    
}
