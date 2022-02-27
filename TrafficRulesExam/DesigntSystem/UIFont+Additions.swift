//
//  UIFont+Additions.swift
//  Traffic app
//
//  Generated on Zeplin. (15.02.2022).
//  Copyright (c) 2022 __MyCompanyName__. All rights reserved.
//

import UIKit
import SwiftUI

extension UIFont {

    class var sfLargeTitleBold: UIFont {
        return UIFont.systemFont(ofSize: 34.0, weight: .bold)
    }

    class var sfLargeTitle: UIFont {
        return UIFont.systemFont(ofSize: 34.0, weight: .regular)
    }

    class var sfTitle1Bold: UIFont {
        return UIFont.systemFont(ofSize: 28.0, weight: .bold)
    }

    class var sfTitle1: UIFont {
        return UIFont.systemFont(ofSize: 28.0, weight: .regular)
    }

    class var sfTitle2Bold: UIFont {
        return UIFont.systemFont(ofSize: 22.0, weight: .bold)
    }

    class var sfTitle2: UIFont {
        return UIFont.systemFont(ofSize: 22.0, weight: .regular)
    }

    class var sfTitle3Bold: UIFont {
        return UIFont.systemFont(ofSize: 20.0, weight: .semibold)
    }

    class var sfTitle3: UIFont {
        return UIFont.systemFont(ofSize: 20.0, weight: .regular)
    }

    class var sfBodySemibold: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    }

    class var sfHeadline: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    }

    class var sfBodySemiboldItalic: UIFont {
        return UIFont(name: "SFProText-SemiboldItalic", size: 17.0)!
    }

    class var sfHeadlineItalic: UIFont {
        return UIFont(name: "SFProText-SemiboldItalic", size: 17.0)!
    }

    class var sfBody: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }

    class var sfBodyItalic: UIFont {
        return UIFont(name: "SFProText-RegularItalic", size: 17.0)!
    }

    class var sfCalloutSemibold: UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    }

    class var sfCalloutSemiboldItalic: UIFont {
        return UIFont(name: "SFProText-SemiboldItalic", size: 16.0)!
    }

    class var sfCallout: UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: .regular)
    }

    class var sfCalloutItalic: UIFont {
        return UIFont(name: "SFProText-RegularItalic", size: 16.0)!
    }

    class var sfSubheadlineSemibold: UIFont {
        return UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    }

    class var sfSubheadlineSemiboldItalic: UIFont {
        return UIFont(name: "SFProText-SemiboldItalic", size: 15.0)!
    }

    class var sfSubheadline: UIFont {
        return UIFont.systemFont(ofSize: 15.0, weight: .regular)
    }

    class var sfSubheadlineItalic: UIFont {
        return UIFont(name: "SFProText-RegularItalic", size: 15.0)!
    }

    class var sfFootnoteSemibold: UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: .semibold)
    }

    class var sfFootnoteSemiboldItalic: UIFont {
        return UIFont(name: "SFProText-SemiboldItalic", size: 13.0)!
    }

    class var sfFootnote: UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }

    class var sfFootnoteItalic: UIFont {
        return UIFont(name: "SFProText-RegularItalic", size: 13.0)!
    }

    class var sfCaptionMedium: UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: .medium)
    }

    class var sfCaptionMediumItalic: UIFont {
        return UIFont(name: "SFProText-MediumItalic", size: 12.0)!
    }

    class var sfCaption: UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: .regular)
    }

    class var sfCaptionItalic: UIFont {
        return UIFont(name: "SFProText-RegularItalic", size: 12.0)!
    }

    class var sfCaption2Semibold: UIFont {
        return UIFont.systemFont(ofSize: 11.0, weight: .semibold)
    }

    class var sfCaption2SemiboldItalic: UIFont {
        return UIFont(name: "SFProText-SemiboldItalic", size: 11.0)!
    }

    class var sfCaption2: UIFont {
        return UIFont.systemFont(ofSize: 11.0, weight: .regular)
    }

    class var sfCaption2Italic: UIFont {
        return UIFont(name: "SFProText-RegularItalic", size: 11.0)!
    }

    var asFont: Font { Font(self as CTFont) }
}

extension Font {
    init(_ uiFont: UIFont) {
      self = Font(uiFont as CTFont)
    }
}
