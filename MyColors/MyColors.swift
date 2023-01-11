//
//  MyColors.swift
//  MyColors
//
//  Created by Rand Alhassoun on 05/01/2023.
//

import SwiftUI
import Accessibility

struct MyColors: View {
    @EnvironmentObject var manager: dataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var savedColors: FetchedResults<SavedColors>
    
    
    //color picker values
    @State var showPicker: Bool = false
    @State var selectedColor: Color = .white
    
    @State var showImagePicker: Bool = false
    @State var showMyColors: Bool = false

    //==================================================================
    @State private var sourceType : UIImagePickerController.SourceType = .camera
    @State private var sourceType2 : UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    
    
    @State private var isImagePickerDisplay = false
    @State private var showCamera = false
    
    @State private var SearchText = ""
    //==================================================================

  //  @State private var cancelPic = false
        @State var showOnboarding: Bool = true
    //show page with grayscale
    @State private var showGrayScale = false
    
    
    var body: some View {
      
        NavigationView {
          
            VStack{
                
                Toggle("Show gray scale", isOn: $showGrayScale)
                               .toggleStyle(SwitchToggleStyle(tint: Color("appColor")))
                               .padding(.horizontal)

                
            //the buttons
                VStack{
                    HStack{
                      
                        //select photo button
                        Button{
                            self.sourceType2 = .photoLibrary
                            self.isImagePickerDisplay.toggle()
                            //   showImagePicker.toggle()
                            
                        }label: {
                            HStack {
                                Image(systemName: "photo")
                                    .font(.title3)
                                VStack{
                                    Text("Photos")
                                        .font(.title3)
                                        .bold()
                                        .accessibilityLabel("Photos")
                                }//v
                            }//h
                            
                        }
                        .frame(width: 150, height: 50 )
                        .padding()
                        .accentColor(.white)
                        .background(Color("appColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
                        
                        
                        //.frame(maxWidth: 200.0)
                        //.padding()
                        
                        
                        .imageColorPicker(showPicker: $showPicker, color: $selectedColor,showImagePicker: $showImagePicker,selectedImage: $selectedImage)
                        
                        
                        // show the sheet for both button (camera and photolibrary
                        .sheet(isPresented: self.$isImagePickerDisplay) {
                            if selectedImage != nil {
                                showPicker.toggle()}
                        }
                    content: {
                        ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType2)
                    }
                        
                        Button {
                            self.sourceType = .camera
                            self.showCamera.toggle()
                            
                            
                        }label: {
                            HStack {
                                Image(systemName: "camera")
                                    .font(.title3)
                                    .bold()

                                VStack{
                                    Text("Camera")
                                        .font(.title3)
                                        .bold()
                                        .accessibilityLabel("Camera")

                                    //                        Text("add from cam")
                                    //                            .font(.caption)
                                }//v
                            }//h
                        }
                        .frame(width: 150, height: 50 )
                        .padding()
                        .accentColor(.white)
                        .background(Color("appColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
                        //.frame(maxWidth: 200.0)
                        //.padding()
                        
                        .imageColorPicker(showPicker: $showPicker, color: $selectedColor, showImagePicker: $showImagePicker, selectedImage: $selectedImage)
                        
                        
                        // show the sheet for both button (camera and photolibrary
                        .sheet(isPresented: self.$showCamera) {
                            if selectedImage != nil {
                                showPicker.toggle()}
                        }
                    content: {
                        ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                    }
                        
                     
                    }//hh
                    
                    //show the selected color
                    //            Circle()
                    //                .fill(selectedColor)
                    //                .frame(width:100,height:50)
    //
    //                Button{
    //                    showMyColors.toggle()
    //                } label: {
    //                    VStack{
    //                        Text("My colors")
    //                        Image(systemName: "chevron.down")
    //                    }
    //                }
    //                .sheet(isPresented: $showMyColors){}
    //            content: { MyColors()}
    //
                    //
                }.padding()
                
            
            //the coreData is empty
            if savedColors.isEmpty {
                Spacer()
                Text("No saved colors")
                    .font(.title)
                    .bold()
                Text("Add your colors from Camera or Photo library.")
                    .padding(10)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                    .navigationTitle("My Colors")
                
            }
            
            //the list for saved colors
            else {
                Text("").accessibilityHint("saved colors")
//                    .accessibilityLabel("saved colors")
                List {
//                    Section (header: Text ("Saved colors")) {
                        
                        ForEach(savedColors) { item in
                            HStack{
                                //show the selected color
                                
                                Circle()
                                    .fill(Color(hex: item.hexValue ?? "no color") ?? .white)
                                    .frame(width:73,height:73)
                                VStack(alignment: .leading){
                                    
                                    Text(item.colorName ?? "No Name" )
                                    
                                    //  .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
                                    Text(item.hexValue ?? "no value")
                                }
                                //.accessibilityLabel("saved color")
                                
                                Spacer()
                                // copy button
                                Button(action: {
                                    UIPasteboard.general.string = item.hexValue
                                }) {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(Color("appColor"))
                                }                                    .accessibilityLabel("Copy Hex value")
                                
                                
                                
                                    .frame(width:36,height:36)
                            }
                            //                        .accessibilityHint(Text("saved color"))
                            //                        .accessibilityLabel("saved color")
                            
                        } .onDelete(perform: deleteColor)
                        //.accessibilityLabel("saved color")
                        
    


                }
                .accessibilityHint(Text("saved color"))

//                .accessibilityHint("hi")
                .accessibilityLabel("saved color")

            
                .navigationTitle("My Colors")
                
            }
        }//v
            .saturation(showGrayScale ? 0 : 1)
        }.sheet(isPresented: $showOnboarding){} content: {onBoardingView(showOnboarding: $showOnboarding)}
            .searchable(text: $SearchText, prompt: "Search color" )
        

       
    }
    
//
//    var searchResults: [savedColors]{
//        if SearchText.isEmpty {
//            return savedColors
//        } else {
//            return savedColors.filter($0.name.contains(SearchText))
//        }
//    }
    
    //delete the color from coreData
    func deleteColor(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let item = savedColors[offset]
            
            // delete it from the context
            viewContext.delete(item)
        }
        try? viewContext.save()
        
        
    }
    
}


//on boarding
struct onBoardingView: View {
    @Binding var showOnboarding: Bool
    var body: some View {
        VStack(){
            Image("myColorIcon")
                .resizable()
                .frame(width: 75,height: 75)
            Text("onBoardingWelcome")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold()
                .frame(width: 300,height: 50
                )
            
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "paintpalette")
                        .resizable()
                        .frame(width: 30,height: 30)
                        .foregroundColor(Color("appColor"))
                    VStack(alignment: .leading){
                        Text("My colors")
                            .font(.title3).bold()
                            .padding(.bottom, 5.0)
                        Text("myColorDesc")
                            .font(.caption)
                        
                    }.padding(.horizontal, 30.0)
                }.padding(.vertical)
                
                
                HStack{
                    Image(systemName: "eyedropper.halffull")
                        .resizable()
                        .frame(width: 30,height: 30)
                        .foregroundColor(Color("appColor"))
                    VStack(alignment: .leading){
                        Text("Color picker")
                            .font(.title3).bold()
                            .padding(.bottom, 5.0)
                        Text("CPDesc")
                            .font(.caption)
                        
                    }.padding(.horizontal, 30.0)
                }.padding(.vertical)
                
                HStack{
                    Image(systemName: "eye")
                        .resizable()
                        .frame(width: 35,height: 25)
                        .foregroundColor(Color("appColor"))
                      
                    VStack(alignment: .leading){
                        Text("Vision")
                            .font(.title3).bold()
                            .padding(.bottom, 5.0)
                        Text("visionDesc")
                            .font(.caption)
                        
                    }.padding(.horizontal, 30)
                }.padding(.vertical)
                
            }.padding()
                
          

            
            RoundedRectangle(cornerRadius: 9)
                .fill(Color("appColor"))
                .overlay(){
                    Button {
                        showOnboarding.toggle()
                    } label: {
                        Text("Get started")
                    }
                  
                }
                .frame(width: 300,height: 45)
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding(.top, 50.0)
                
        }
    }
}


struct MyColors_Previews: PreviewProvider {
    static var previews: some View {
        MyColors()
    }
}
