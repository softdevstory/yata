//
//  PageEditViewModel.swift
//  yata
//
//  Created by HS Song on 2017. 7. 12..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import RxSwift

enum PageEditMode {
    case new
    case edit
}

class PageEditViewModel: NSObject {

    private let telegraph = Telegraph.shared

    private let bag = DisposeBag()

    fileprivate var modified = false
    
    var mode = Variable<PageEditMode>(.new)
    
    var page: Page?

    var title = Variable<String>("")
    var authorName = Variable<String>("")
    
    var textStorage = NSTextStorage()

    override init() {
        super.init()
        
        textStorage.delegate = self
        
        modified = false
        notifyContentModifiedState()
    }
    
    func reset(page: Page?) {
        self.page = page

        if let page = page {
            mode.value = .edit
            
            title.value = page.title ?? ""
            authorName.value = page.authorName ?? ""
            
            convertPage()
            
        } else {
            mode.value = .new
            
            title.value = ""
            authorName.value = ""
            
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        modified = false
        notifyContentModifiedState()
    }

    func updatePage(title: String, authorName: String) -> Observable<Void> {
        self.title.value = title
        self.authorName.value = authorName
        
        let observable = Observable<Void>.create { observer in

            guard let path = self.page?.path else {
                observer.onError(YataError.InternalDataError)
                return Disposables.create()
            }
            
            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
                observer.onError(YataError.NoAccessToken)
                return Disposables.create()
            }

            let contextJSONString = self.convertText()
            
            // TODO: get author URL
            let disposable = self.telegraph.editPage(accessToken: accessToken, path: path, title: title, authorName: authorName, authorUrl: nil, content: contextJSONString)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { page in

                    self.page = page
                    
                    observer.onCompleted()

                }, onError: { error in
                    observer.onError(error)
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }

        return observable
    }
    
    func publisNewPage(title: String, authorName: String) -> Observable<Void> {
        self.title.value = title
        self.authorName.value = authorName
        
        let observable = Observable<Void>.create { observer in
        
            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
                observer.onError(YataError.NoAccessToken)
                return Disposables.create()
            }

            let contextJSONString = self.convertText()
            
            // TODO: get author URL
            let disposable = self.telegraph.createPage(accessToken: accessToken, title: title, authorName: authorName, authorUrl: nil, content: contextJSONString)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { page in

                    self.page = page
                    
                    observer.onCompleted()

                }, onError: { error in
                    observer.onError(error)
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }

        return observable
 
    }
    
    func setContentModified() {
        modified = true
        notifyContentModifiedState()
    }
    
    fileprivate func notifyContentModifiedState() {
        let notification = Notification(name: NotificationName.contentModifiedState, object: modified, userInfo: nil)
        NotificationQueue.default.enqueue(notification, postingStyle: .now)
    }
}

// MARK: Conversion between JSON and NSTextStorage

extension PageEditViewModel {

    private func convertNode(node: Node, style: TextStyles?) -> NSMutableAttributedString {
        switch node.type {
        case .string:
            return NSMutableAttributedString(string: node.string, attributes: style?.attributes)
        case .nodeElement:
            return convertElement(element: node.element, style: style)
        }
    }
    
    private func convertElement(element: NodeElement, style: TextStyles?) -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        var paragraphStyle: TextStyles = style ?? .body
        var isParagraph = false
        
        var isBold = false
        var isItalic = false
        var isLink = false
        var href: String = ""
        
        if let tag = element.tag {
            switch tag {
            case "p":
                paragraphStyle = .body
                isParagraph = true
            case "h3":
                paragraphStyle = .title
                isParagraph = true
            case "h4":
                paragraphStyle = .header
                isParagraph = true
            case "blockquote":
                paragraphStyle = .blockQuote
                isParagraph = true
            case "aside":
                paragraphStyle = .pullQuote
                isParagraph = true
                
            case "a":
                isLink = true
                if let attrs = element.attrs, let h = attrs.href {
                    href = h
                }
            case "strong":
                isBold = true
            case "em":
                isItalic = true
                
            default:
                Swift.print("Unsupported tag \(tag)")
            }
        }
       
        if let children = element.children {
            for node in children {
                let attrString = convertNode(node: node, style: paragraphStyle)
                let range = NSMakeRange(0, attrString.length)
                if isLink {
                    attrString.addAttribute(NSLinkAttributeName, value: href, range: range)
                }
                if isBold {
                    attrString.applyFontTraits(.boldFontMask, range: range)
                }
                if isItalic {
                    attrString.applyFontTraits(.italicFontMask, range: range)
                }
                
                result.append(attrString)
            }
        }
        
        if isParagraph {
            result.append(NSAttributedString(string: "\n"))
        }
        
        return result
    }
    
    fileprivate func convertPage() {
        guard let page = page, let content = page.content else {
            return
        }
        
        let result = NSMutableAttributedString()
        
        for node in content {
            result.append(convertNode(node: node, style: nil))
        }
        
        textStorage.setAttributedString(result)
    }
    
    fileprivate func convertText() -> String {
        
        var json: Any?
        
        json = [[String: Any]]()
        
        for paragraph in textStorage.paragraphs {
            var range = NSMakeRange(0, paragraph.length)
            let attributes = paragraph.attributes(at: 0, effectiveRange: &range)
            let style = TextStyles(attributes: attributes)
            
            var element: [String: Any] = [:]
            switch style {
            case .unknown:
                element["tag"] = "p"
            case .title:
                element["tag"] = "h3"
            case .header:
                element["tag"] = "h4"
            case .body:
                element["tag"] = "p"
            case .blockQuote:
                element["tag"] = "blockquote"
            case .pullQuote:
                element["tag"] = "aside"
            }
            element["children"] = [Any]()

            range = NSMakeRange(0, paragraph.length)
            paragraph.enumerateAttributes(in: range, options: []) { attrs, range, _ in
                let subStr = paragraph.attributedSubstring(from: range)
                
                var node: [String: Any] = [:]
                node["children"] = [subStr.string.trimmingCharacters(in: .newlines)]
                
                if let font = attrs[NSFontAttributeName] as? NSFont {
                    if font.isBold {
                        switch style {
                        case .title, .header:
                            break
                        default:
                            var element: [String: Any] = [:]
                        
                            element["tag"] = "strong"
                            element["children"] = [node]
                            
                            node = element
                        }
                    }
                    
                    if font.isItalic {
                        switch style {
                        case .blockQuote, .pullQuote:
                            break
                        default:
                            var element: [String: Any] = [:]
                            
                            element["tag"] = "em"
                            element["children"] = [node]
                            
                            node = element
                        }
                    }
                }
                
                if let _ = attrs[NSLinkAttributeName] as? String {
                    var element: [String: Any] = [:]
                    var attr: [String: Any] = [:]
                    
                    element["tag"] = "a"
                    element["children"] = [node]
                    attr["href"] = subStr.attribute(NSLinkAttributeName, at: 0, effectiveRange: nil) as? String
                    element["attrs"] = attr
                    
                    node = element
                }
                
                var array = element["children"] as! [Any]
                array.append(node)
                element["children"] = array
            }
            
            var array = json as! [[String: Any]]
            array.append(element)
            json = array as Any
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json!)
            let string = String(data: data, encoding: .utf8)
            return string ?? ""
        } catch {
            print("error \(error)")
        }
        
        return ""
    }

}

// 

extension PageEditViewModel: NSTextStorageDelegate {
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {

        modified = true
        notifyContentModifiedState()
    }
}
