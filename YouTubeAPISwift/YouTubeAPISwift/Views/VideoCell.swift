import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!

    //    lazy var publishedDateFormatter : NSDateFormatter = {
    //        let rfc3339DateFormatter = NSDateFormatter()
    //        let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    //
    //        rfc3339DateFormatter.locale = enUSPOSIXLocale
    //        rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'sss'Z'"
    //        return rfc3339DateFormatter
    //    }()
    //
    //    lazy var cellPublishedDateFormatter : NSDateFormatter = {
    //        let formatter = NSDateFormatter()
    //        formatter.locale = NSLocale.currentLocale()
    //        formatter.dateStyle = .MediumStyle
    //        formatter.timeStyle = .ShortStyle
    //        return formatter
    //    }()
    
    
    func configureCellWithVideoData(video : Video){
        self.videoTitle.text = video.videoTitle
        if let url = NSURL(string: video.imageUrlString){
            let downloader = CGDownloader(url)
            downloader.downloadUrl({[unowned self] location in
                if let imageData = NSData(contentsOfURL: location! as NSURL){
                    if let videoImage = UIImage(data: imageData){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.videoThumbnail.image = videoImage
                        })
                    }
                }
                
            })
        }
        //        let publishedDate = self.publishedDateFormatter.dateFromString(video.publishedDateString)
        //
        //        if publishedDate == nil {
        //            cell.dateDescription.text = ""
        //        }else{
        //            let dateString = self.cellPublishedDateFormatter.stringFromDate(publishedDate!)
        //            cell.dateDescription.text = dateString
        //        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
