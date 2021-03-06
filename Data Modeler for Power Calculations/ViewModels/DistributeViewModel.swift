//
//  DistributeViewModel.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/6/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

class DistributeViewModel: ObservableObject {
    @Published var items:[AssignData] = []
    
    func addLines(inputArray: [InputData], blockingArray: [InputData]) {
        self.items.removeAll()
        var assignBlockArray = [String]()
        for _ in 0..<blockingArray.count {
            assignBlockArray.append("")
        }
        for i in 0..<Int(inputArray[0].value)! {
            self.items.append(AssignData(id: i, subjectNum: i + 1, treatmentNum: "", blockFacs: assignBlockArray, dvVal: ""))
        }

    }
    
    func addDV(dvArray: [String]) {
        for i in 0..<dvArray.count {
            self.items[i].dvVal = dvArray[i]
        }
    }
    
    func bindingTN(for index: Int) -> Binding<String> {
        Binding( get: {self.items[index].treatmentNum},
                 set: {self.items[index].treatmentNum = $0}
        )
    }
    
    func bindingBF(for subject: Int) -> Binding<[String]> {
        Binding( get: {self.items[subject].blockFacs},
                 set: {self.items[subject].blockFacs = $0}
        )
    }
    
}
