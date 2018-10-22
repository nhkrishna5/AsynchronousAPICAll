//
//  ChatViewController.swift
//  Datesauce
//
//  Created by Jenish.x on 29/12/17.
//  Copyright © 2017 Tranxit. All rights reserved.
/*
 ******* SAVE Type *******
 0 for save message.
 1 for save image.
 2 for save video.
 3 for save voice.
 
 */

import UIKit
import Firebase
import AVFoundation
import QuartzCore
import MobileCoreServices
import IQKeyboardManager


struct Message {
    var message: String = ""
    var date_:String    = ""
    var userid: String  = ""
    var senderid:String = ""
    var read:String     = ""
    var Key_:String     = ""
    
    // Image...
    var MediaType:String = ""
    var MediaUrl:String   = ""
    
    // Voice...
    init(MessageType:String,message:String,date:String,senderid:String,userid:String,mediaUrl:String,read:String,key_value:String) {
        self.message     = message
        self.date_       = date
        self.senderid    = senderid
        self.userid      = userid
        self.MediaType   = MessageType
        self.MediaUrl    = mediaUrl
        self.read        = read
        self.Key_        = key_value
        }
    
}


class ChatViewController: UIViewController ,UITextViewDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,AVAudioRecorderDelegate{
    
    
    @IBOutlet weak var Scroll_view: UIScrollView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    let storage = FIRStorage.storage()
    
    let TintcolorCode = "C9CFD8"
    var messages: [Message] = []
    @IBOutlet weak var chat_tableview: UITableView!
    @IBOutlet weak var Back_button: UIButton!
    
    var Partner:MessageModel!
    var ref: FIRDatabaseReference!
    let StorageReferance:FIRStorageReference! = nil
    
    @IBOutlet weak var Smilebutton: UIButton!
    @IBOutlet weak var VideoRecButton: UIButton!
    @IBOutlet weak var Micbutton: UIButton!
    @IBOutlet weak var camerabutton: UIButton!
    @IBOutlet weak var Albumbutton: UIButton!
    @IBOutlet weak var link_button: UIButton!
    
    @IBOutlet weak var ChatTextviewContainer: UIView!
    @IBOutlet weak var ChatviewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var WriteChatTxtyview: UITextView!
    @IBOutlet weak var placeholderlbl: UILabel!
    @IBOutlet weak var sendbutton: UIButton!
    // chat.
    var UserId:String    = CommonFunctions.sharedInstance.GetuserId()
    var PartnerId:String = ""
    var ChatId:String    = "" // chat id... change later...
    
