//
//  IcomojiView.swift
//  Icomoji
//
//  Created by MacBook Pro M1 on 2024/12/21.
//
import SwiftUI

// MARK: -
// https://qiita.com/KokumaruGarasu/items/322c250bbb528c9f3793
struct ScreenshotItem: Transferable {
    
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
    
    public var image: Image
    public var caption: String
}

// MARK: - GenmojiIconView
struct GenmojiIconView: View {
    @State var iconImage: Image?
    @State var backgroundColor: Color
    
    var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(backgroundColor)
            
            if let _ = iconImage {
                iconImage
            } else {
                Image(systemName: "apple.image.playground")
            }
        }
        .frame(width: 300, height: 300)
    }
}

// MARK: - IcomojiView
struct IcomojiView: View {
    @State var textInput: NSAttributedString? = NSAttributedString(string: "😄")
    @State var textToDisplay: NSAttributedString? = nil
    @State var iconImage: Image? = nil
    
    @State var backgroundColor: Color = .blue
    
    @State private var photo = ScreenshotItem(image: Image("appicon"), caption: "sample")
    
    var body: some View {
        VStack {
            GenmojiIconView(iconImage: iconImage,
                            backgroundColor: backgroundColor)
            .padding()
            
            HStack {
                Text("Emoji or Genmoji")
                Spacer()
                    .frame(width: 160)
                
                GenmojiTextField(text: $textInput)
                    .frame(width: 50, height: 45)
            }
            ColorPicker(selection: $backgroundColor, supportsOpacity: false) {
                Text("Background Color")
            }
            
            Spacer()
            
            ShareLink(
                item: photo,
                subject: Text("Share Genmoji icon"),
                preview: SharePreview(photo.caption, image: photo.image)
            )
        }
        .onChange(of: textInput) { oldText, newText in
            if let uiImage = newText?.getGenmoji() {
                iconImage = Image(uiImage: uiImage.resize(width: 100, height: 100))
                // render
                renderGenmojiIcon()
            } else if let emoji = newText?.getEmojiString() {
                print(emoji)
                
            }
        }
        .padding()
    }
    
    // render Icomoji icon to PNG image
    func renderGenmojiIcon() {
        DispatchQueue.main.async {
            let renderer = ImageRenderer(content: GenmojiIconView(iconImage: iconImage, backgroundColor: backgroundColor))
            
            if let uiImage = renderer.uiImage {
                photo.image = Image(uiImage: uiImage)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    IcomojiView()
}
