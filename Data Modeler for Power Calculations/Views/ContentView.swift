//
//  ContentView.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var inputViewModel = InputViewModel()
    @ObservedObject var treatmentViewModel = TreatmentViewModel()
    @ObservedObject var blockingViewModel = BlockingViewModel()
    @ObservedObject var errorViewModel = ErrorViewModel()
    @ObservedObject var modelingViewModel = ModelingViewModel()
    @ObservedObject var distributeViewModel = DistributeViewModel()
    @State var labelShown = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                VStack {
                    Text("Step 1: Enter inputs:")
                    ForEach(self.inputViewModel.items.indices, id: \.self) { index in
                        InputView(item: self.inputViewModel.items[index], itemValue: self.inputViewModel.binding(for: index))
                    }
                    Button(action: {
                        self.treatmentViewModel.items.removeAll()
                        self.blockingViewModel.items.removeAll()
                        self.treatmentViewModel.addTreatments(count: Int(self.inputViewModel.items[1].value) ?? 0)
                        self.blockingViewModel.addBlocking(count: Int(self.inputViewModel.items[2].value) ?? 0)
                        
                    }) {
                        Text(/*@START_MENU_TOKEN@*/"Continue"/*@END_MENU_TOKEN@*/)
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 2: Enter blocking factor labels and values (if applicable):")
                    ForEach(self.blockingViewModel.items.indices, id: \.self) { index in
                        BlockingInputView(itemName: self.blockingViewModel.bindingName(for: index), itemValue: self.blockingViewModel.bindingVal(for: index))
                    }
                    Button(action: {
                        self.errorViewModel.items.removeAll()
                        self.errorViewModel.items.append(InputData(id: 0, label: "Total Error SD:", value: ""))
                        self.errorViewModel.addErrors(array: self.blockingViewModel.items)
                    }) {
                        Text(/*@START_MENU_TOKEN@*/"Continue"/*@END_MENU_TOKEN@*/)
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 3: Enter errors:")
                    ForEach(self.errorViewModel.items.indices, id: \.self) { index in
                        InputView(item: self.errorViewModel.items[index], itemValue: self.errorViewModel.binding(for: index))
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 4: Enter treatment means:")
                    ForEach(self.treatmentViewModel.items.indices, id: \.self) { index in
                        InputView(item: self.treatmentViewModel.items[index], itemValue: self.treatmentViewModel.binding(for: index))
                    }
                    Button(action: {
                        self.modelingViewModel.blockText = ""
                        self.modelingViewModel.prepareBlockErrorText(errorArray: self.errorViewModel.items, blockingArray: self.blockingViewModel.items)
                        self.distributeViewModel.items.removeAll()
                        self.distributeViewModel.addLines(inputArray: self.inputViewModel.items, blockingArray: self.blockingViewModel.items)
                        self.labelShown = true
                    }) {
                        Text("Continue")
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 5: Distribute groups ->")
                    }
                    
                }
            }
            Spacer()
            Divider().background(Color.black)
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Text(inputViewModel.items[3].value)
                    Text("Treatment")
                        .padding(.trailing)
                    ForEach(self.blockingViewModel.items.indices, id: \.self) { index in
                        Text(self.blockingViewModel.items[index].label).padding(.trailing)
                    }
                    Spacer()
                        .frame(width: 15.0)
                }.opacity(labelShown ? 1 : 0)
                ScrollView {
                    ForEach(self.distributeViewModel.items.indices, id: \.self) { index in
                        GridView(input: self.distributeViewModel.items[index], assignTNum: self.distributeViewModel.bindingTN(for: index), assignBArray: self.distributeViewModel.bindingBF(for: index))
                    }
                }
                Spacer()
                Button(action: {
                    print(self.distributeViewModel.items)
                }) {
                    Text("Test")
                }
                Text(modelingViewModel.blockText)
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}