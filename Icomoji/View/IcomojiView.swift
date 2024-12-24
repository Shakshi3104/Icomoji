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
    @State var iconImage: UIImage
    @State var backgroundColor: Color
    @State var size: CGFloat
    
    var body: some View {
        ZStack(alignment: .center){
            Rectangle()
                .foregroundStyle(backgroundColor)
            
            Image(uiImage: iconImage.resize(width: size, height: size))
        }
        .frame(width: 300, height: 300)
    }
}

// MARK: - EmojiIconView
struct EmojiIconView: View {
    @State var emojiString: String
    @State var backgroundColor: Color
    @State var size: CGFloat
    
    var body: some View {
        ZStack(alignment: .center){
            Rectangle()
                .foregroundStyle(backgroundColor)
            
            Text(emojiString)
                .font(.system(size: size))
        }
        .frame(width: 300, height: 300)
    }
}

// MARK: - IcomojiView
struct IcomojiView: View {
    /// Inputted text that includes emojis, genmojis, or memojis.
    @State var textInput: NSAttributedString? = NSAttributedString(string: "😄")
    
    /// Inputted genmoji or memoji
    @State var iconImage: UIImage? = nil
    /// Inputted emoji
    @State var emojiString: String? = "😄"
    
    /// Icon image background color
    @State var backgroundColor: Color = .blue
    /// Icon size
    @State var size: CGFloat = 100
    
    /// Share Link item
    @State private var photo = ScreenshotItem(image: Image("appicon"), caption: "Icon image")
    
    /// slider editting flag
    @State private var isEditing = false
    
    /// Background flag
    @State private var hasBackground = true
    
    var body: some View {
        
        List {
            Section("Preview") {
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(backgroundColor)
                            .opacity(hasBackground ? 1.0 : 0.0)
                        
                        Group {
                            if let iconImage {
                                Image(uiImage: iconImage.resize(width: size, height: size))
                            } else if let emojiString {
                                Text(emojiString)
                                    .font(.system(size: size))
                            }
                        }
                    }
                    .frame(width: 300, height: 300)
                    .padding()
                    Spacer()
                }
            }
            
            Section("Edit") {
                HStack {
                    Text("Emoji")
                    Spacer()
                    GenmojiTextField(text: $textInput)
                        .frame(width: 30)
                }
                
                Toggle("Background", isOn: $hasBackground)
                
                ColorPicker(selection: $backgroundColor, supportsOpacity: false) {
                    Text("Background Color")
                        .foregroundStyle(hasBackground ? Color.primary : Color.secondary)
                }
                .disabled(!hasBackground)
                
                HStack {
                    Text("Icon size")
                    Spacer()
                        .frame(width: 40)
                    Slider(value: $size, in: 50...250,
                           onEditingChanged: { editing in
                        isEditing = editing
                    })
                }
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
            // Extract emoji or genmoji from input text
            print("text change")
            if let uiImage = newText?.getGenmoji() {
                iconImage = uiImage
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
            // Change background color
            print("Background color change")
            if let _ = emojiString {
                renderEmojiIcon()
            }
            else if let _ = iconImage {
                renderGenmojiIcon()
            }
        }
        .onChange(of: hasBackground, { _, _ in
            // Change background have or not
            print("hasBackground change")
            if let _ = emojiString {
                renderEmojiIcon()
            }
            else if let _ = iconImage {
                renderGenmojiIcon()
            }
        })
        .onChange(of: size, { _, _ in
            // Change icon size
            if !isEditing {
                print("Size change")
                if let _ = emojiString {
                    renderEmojiIcon()
                }
                else if let _ = iconImage {
                    renderGenmojiIcon()
                }
            }
        })
        .onAppear {
            if let _ = emojiString {
                renderEmojiIcon()
            } else {
                renderGenmojiIcon()
            }
        }
        .onTapGesture {
            // Close keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    // render Icomoji icon by Genmoji to PNG image
    func renderGenmojiIcon() {
        DispatchQueue.main.async {
            let renderer = ImageRenderer(content: GenmojiIconView(iconImage: iconImage ?? UIImage(), backgroundColor: backgroundColor.opacity(hasBackground ? 1.0 : 0.0), size: size))
            
            if let uiImage = renderer.uiImage {
                photo.image = Image(uiImage: uiImage)
            }
        }
    }
    
    // render Icomoji icon by Emoji to PNG image
    func renderEmojiIcon() {
        DispatchQueue.main.async {
            let renderer = ImageRenderer(content: EmojiIconView(emojiString: emojiString ?? "?", backgroundColor: backgroundColor.opacity(hasBackground ? 1.0 : 0.0), size: size))
            
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
