import Cocoa

// Normal
// Bold
// Italic
// Link
// Title - Link만 같이 가능
// Sub Title - Link만 같이 가능
// Single Quote
// Double Quote

extension NSMutableAttributedString {
    func appendNormalString(string: String) {
        let normalFont = NSFont.systemFont(ofSize: NSFont.systemFontSize())
        let attrs: [String: Any] = [
            NSFontAttributeName: normalFont
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        append(attributedString)
    }
    
    func appendBoldString(string: String) {
        let boldFont = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize())
        let attrs: [String: Any] = [
            NSFontAttributeName: boldFont
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        append(attributedString)
    }
    
    func appendItalicString(string: String) {
        let systemFontName = NSFont.systemFont(ofSize: NSFont.systemFontSize()).fontName
        let fontManager = NSFontManager.shared()
        var trait = NSFontTraitMask()
        trait.insert(NSFontTraitMask.italicFontMask)

        let italicFont = fontManager.font(withFamily: systemFontName, traits: trait, weight: 0, size: NSFont.systemFontSize())
        let attrs: [String: Any] = [
            NSFontAttributeName: italicFont
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        append(attributedString)
    }
    
    func appendBoldItalicString(string: String) {
        let systemFontName = NSFont.systemFont(ofSize: NSFont.systemFontSize()).fontName
        let fontManager = NSFontManager.shared()
        var trait = NSFontTraitMask()
        trait.insert(NSFontTraitMask.italicFontMask)
        trait.insert(NSFontTraitMask.boldFontMask)

        let boldItalicFont = fontManager.font(withFamily: systemFontName, traits: trait, weight: 0, size: NSFont.systemFontSize())
        let attrs: [String: Any] = [
            NSFontAttributeName: boldItalicFont
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        append(attributedString)
    
    }
    
    func appendLinkString(string: String, url: String) {
        let attrs: [String: Any] = [
            NSLinkAttributeName: url
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        append(attributedString)
    }
    
    func appendBoldItalicLinkString(string: String, url: String) {
        let systemFontName = NSFont.systemFont(ofSize: NSFont.systemFontSize()).fontName
        let fontManager = NSFontManager.shared()
        var trait = NSFontTraitMask()
        trait.insert(NSFontTraitMask.italicFontMask)
        trait.insert(NSFontTraitMask.boldFontMask)

        let boldItalicFont = fontManager.font(withFamily: systemFontName, traits: trait, weight: 0, size: NSFont.systemFontSize())
        let attrs: [String: Any] = [
            NSFontAttributeName: boldItalicFont,
            NSLinkAttributeName: url
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        append(attributedString)
    
    }
    
    func appendSingleQuoteString(string: String) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 10
        paragraph.headIndent = 10
        
        let systemFontName = NSFont.systemFont(ofSize: NSFont.systemFontSize()).fontName
        let fontManager = NSFontManager.shared()
        let trit = NSFontTraitMask.italicFontMask

        let italicFont = fontManager.font(withFamily: systemFontName, traits: trit, weight: 0, size: NSFont.systemFontSize())
        
        let attrs: [String: Any] = [
            NSParagraphStyleAttributeName: paragraph,
            NSFontAttributeName: italicFont
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        append(attributedString)
    }
    
    func appendDoubleQuoteString(string: String) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let systemFontName = NSFont.systemFont(ofSize: NSFont.systemFontSize()).fontName
        let fontManager = NSFontManager.shared()
        let trit = NSFontTraitMask.italicFontMask

        let italicFont = fontManager.font(withFamily: systemFontName, traits: trit, weight: 0, size: NSFont.systemFontSize())
        
        let attrs: [String: Any] = [
            NSParagraphStyleAttributeName: paragraph,
            NSFontAttributeName: italicFont
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        append(attributedString)
    
    }
}

let textView = NSTextView(frame: NSMakeRect(0, 0, 400, 200))
textView.isAutomaticLinkDetectionEnabled = true
textView.displaysLinkToolTips = true

let textStorage = textView.textStorage!
textStorage.appendNormalString(string: "Normal\n")
textStorage.appendBoldString(string: "Bold\n")
textStorage.appendItalicString(string: "Italic\n")
textStorage.appendLinkString(string: "github\n", url: "http://github.com")
textStorage.appendSingleQuoteString(string: "single quote\n")
textStorage.appendDoubleQuoteString(string: "Double quote\n")
textStorage.appendBoldItalicString(string: "Bold and Italic\n")
textStorage.appendBoldItalicLinkString(string: "Bold and Italic Link\n", url: "http://github.com")

print(textStorage)

textView
