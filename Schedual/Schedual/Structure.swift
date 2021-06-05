//
//  Structure.swift
//  Schedual
//
//  Created by Dharti Savaliya on 5/11/21.
//

import Foundation

//------------Structure for Json Data ------------------------------------
    

struct schedule : Codable {
    let Team : Team?
    let GameSection : [GameSection]?
    let DefaultGameId : String?
    
    
}
struct  Team : Codable{
        let TriCode : String?
        let Name : String?
        let Record : String?
    }

struct GameSection : Codable {
     
    let Game : [Game]?
    let Heading : String?
    
    
}

struct Game : Codable {
    
    let Week : String
    let GameState : String?
    let `Type` : String?
    let Date : Date?
    let Opponent : Opponent?
    let AwayScore : String?
    let HomeScore : String?
    let IsHome : Bool?
   
    
}
struct Date : Codable {
    
    let Text : String?
    let Time : String?
    let Timestamp : String
}

struct Opponent : Codable {
    
    let TriCode : String
    let Name : String?
    let Record : String?
    
}
    


    

