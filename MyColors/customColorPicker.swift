//
//  customColorPicker.swift
//  MyColors
//
//  Created by roba on 05/01/2023.
//

import SwiftUI
import PhotosUI

// making extention to call the color picker
extension View{
    func imageColorPicker(showPicker: Binding<Bool>,color: Binding<Color>,showImagePicker: Binding<Bool>,selectedImage: Binding<UIImage?> )->some View{
        return self
        
        //full sheet
            .fullScreenCover(isPresented: showPicker){
            }
    content: {
        Helper(showPicker: showPicker, color: color,showImagePicker: showImagePicker, selectedImage: selectedImage)
    }
    }
}

//custom view for color picker
struct Helper: View{
       @EnvironmentObject var manager: dataManager
       @Environment(\.managedObjectContext) private var viewContext
    //   @FetchRequest(sortDescriptors: []) private var savedColors: FetchedResults<SavedColors>
    
    @Binding var showPicker: Bool
    @Binding var color: Color
    
    //show selected image
    @Binding var showImagePicker: Bool
    @Binding var selectedImage: UIImage?

    @State var colorName: String = ""
    
    //the alert to edit name
    @State private var presentAlert = false
    
    //the alert to continue picking colors
    @State private var continueColor = false
    
    var body: some View{
        NavigationView{
            ZStack{
                VStack(){
                    //image picker view
                    GeometryReader{proxy in
                        
                        let size = proxy.size
                        
                        VStack() {
                            
                           // if let image = UIImage(data: imageData){
                            if let image = selectedImage{
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: size.width,height: size.height)
                                
                                
                            }
                       
                        }
                     
                    } .ignoresSafeArea()
                    
                }
                
                //the selected color
             //   if selectedColor == false{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.gray), lineWidth: 0.5)
                            .background(.white)
                        HStack{
                            //show the selected color
                            Circle()
                                .fill(color)
                                .frame(width:84,height:84)
                            VStack(alignment: .leading){
                                //shoe hex value of color
                                Text ("#"+(color.toHex() ?? "N/A"))
                                    .font (.system(size: 27))
                                // .padding(.vertical, 3.0)
                                
                                //RGB values
                                HStack{
                                        Text("R:"+"\(String(format: "%.0f", color.components.red))")
                                            .foregroundColor(.red)
                                 
                                        Text("G:"+"\(String(format: "%.0f", color.components.green))")
                                            .foregroundColor(.green)
                               
                                        Text("B:"+"\(String(format: "%.0f", color.components.blue))")
                                            .foregroundColor(.blue)
                                }
                                .font(.system(size: 22))
                                .padding(.bottom, 5.00)
                                
                                Button(action: {
                                    presentAlert = true
                                    
                                }, label: {
                                    Text("Save")
                                })
                                .frame(width:81,height:30)
                                .foregroundColor(.white)
                                .background(Color("appColor"))
                                .cornerRadius(8)
                                .padding(.leading, 130)
                                .alert("Add Label", isPresented: $presentAlert, actions: {
                                    TextField("Label", text: $colorName)
                                    //save the selected color
                                    Button("Save", action: {setTheValues(); continueColor.toggle() ; colorName = ""})
                                    Button("Cancel", role: .cancel, action: {})
                                }, message: {
                                    Text("labelDesc")
                                })
                                .alert("savedColor", isPresented: $continueColor, actions: {
                                    //save the selected color
                                    Button("Continue", action: {})
                                    Button("Exit", role: .cancel, action: { selectedImage = nil
                                        showPicker.toggle()})
                                }, message: {
                                    Text("continueDesc")
                                })
                            }
                            //   .padding([.top, .leading, .trailing])
                        }
                    }
                
                    .frame(width: 338,height: 147)
                    .cornerRadius(20)
                    .padding(.top, 500.0)
            
                
                VStack(){
                    HStack{
                        // CLOSE BUTTON
                        Button(action: {
                            selectedImage = nil
                            showPicker.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                        })
                        .frame(width:100,height:50)
                        .foregroundColor(.white)
                        .background(Circle().fill(.gray.opacity(0.8)))
                        //   .padding()
                        Spacer()
                        
                        Button(action: {
                          //  selectedColor.toggle()
                        }, label: {
                            //this will only show the picker icon
                            customColorPicker(color: $color)
                                .frame(width:100,height:50)
                                .clipped()
                                .offset(x:25)
                                .background(Circle().fill(.gray.opacity(0.8)))
                        })
                        
                        
                    }
                    
                    Spacer()
                    
                }
            }
            
            
            
        }
    }
  
    func setTheValues ()
    {
        let newColor = SavedColors(context: viewContext)
        newColor.colorName=colorName
        newColor.hexValue="#"+(color.toHex() ?? "N/A")
        newColor.redValue = String(format: "%.0f", color.components.red)
        newColor.greenValue = String(format: "%.0f", color.components.green)
        newColor.blueValue = String(format: "%.0f", color.components.blue)
        
        //save it to core data
        try? viewContext.save()

    }
    
}


//custom color picker with UIcolorPicker
struct customColorPicker: UIViewControllerRepresentable{
    //the picker value
    @Binding var color: Color
    //  @Binding var selectedColor: Bool
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.selectedColor = UIColor(color)
        
        //connecting delegate
        picker.delegate = context.coordinator
        //removing title from picker
        picker.title = ""
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        uiViewController.view.tintColor = .white
    }
    
    //delegate method
    class Coordinator: NSObject,UIColorPickerViewControllerDelegate{
        var parent: customColorPicker
        
        init(parent: customColorPicker) {
            self.parent = parent
        }
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            //updating color
            parent.color = Color(viewController.selectedColor)
            //  parent.selectedColor.toggle()
        }
        
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.color = Color(color)
        }
        
    }
}

//extention of color to get the hex value and rgb
extension Color {
    //to get the RGB values
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        
#if canImport(UIKit)
        typealias NativeColor = UIColor
#elseif canImport(AppKit)
        typealias NativeColor = NSColor
#endif
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }
        
        return (r*255, g*255, b*255, o)
    }
    
    // tp get the color from hex value
    init?(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 1.0

            let length = hexSanitized.count

            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

            if length == 6 {
                r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                b = CGFloat(rgb & 0x0000FF) / 255.0

            } else if length == 8 {
                r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                a = CGFloat(rgb & 0x000000FF) / 255.0

            } else {
                return nil
            }

            self.init(red: r, green: g, blue: b, opacity: a)
        }
    
    
    //to get the Hex value
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