    override func viewWillAppear(_ animated: Bool) {
        
        // set partner id...
        Back_button.setTitle(Partner.titlemessage, for: .normal)
        IQKeyboardManager.shared().isEnabled          = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        //- keyboard.
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShowinLogin), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHideinLogin), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled           = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updatedesign()
        chat_tableview.rowHeight = UITableViewAutomaticDimension
        chat_tableview.estimatedRowHeight = 44.0
        
        chat_tableview.dataSource  = self
        chat_tableview.delegate    = self
        WriteChatTxtyview.delegate = self
        
        self.chat_tableview.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatSend")
        self.chat_tableview.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatReceive")
        
        self.chat_tableview.register(UINib(nibName: "Sendimageview", bundle: nil), forCellReuseIdentifier: "SendImageTableViewCell")
        self.chat_tableview.register(UINib(nibName: "Reciveimageview", bundle: nil), forCellReuseIdentifier: "ReciveImageTableViewCell")
        self.chat_tableview.register(UINib(nibName: "WaitingIndicatorTableViewCell", bundle: nil), forCellReuseIdentifier: "Waitingcell")
        
        self.chat_tableview.register(UINib(nibName: "sendervideoTableViewCell", bundle: nil), forCellReuseIdentifier: "sendervideoTableView")
        self.chat_tableview.register(UINib(nibName: "ReciverVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "ReciverVideoTableView")
        
        
        
        
        ref = FIRDatabase.database().reference()
        ReadMessagetoDatabase()
        
    }
    //MARK: update design..
    func updatedesign(){
        
        DispatchQueue.main.async {
            
            self.Smilebutton.setImage( UIImage(named: "smile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
            self.VideoRecButton.setImage( UIImage(named: "video-call")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
            self.Micbutton.setImage( UIImage(named: "microphone")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
            self.camerabutton.setImage( UIImage(named: "camera")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
            self.Albumbutton.setImage( UIImage(named: "photo")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
            self.link_button.setImage( UIImage(named: "link")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
            
            // set tint color.
            self.Smilebutton.tintColor    = CommonFunctions.sharedInstance.hexStringToUIColor(hex: self.TintcolorCode)
            self.VideoRecButton.tintColor = CommonFunctions.sharedInstance.hexStringToUIColor(hex: self.TintcolorCode)
            self.Micbutton.tintColor      = CommonFunctions.sharedInstance.hexStringToUIColor(hex: self.TintcolorCode)
            self.camerabutton.tintColor   = CommonFunctions.sharedInstance.hexStringToUIColor(hex: self.TintcolorCode)
            self.Albumbutton.tintColor    = CommonFunctions.sharedInstance.hexStringToUIColor(hex: self.TintcolorCode)
            self.link_button.tintColor    = CommonFunctions.sharedInstance.hexStringToUIColor(hex: self.TintcolorCode)
        }
        WriteChatTxtyview.autocorrectionType = .no
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.DismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    //textview
    @nonobjc internal func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        placeholderlbl.isHidden = true
        return true
    }
    
    //MARK : KEYBOARD DELEGATE.
    func keyboardWillShowinLogin(notification: NSNotification)
    {
        
        Scroll_view.isScrollEnabled = false
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        Scroll_view.contentInset = contentInsets
        Scroll_view.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if (!aRect.contains( ChatTextviewContainer.frame.origin))
        {
            if (!aRect.contains( ChatTextviewContainer.frame.origin)){
                Scroll_view.scrollRectToVisible( ChatTextviewContainer.frame, animated: true)
                
            }
        }
    }
    func keyboardWillHideinLogin(notification: NSNotification)
    {
        let contentInsets :UIEdgeInsets = .zero
        Scroll_view.contentInset = contentInsets
        Scroll_view.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        Scroll_view.isScrollEnabled = false
    }
    
    //MARK: button Action...
    @IBAction func Back_buttonActiopn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func DismissKeyboard() -> Void {
        self.WriteChatTxtyview.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:  Add Button Action....
    
    @IBAction func AddSmilybuttonAcion(_ sender: Any) {
    }
    
    @IBAction func RecordvideoButtonActiokn(_ sender: Any) {
        openVideoCamera() // for record video.
    }
    
    
    @IBAction func RecordButtonArePressedandhold(_ sender: Any) {
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
                self.RecordvoiceBite()
            } else {
                CommonFunctions.sharedInstance.displayAlertMessage(Title: NSLocalizedString("Alert", comment: ""), messageToDisplay: NSLocalizedString("Microphone access is Denied.", comment: ""), VC: self)
            }
        }
    }
    
    @IBAction func RecordviceButtonAction(_ sender: Any) { // remove record...
        audioRecorder.stop()
        audioRecorder = nil
        let RecordvoiceUrl = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        print(RecordvoiceUrl)
        
    }
    @IBAction func OpenCamera_buttonAction(_ sender: Any) {
        OpenCamera() // open camera for photo.
    }
    @IBAction func OpenGaloryButtonAction(_ sender: Any) {
        openGallary() // open galery
    }
    @IBAction func AddLink_buttonAction(_ sender: Any) {
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func RecordvoiceBite() -> Void { //Recored voice...
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        DismissKeyboard()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
        } catch {
            
        }
        
    }
    func OpenCamera() -> Void {
        DismissKeyboard()
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            CommonFunctions.sharedInstance.displayAlertMessage(Title: NSLocalizedString("Warning!", comment: ""), messageToDisplay:NSLocalizedString("You don't have camera", comment: ""), VC: self)
            
        }
    }
    
    func openVideoCamera()
    {
        DismissKeyboard()
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoQuality = UIImagePickerControllerQualityType.type640x480
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            CommonFunctions.sharedInstance.displayAlertMessage(Title: NSLocalizedString("Warning!", comment: ""), messageToDisplay:NSLocalizedString("You don't have camera", comment: ""), VC: self)
            
        }
    }
    func openGallary()
    {
        DismissKeyboard()
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    // MARK: MEDIA DELEGATE...
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            if mediaType == "public.movie" {
                
                let videoDataURL = info[UIImagePickerControllerMediaURL] as! NSURL!
                let videoFileURL = videoDataURL?.filePathURL
                
                let videoData: NSData!
                do {
                    
                    videoData = NSData(contentsOf: videoFileURL!)
                }
                
                UploadFileToFirebase(FileData: videoData as Data, Type: 2) // upload video...
                picker.dismiss(animated: true, completion: nil)
                
                
            }else if mediaType == "public.image"{
                let Image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                
                let data:Data = UIImageJPEGRepresentation(Image.resizeImage(newWidth: 200), 0.7)!
                UploadFileToFirebase(FileData: data, Type: 1)// upload IMAGE to fire base...
                picker.dismiss(animated: true, completion: nil)
                
            }
        }
        Addloaderview()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if textView.text.count > 0 // show send button.
        {
            sendbutton.isEnabled = true
            placeholderlbl.isHidden = true
            sendbutton.setImage( UIImage(named: "send"), for: .normal)
            
        }else // hide send button.
        {
            sendbutton.isEnabled = false
            placeholderlbl.isHidden = false
            sendbutton.setImage( UIImage(named: "sentdis"), for: .normal)
        }
        ChangeWriteTextView(mesage: textView.text.stringByRemovingWhitespaces)
    }
    // Increase write txt view height.
    func ChangeWriteTextView(mesage:String) -> Void {
        
        let FixedHeight = ChatviewContainerHeight.constant
        let expandheight:CGFloat = self.heightForLabel(text: mesage, width: Int(WriteChatTxtyview.frame.size.width)) - 30
        
        if (FixedHeight < 200.0 ){
            ChatviewContainerHeight.constant =  expandheight + 100
        }
        if mesage.count == 0
        {
            ChatviewContainerHeight.constant = 100
            
        }
        
    }
    
    //MARK: WRITE MESSAGE ACTION.
    @IBAction func WriteAmessagebuttonAction(_ sender: Any) {
        Addloaderview() //--- Test...
        self.WritemessagetoDatabase(message: WriteChatTxtyview.text.stringByRemovingWhitespaces, messagetype: 0, MediaUrl: "")
        WriteChatTxtyview.text = ""
        
    }
    
    //MARK: - Update value to firebase.
    func Updatefirebase(message:String,fir_key:String) -> Void {
      let userref = self.ref.child(ChatId).child(fir_key)
        userref.updateChildValues(["read":message])
    }
    
    // MARK: - write message.
    func WritemessagetoDatabase(message:String,messagetype:Int,MediaUrl:String) -> Void {
        var MessageType:String = ""
        SendPushtoPartner(Par_id: PartnerId, message: message) // send push notificati
        WriteChatTxtyview.resignFirstResponder()  // dismiss keyboard.
        switch messagetype {
        case 0:
            MessageType = "text"
            break
        case 1:
            MessageType = "image"
            break
        case 2:
            MessageType = "video"
            break
        case 3:
            MessageType = "voice"
            break
        default:
            break
        }
        
        var messagedic:[String:Any] = [String:Any]()
        messagedic["type"]  = MessageType  // message -> type
        
        let timestamp = Date().timeIntervalSince1970
        
        messagedic["text"]       = message
        messagedic["timestamp"]  = "\(timestamp)"
        messagedic["sender"]     = PartnerId
        messagedic["user"]       = UserId
        messagedic["url"]        = MediaUrl
        messagedic["read"]       = "0"
        let key = ref.childByAutoId().key
        self.ref.child(ChatId).child(key).setValue(messagedic)
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            
        })
    }
    
    //MARK: UPLOAD FILE TO FIREBASE..
    func UploadFileToFirebase(FileData:Data,Type:Int) -> Void {
        
        var UpliadfileType:String = ""
        
        let filename:String = "\(ChatId)\(NSDate())".stringByRemovingALLWhitespaces
        
        switch Type {
            
        case 1:
            UpliadfileType = "\(filename).jpg" // image..
            break
        case 2:
            UpliadfileType = "\(filename).mp4" // may change later formet mp4 -> ????
            break
        case 3:
            UpliadfileType = "\(filename).mp3" // may change later formet mp3 -> ????
            break
        case 4: // link.
            
            break
        case 5: //. emoj
            break
            
        default:
            break
        }
        
        let storageRef = storage.reference().child(UpliadfileType); // set type....
        _=storageRef.put(FileData, metadata: nil)
        { metadata, error in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("Print upload file error: \(error)")
                
            } else {
                let downloadURL = metadata!.downloadURL()
                print("Storage Location:\(downloadURL!)")
                print("Storage Location:\(metadata!.path!)")
                print("Storage Location:\(metadata!.name!)")
                
                let imageurl = "\(metadata!.downloadURL()!)" + "\(metadata!.name!)"
                //print("Saved image path == > \(imageurl)")
                
                self.WritemessagetoDatabase(message: "", messagetype: Type, MediaUrl: "\((imageurl))") // -> save Text , Image ,Video ,Voice.
            }
        }
    }
    
    //MARK: - Read message from data base.
    func ReadMessagetoDatabase() -> Void {
        
        ref.child(ChatId).observe(.value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                self.messages.removeAll()
                let sorted = ((snapshot.value! as AnyObject).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: "timestamp",ascending: false)])
                
                let allKeys:[String] = (snapshot.value! as AnyObject).allKeys as! [String]
                for (index,element) in sorted.enumerated() {
                    
                    let key:String       = allKeys[index]
                    
                    let message:String   = ((element as AnyObject)["text"]! as? String)!
                    let datevalue:String = ((element as AnyObject)["timestamp"]! as? String)!
                    let userid:String    = ((element as AnyObject)["user"]! as? String)!
                    let Senderid:String  = ((element as AnyObject)["sender"]! as? String)!
                    let Mediaurl:String  = ((element as AnyObject)["url"]! as? String)!
                    let Read:String      = ((element as AnyObject)["read"]! as? String)!
                    
                                        // Type...
                    let MessageType:String  = ((element as AnyObject)["type"]! as? String)!
                    
                    let m = Message(MessageType: MessageType, message: message, date: datevalue, senderid: Senderid, userid: userid, mediaUrl: Mediaurl, read: Read, key_value: key)
                    self.messages.append(m)
                }
                
                if self.messages.count > 0
                {
                    
                    DispatchQueue.main.async(execute: {
                        self.messages.reverse() // Revers message...
                        self.chat_tableview.reloadData()
                        if self.messages.count < 2{return}
                        self.chat_tableview.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
                    })
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    //MARK: Calculate height...
    func heightForLabel(text:String,width:Int) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = text
        label.sizeToFit()
        return label.frame.height + 35
    }
    
}

