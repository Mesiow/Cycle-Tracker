//
//  CycleTrackerCoreData.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/14/24.
//

import Foundation
import CoreData
import UIKit

struct CoreDataContext {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
}

extension RidesViewController {
    func saveRideData() {
        do {
            try CoreDataContext.context.save();
        }catch {
            print("(Core data) Error saving session \(error)");
        }
    }
    
    func fetchRideData(with request: NSFetchRequest<Ride> = Ride.fetchRequest()){
        //sort data by date (newest entry at the top)
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false);
        let sortDescriptors = [dateSortDescriptor];
        request.sortDescriptors = sortDescriptors; //set the sort descriptor in our request
        
        do {
            rides = try CoreDataContext.context.fetch(request);
            if(rides.count <= 0){
                print("no rides available");
            }
        }catch{
            print("Error loading rides from core data \(error)");
        }
    }
    
    func reloadRideData(){
        saveRideData();
        fetchRideData();
    }
    
    func deleteRideFromTable(at indexPath: IndexPath){
        CoreDataContext.context.delete(rides[indexPath.row]); //implicity saves the changes of deletion to core data
        reloadRideData();
    }
    
}

extension CurrentRideVC {
    func saveRideData() {
        do {
            try CoreDataContext.context.save();
        }catch {
            print("(Core data) Error saving session data \(error)");
        }
    }
}

