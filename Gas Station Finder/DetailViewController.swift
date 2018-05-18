//
//  DetailViewController.swift
//  Gas Station Finder
//
//  Created by crow on 17/5/18.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var banner: SMCycleBannerView!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var detailTV: UITextView!
    @IBOutlet weak var visitLbl: UILabel!
    var data: GasStation?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.banner.initCycleBanner()
        self.banner.configureTimeInterval(timeInterval: 4.0)
        self.banner.configureImageViews(
            getImageList(),
            autoScroll: true,
            didClickEventClosure: nil)
        
        self.title = data?.name
        self.addressLbl.text = data?.address
        self.visitLbl.text = "Visit Times:\(COMMON.visitArray[index!])"
        self.detailTV.text = data?.detail
        self.logoIV.image = UIImage(data: data?.logo! as! Data)
    }

    // set image list to banner
    func getImageList() -> [UIImage] {
        var images = [UIImage]()
        
        for d in data?.photos as! [Data] {
            images.append(UIImage(data: d)!)
        }
        return images
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
