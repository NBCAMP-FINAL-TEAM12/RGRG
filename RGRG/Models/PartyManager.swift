//
//  PartyManager.swift
//  RGRG
//
//  Created by (^ㅗ^)7 iMac on 10/27/23.
//

import FirebaseFirestore
import Foundation

class PartyManager {
    static let shared = PartyManager()
    static let db = Firestore.firestore()

    func loadParty(completion: @escaping ([PartyInfo]) -> Void) {
        PartyManager.db.collection("party")
            .addSnapshotListener { (querySnapshot, error) in
                var partyList: [PartyInfo] = []

                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        print("### snapshotDocument \(snapshotDocument)")
                        for doc in snapshotDocument {
                            let data = doc.data()
                            let thread = doc.documentID

                            if let champions = data["champions"] as? [String], let content = data["content"] as? String, let date = data["date"] as? String, let hopePosition = data["hopePosition"] as? [String: String], let profileImage = data["profileImage"] as? String, let tier = data["tier"] as? String, let title = data["title"] as? String, let userName = data["userName"] as? String, let writer = data["writer"] as? String, let position = data["position"] as? String{
                                let party = PartyInfo(champion: champions, content: content, date: date, hopePosition: hopePosition, profileImage: profileImage, tier: tier, title: title, userName: userName, writer: writer, position: position)
                                partyList.append(party)
                                
                            }
                        }
                        completion(partyList)
                    }
                }
            }
    }

    func addParty(party: PartyInfo, completion: @escaping (PartyInfo) -> Void) {
        PartyManager.db.collection("party")
            .addDocument(data: [
                "champions": party.champion,
                "content": party.content,
                "date": party.date,
                "hopePosition": party.hopePosition,
                "profileImage": party.profileImage,
                "tier": party.tier,
                "title": party.title,
                "userName": party.userName,
                "writer": party.writer,
                "requester": party.requester,
                "position": party.position
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    let party = PartyInfo(champion: party.champion, content: party.content, date: party.date, hopePosition: party.hopePosition, profileImage: party.profileImage, tier: party.tier, title: party.title, userName: party.userName, writer: party.writer, position: party.position)
                    completion(party)
                }
            }
    }
}
