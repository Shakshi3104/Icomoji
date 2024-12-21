//
//  String+Extension.swift
//  Icomoji
//
//  Created by MacBook Pro M1 on 2024/12/21.
//

// https://zenn.dev/kamimi01/articles/implement_only_emoji_keyboard
extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }
}

extension String {
    func getEmoji() -> String {
        return self.filter({ $0.isEmoji })
    }
}
