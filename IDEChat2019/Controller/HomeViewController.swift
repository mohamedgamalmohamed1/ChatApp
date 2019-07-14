//
//  HomeViewController.swift
//  IDEChat2019
//
//  Created by mohamed gamal mohamed on 6/14/19.
//  Copyright © 2019 mohamed gamal mohamed. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var rooms:[Room] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
      loadRooms()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = self.rooms[indexPath.row]
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        view.room = room
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomNameCellTableViewCell") as! RoomNameCellTableViewCell
        cell.nameLabel.text = room.roomName
        return cell 
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func loadRooms(){
        let database = Database.database().reference()
        database.child("Rooms").observe (.childAdded){ (response) in
            
            if let responseData = response.value as? [String:Any]{
                guard let roomName = responseData["name"] as? String else {
                    return
                }
                let room = Room.init(roomID: response.key, roomName: roomName)
                self.rooms.append(room)
                self.tableView.reloadData()
            }
            
            print("i found a room .. ")
            print(response.value)
        }
    }
    
    func getUserName(){
        let uid = Auth.auth().currentUser?.uid
        let database = Database.database().reference()
        database.child("Users").child(uid!).child("username").observeSingleEvent(of: .value) { (response) in
            print(response.value)
        }
    
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
       try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressAddChatRoom(_ sender: Any) {
        let alert = UIAlertController(title: "Create Chat Room", message: "please enter your chat room name", preferredStyle: .alert)
        
            let addButton = UIAlertAction(title: "Add", style: .cancel) { (alertx) in
                guard  let roomName = alert.textFields![0].text else{
                    return
                }
                self.createChatRoom(name: roomName)
        }
            let dismissButton = UIAlertAction(title: "cancel", style: .destructive) { (alert) in
                print("Jeeem")
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Room name"
        }
        
        alert.addAction(addButton)
        alert.addAction(dismissButton)
        self.present(alert, animated: true, completion: nil)
    }
    func createChatRoom(name:String){
        let roomData:[String:String] = ["name":name]
        let database = Database.database().reference()
        database.child("Rooms").childByAutoId().setValue(roomData)
    }
    
}
