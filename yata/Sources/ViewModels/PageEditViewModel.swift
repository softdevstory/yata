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

class PageEditViewModel {

    private let telegraph = Telegraph.shared

    private let bag = DisposeBag()
    
    private var mode = PageEditMode.new
    
    var page = Variable<Page?>(nil)

    func reset(page: Page?) {
        if let page = page {
            mode = .edit
            self.page.value = page
        } else {
            mode = .new
        }
    }
    
    func publisNewPage(title: String, authorName: String, content: NSTextStorage?) -> Observable<Void> {
        let observable = Observable<Void>.create { observer in
        
//            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
//                observer.onError(YataError.NoAccessToken)
//                return Disposables.create()
//            }

            // TODO: this is for test
            let accessToken = "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb"

            let contextJSONString = self.convertText(textStorage: content)
            
            // TODO: get author URL
            let disposable = self.telegraph.createPage(accessToken: accessToken, title: title, authorName: authorName, authorUrl: nil, content: contextJSONString)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { page in

                    self.page.value = page
                    
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
    
    private func convertText(textStorage: NSTextStorage?) -> String {
        guard let textStorage = textStorage else {
            return ""
        }
        
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
            case .singleQuotation:
                element["tag"] = "blockquote"
            case .doubleQuotation:
                element["tag"] = "aside"
            }
            element["children"] = [Any]()

            range = NSMakeRange(0, paragraph.length)
            paragraph.enumerateAttributes(in: range, options: []) { attrs, range, _ in
                let subStr = paragraph.attributedSubstring(from: range)
                
                var node: [String: Any] = [:]
                node["children"] = [subStr.string]
                
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
                        case .singleQuotation, .doubleQuotation:
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