//MARK: extension TABLEVIEW..
extension ChatViewController: UITableViewDataSource ,UITableViewDelegate {
    
    // MARK: Tableview Datasource...
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messagemodel:Message = messages[indexPath.row]
        
        if messagemodel.senderid != PartnerId   //Load right side cell
        {
            if messagemodel.Key_.count > 2
            {
                self.Updatefirebase(message: "1", fir_key: messagemodel.Key_)

            }
            switch messagemodel.MediaType {
                
            case "text":
                // # Text message....
                let cell_Recive = tableView.dequeueReusableCell(withIdentifier: "chatReceive", for: indexPath) as! ChatTableViewCell
                cell_Recive.chatMessageLabel.text = messagemodel.message
                cell_Recive.chatTimeLabel.text    = CommonFunctions.sharedInstance.relativePast(for: CommonFunctions.sharedInstance.convertToDate(dateString: messagemodel.date_))
                
                cell_Recive.chatUserImage.sd_setImage(with: URL(string:Partner.image_url), placeholderImage: UIImage(named: "nouser"))
                //cell_Recive.chatNameLabel.text = ""
                cell_Recive.chatUserImage.sd_setShowActivityIndicatorView(true)
                cell_Recive.chatUserImage.sd_setIndicatorStyle(.gray)
                cell_Recive.authorType            = .iMessageBubbleTableViewCellAuthorTypeReceiver
                return cell_Recive
                
            case "image":
                
                let Recivecell = tableView.dequeueReusableCell(withIdentifier: "ReciveImageTableViewCell", for: indexPath) as! ReciveImageTableViewCell
                Recivecell.AviaterImage.sd_setImage(with: URL(string:Partner.image_url), placeholderImage: UIImage(named: "nouser"))
                Recivecell.AviaterImage.sd_setShowActivityIndicatorView(true)
                Recivecell.AviaterImage.sd_setIndicatorStyle(.gray)
                
                Recivecell.ReciveShowImageView.sd_setImage(with: URL(string:messagemodel.MediaUrl.stringByRemovingALLWhitespaces), completed: nil)
                Recivecell.ReciveShowImageView.sd_setShowActivityIndicatorView(true)
                Recivecell.ReciveShowImageView.sd_setIndicatorStyle(.gray)
                
                Recivecell.contentView.setNeedsLayout()
                Recivecell.contentView.layoutIfNeeded()
                return Recivecell
            case "video":
                
                let ReciveVideoCell = tableView.dequeueReusableCell(withIdentifier: "ReciverVideoTableView", for: indexPath) as! ReciverVideoTableViewCell
                ReciveVideoCell.AviaterImageview.sd_setImage(with: URL(string:Partner.image_url), placeholderImage: UIImage(named: "nouser"))
                ReciveVideoCell.AviaterImageview.sd_setShowActivityIndicatorView(true)
                ReciveVideoCell.AviaterImageview.sd_setIndicatorStyle(.gray)
                
                ReciveVideoCell.SetVieoUrl(videoUrl:messagemodel.MediaUrl.stringByRemovingALLWhitespaces, viewController: self)
                ReciveVideoCell.contentView.setNeedsLayout()
                ReciveVideoCell.contentView.layoutIfNeeded()
                
                return ReciveVideoCell
                
            case "loading":
                
                let Waiting = tableView.dequeueReusableCell(withIdentifier: "Waitingcell", for: indexPath) as! WaitingIndicatorTableViewCell
                let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "loading", withExtension: "gif")!)
                let advTimeGif = UIImage.sd_animatedGIF(with: imageData)
                Waiting.Loadingimage.image = advTimeGif
                return Waiting
                
