//
//  String+Ext.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 08/01/24.
//

import Foundation
import UIKit

extension String {
    
    func htmlToAttributedString() -> NSAttributedString? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            // Setup style
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            attributed.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: attributed.length
                              ))
            
            attributed.enumerateAttribute(.font, in: NSRange(location: 0, length: attributed.length)) { value, range, stop in
                if let oldFont = value as? UIFont {
                    let newFont = oldFont.withSize(16)
                    attributed.addAttribute(.font, value: newFont, range: range)
                    attributed.addAttribute(.foregroundColor, value: UIColor.secondaryText, range: range)
                }
            }
            
            return attributed
        } catch {
            return nil
        }
    }
    
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:self)
        return date
    }
}
