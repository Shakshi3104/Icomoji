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

// MARK: - EmojiIconView
struct EmojiIconView: View {
    @State var emojiString: String
    @State var backgroundColor: Color
    
    var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(backgroundColor)
            
            Text(emojiString)
                .font(.system(size: 100))
        }
        .frame(width: 300, height: 300)
    }
}

// MARK: - IcomojiView
struct IcomojiView: View {
    @State var textInput: NSAttributedString? = NSAttributedString(string: "😄")
    @State var textToDisplay: NSAttributedString? = nil
    @State var iconImage: Image? = nil
    @State var emojiString: String? = "😄"
    
    @State var backgroundColor: Color = .blue
    
    @State private var photo = ScreenshotItem(image: Image("appicon"), caption: "sample")
    
    var body: some View {
        
        List {
            Section("Preview") {
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(backgroundColor)
                        
                        Group {
                            if let iconImage {
                                iconImage
                            } else if let emojiString {
                                Text(emojiString)
                                    .font(.system(size: 100))
                            }
                        }
                    }
                    .frame(width: 300, height: 300)
                    .padding()
                    Spacer()
                }
            }
            
            Section {
                HStack {
                    Text("Emoji")
                    Spacer()
                    GenmojiTextField(text: $textInput)
                        .frame(width: 30)
                }
                .padding(.vertical, 8)
                    
                
                ColorPicker(selection: $backgroundColor, supportsOpacity: false) {
                    Text("Background Color")
                }
                .padding(.vertical, 8)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                ShareLink(
                    item: photo,
                    subject: Text("Share Genmoji icon"),
                    preview: SharePreview(photo.caption, image: photo.image)
                )
            }
        }
        .onChange(of: textInput) { oldText, newText in
            print("text change")
            if let uiImage = newText?.getGenmoji() {
                iconImage = Image(uiImage: uiImage.resize(width: 100, height: 100))
                emojiString = nil
                // render
                renderGenmojiIcon()
            } else if let emoji = newText?.getEmojiString() {
                print(emoji)
                iconImage = nil
                emojiString = emoji
                // render
                renderEmojiIcon()
            }
        }
        .onChange(of: backgroundColor) { _, _ in
            print("Background color change")
            if let _ = emojiString {
                renderEmojiIcon()
            }
            else if let _ = iconImage {
                renderGenmojiIcon()
            }
        }
        .onAppear {
            if let _ = emojiString {
                renderEmojiIcon()
            } else {
                renderGenmojiIcon()
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    // render Icomoji icon by Genmoji to PNG image
    func renderGenmojiIcon() {
        DispatchQueue.main.async {
            let renderer = ImageRenderer(content: GenmojiIconView(iconImage: iconImage, backgroundColor: backgroundColor))
            
            if let uiImage = renderer.uiImage {
                photo.image = Image(uiImage: uiImage)
            }
        }
    }
    
    func renderEmojiIcon() {
        DispatchQueue.main.async {
            let renderer = ImageRenderer(content: EmojiIconView(emojiString: emojiString ?? "?", backgroundColor: backgroundColor))
            
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