            default:
                break
            }
            return UITableViewCell()
        }else // load left side cell...
        {
            switch messagemodel.MediaType {
            case "text":
                
                // # Text message ....
                let cell_send = tableView.dequeueReusableCell(withIdentifier: "chatSend", for: indexPath) as! ChatTableViewCell
                cell_send.chatMessageLabel.text = messagemodel.message
                cell_send.chatTimeLabel.text    = CommonFunctions.sharedInstance.relativePast(for: CommonFunctions.sharedInstance.convertToDate(dateString: messagemodel.date_))
                cell_send.chatUserImage.sd_setImage(with: URL(string:CommonFunctions.sharedInstance.getUserImageUrl()), placeholderImage: UIImage(named: "nouser"))
                cell_send.chatUserImage.sd_setShowActivityIndicatorView(true)
                cell_send.chatUserImage.sd_setIndicatorStyle(.gray)
                cell_send.authorType            = .iMessageBubbleTableViewCellAuthorTypeSender

                return cell_send
                
            case "image":
                
                // # Image ....
                let SendImageCell = tableView.dequeueReusableCell(withIdentifier: "SendImageTableViewCell", for: indexPath) as! SendImageTableViewCell
                
                SendImageCell.AviaterImage.sd_setImage(with: URL(string:CommonFunctions.sharedInstance.getUserImageUrl()), placeholderImage: UIImage(named: "placeholder.jpg"))
                SendImageCell.AviaterImage.sd_setShowActivityIndicatorView(true)
                SendImageCell.AviaterImage.sd_setIndicatorStyle(.gray)
                
                SendImageCell.ShowImageView.sd_setImage(with: URL(string:messagemodel.MediaUrl.stringByRemovingALLWhitespaces), completed: nil)
                SendImageCell.ShowImageView.sd_setShowActivityIndicatorView(true)
                SendImageCell.ShowImageView.sd_setIndicatorStyle(.gray)
                
                SendImageCell.contentView.setNeedsLayout()
                SendImageCell.contentView.layoutIfNeeded()
                
                return SendImageCell
            case "video":
                
                let SendVideoCell = tableView.dequeueReusableCell(withIdentifier: "sendervideoTableView", for: indexPath) as! sendervideoTableViewCell
                
                SendVideoCell.aviater_imageview.sd_setImage(with: URL(string:CommonFunctions.sharedInstance.getUserImageUrl()), placeholderImage: UIImage(named: "placeholder.jpg"))
                SendVideoCell.aviater_imageview.sd_setShowActivityIndicatorView(true)
                SendVideoCell.aviater_imageview.sd_setIndicatorStyle(.gray)
                
                SendVideoCell.SetVieoUrl(videoUrl: messagemodel.MediaUrl.stringByRemovingALLWhitespaces, viewController: self)
                SendVideoCell.contentView.setNeedsLayout()
                SendVideoCell.contentView.layoutIfNeeded()
                
                return SendVideoCell
                
            case "loading":
                
                let Waiting = tableView.dequeueReusableCell(withIdentifier: "Waitingcell", for: indexPath) as! WaitingIndicatorTableViewCell
                let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "loading", withExtension: "gif")!)
                let advTimeGif = UIImage.sd_animatedGIF(with: imageData)
                Waiting.Loadingimage.image = advTimeGif
                return Waiting
                
            default:
                break
            }
            
            // # Text Video....
            return UITableViewCell()
        }
        
    }
    
    
    //MARK: ADD LOADER ...
    func Addloaderview() -> Void {
        
        let m = Message(MessageType: "loading", message: "", date: "", senderid: "", userid: "", mediaUrl: "", read: "", key_value: "")
        self.messages.insert(m, at: self.messages.count)
        
        if self.messages.count > 0
        {
            DispatchQueue.main.async {
                self.chat_tableview.reloadData()
                if self.messages.count == 0 || self.messages.count == 1  {return}
                self.chat_tableview.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false) }
        }
    }
    
    
    //MARK: tableview height...
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let messagemodel:Message = messages[indexPath.row]
        
        switch messagemodel.MediaType {
        case "text":
            let messageStr = messagemodel.message
            let dateSt = messagemodel.date_
            
            let width:Int     = Int(self.view.frame.size.width - self.view.frame.size.width / 3)
            let Messageheight = self.heightForLabel(text: messageStr, width: width)
            let dateHeight    = self.heightForLabel(text: dateSt, width: width)
            
            return Messageheight + dateHeight
            
        case "image":
            return self.view.frame.size.width - 100
        case "video":
            return self.view.frame.size.width - 100
        case "voice":
            return 100
        case "loading":
            return 100
        default:
            break
        }
        return 0
    }
    
    //MARK: Push notification.
    func SendPushtoPartner(Par_id:String,message:String) -> Void {
        
        if message.count < 10 {return}
        let Url_:String = CommonAPIs.API_BASE + CommonAPIs.API_Sendpush
        let parameter:[String:Any] = ["sender_id":Par_id,"message":message]
        WebServices.sharedInstance.Postmethodforgetserverdata(url: Url_, viewControll: self, parameters: parameter) { (Responcedata, StatusCode) in
            
            if Responcedata.count == 0{return}
            if StatusCode == 200
            {
                print("Push responce:\(Responcedata)")
                
                
            }
        }
    }
}


