import SwiftUI

// MARK: - TYPOGRAPHY

// usage: .font(.headline1Bold)

extension Font {
    // MARK: - HEADLINE BOLD

    /// Satoshi-Bold: 32
    static var headline1Bold: Font {
        satoshiBold(size: 32)
    }

    /// Satoshi-Bold: 26
    static var headline2Bold: Font {
        satoshiBold(size: 26)
    }

    /// Satoshi-Bold: 22
    static var headline3Bold: Font {
        satoshiBold(size: 22)
    }

    /// Satoshi-Bold: 20
    static var headline4Bold: Font {
        satoshiBold(size: 20)
    }

    /// Satoshi-Bold: 16
    static var headline5Bold: Font {
        satoshiBold(size: 16)
    }

    /// Satoshi-Bold: 14
    static var headline6Bold: Font {
        satoshiBold(size: 14)
    }

    /// Satoshi-Bold: 12
    static var headline7Bold: Font {
        satoshiBold(size: 12)
    }

    // MARK: - HEADLINE MEDIUM

    /// Satoshi-Medium: 20
    static var headline1Medium: Font {
        satoshiMedium(size: 20)
    }

    /// Satoshi-Medium: 16
    static var headline2Medium: Font {
        satoshiMedium(size: 16)
    }

    /// Satoshi-Medium: 14
    static var headline3Medium: Font {
        satoshiMedium(size: 14)
    }

    /// Satoshi-Medium: 12
    static var headline4Medium: Font {
        satoshiMedium(size: 12)
    }

    // MARK: - TEXT BODY

    /// Satoshi-Regular: 18
    static var textBody1: Font {
        satoshiRegular(size: 18)
    }

    /// Satoshi-Regular: 16
    static var textBody2: Font {
        satoshiRegular(size: 16)
    }

    /// Satoshi-Regular: 14
    static var textBody3: Font {
        satoshiRegular(size: 14)
    }

    /// Satoshi-Regular: 14
    static var textBody4: Font {
        satoshiRegular(size: 14)
    }

    /// Satoshi-Regular: 10
    static var textBody5: Font {
        satoshiRegular(size: 10)
    }
}

// MARK: - CUSTOM FONT SATOSHI

extension Font {
    /// Font weight: 400
    static func satoshiRegular(size: CGFloat) -> Font {
        return Font.custom("Satoshi-Regular", size: size)
    }

    /// Font weight: 500
    static func satoshiMedium(size: CGFloat) -> Font {
        return Font.custom("Satoshi-Medium", size: size)
    }

    /// Font weight: 700
    static func satoshiBold(size: CGFloat) -> Font {
        return Font.custom("Satoshi-Bold", size: size)
    }
}
