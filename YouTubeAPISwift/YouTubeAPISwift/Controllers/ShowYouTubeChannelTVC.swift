import UIKit



class ShowYouTubeChannelTVC: UITableViewController, YTPlayerViewDelegate {
    
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    // TODO: INSERT KEY
    // TODO: Manage more than 50 items (in scrollview delegate)
    // Just a TED Playlist to test
    var channelUrlString : NSString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLOGi5-fAu8bFA-gHdiQA2v_Tc4zfl72-N&key="
    var videoList : [Video] = []
    var firstVideoLoaded = false
    
    lazy var playerView : YTPlayerView = {
        // TODO: Calculate height. Different video format and terminal have different heights
        let videoView = YTPlayerView(frame: CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 220))
        videoView.tag = 110
        videoView.alpha = 0
        videoView.delegate = self
        videoView.setLoop(false)
        videoView.setShuffle(false)
        
        return videoView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension

        if let url = NSURL(string: channelUrlString){
            let downloader = CGDownloader(url)
            
            print("Downloading data")
            self.loadingActivityIndicator.startAnimating()
            
            downloader.downloadJSON({[unowned self]response in
                if let responseNotEmpty : AnyObject = response{
                    self.videoList = parseVideos(responseNotEmpty)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadingActivityIndicator.stopAnimating()
                        print("Loading data")
                        
                        self.tableView.reloadData()
                    });
                }
            })
            
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.playerView;
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.playerView.alpha == 1{
            return CGRectGetHeight(self.playerView.frame)
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCellID", forIndexPath: indexPath) as VideoCell
        cell.configureCellWithVideoData(videoList[indexPath.row])
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Video plays inline, info are not shown.
        let playerVars : NSDictionary = ["playsinline":1, "showinfo" : 0,"controls" : 1]
        let video = videoList[indexPath.row]
                
        // WebView is created at first load only
        if firstVideoLoaded == false{
            firstVideoLoaded = true
            self.playerView.alpha = 1
            self.playerView.loadWithVideoId(video.videoId,playerVars:playerVars)
        }else{
            self.playerView.cueVideoById(video.videoId, startSeconds: 0, suggestedQuality: YTPlaybackQuality.Auto)
        }
        self.tableView.reloadData()
    }
    
    // MARK: YTPlayerViewDelegate
    
    
    func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        // TODO: Error management
        println("Error: \(error.rawValue)")
    }
    
}
