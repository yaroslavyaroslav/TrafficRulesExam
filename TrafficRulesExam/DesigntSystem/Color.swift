import SwiftUI

enum ShadowType {
    case down
    case up
    case inner

}


// FIXME: Make this protocol with default implementation.
extension View {
    func defaultShadow(_ type: ShadowType = .down) -> some View {
        var y: CGFloat
        var x: CGFloat
        var radius: CGFloat
        switch type {
        case .down:
            y = 4
            x = 0
            radius = 8
        case .up:
            y = -4
            x = 0
            radius = 8
        case .inner:
            y = -4
            x = 0
            radius = 8
        }

        return self.compositingGroup().shadow(color: .DS.shadowLight, radius: radius, x: x, y: y)
    }
}

extension VStack where Content: View {
    func defaultShadow(_ type: ShadowType = .down) -> some View {
        var y: CGFloat
        var x: CGFloat
        switch type {
        case .down:
            y = 4
            x = 0
        case .up:
            y = -4
            x = 0
        case .inner:
            y = -4
            x = -4
        }
        return self.compositingGroup().shadow(color: .DS.shadowLight, radius: 8, x: x, y: y)
    }
}

extension HStack where Content: View {
    func defaultShadow(_ type: ShadowType = .down) -> some View {
        var y: CGFloat
        var x: CGFloat
        switch type {
        case .down:
            y = 4
            x = 0
        case .up:
            y = -4
            x = 0
        case .inner:
            y = -4
            x = -4
        }
        return self.compositingGroup().shadow(color: .DS.shadowLight, radius: 8, x: x, y: y)
    }
}

extension ZStack where Content: View {
    func defaultShadow(_ type: ShadowType = .down) -> some View {
        var y: CGFloat
        var radius: CGFloat
        switch type {
        case .down:
            y = 4
            radius = 8
        case .up:
            y = -4
            radius = 8
        case .inner:
            y = 0
            radius = -8
        }
        return self.compositingGroup().shadow(color: .DS.shadowLight, radius: radius, x: 0, y: y)
    }
}

extension Color {
    /// Namespace to prevent naming collisions with static accessors on
    /// SwiftUI's Color.
    ///
    /// Xcode's autocomplete allows for easy discovery of design system colors.
    /// At any call site that requires a color, type `Color.DS.<esc>`
    struct DS {
        public static let shadowLight = Color(red: 0.8148611187934875, green: 0.8148611187934875, blue: 0.9268055558204651, opacity: 0.2)
        public static let tintsRedLight = Color(red: 1, green: 0.23137255012989044, blue: 0.1882352977991104, opacity: 1)
        public static let tintsRedDark = Color(red: 1, green: 0.2705882489681244, blue: 0.22745098173618317, opacity: 1)
        public static let tintsOrangeLight = Color(red: 1, green: 0.5843137502670288, blue: 0, opacity: 1)
        public static let tintsOrangeDark = Color(red: 1, green: 0.6235294342041016, blue: 0.03921568766236305, opacity: 1)
        public static let tintsYellowLight = Color(red: 1, green: 0.800000011920929, blue: 0, opacity: 1)
        public static let tintsYellowDark = Color(red: 1, green: 0.8392156958580017, blue: 0.03921568766236305, opacity: 1)
        public static let tintsGreenLight = Color(red: 0.26857638359069824, green: 0.7230902910232544, blue: 0.38297775387763977, opacity: 1)
        public static let tintsGreenDark = Color(red: 0.19607843458652496, green: 0.843137264251709, blue: 0.29411765933036804, opacity: 1)
        public static let tintsTealLight = Color(red: 0.3529411852359772, green: 0.7843137383460999, blue: 0.9803921580314636, opacity: 1)
        public static let tintsTealDark = Color(red: 0.3921568691730499, green: 0.8235294222831726, blue: 1, opacity: 1)
        public static let tintsBlueLight = Color(red: 0, green: 0.47843137383461, blue: 1, opacity: 1)
        public static let tintsBlueDark = Color(red: 0.03921568766236305, green: 0.5176470875740051, blue: 1, opacity: 1)
        public static let tintsIndigoLight = Color(red: 0.3450980484485626, green: 0.33725491166114807, blue: 0.8392156958580017, opacity: 1)
        public static let tintsIndigoDark = Color(red: 0.3686274588108063, green: 0.3607843220233917, blue: 0.9019607901573181, opacity: 1)
        public static let tintsPurpleLight = Color(red: 0.686274528503418, green: 0.32156863808631897, blue: 0.8705882430076599, opacity: 1)
        public static let tintsPurpleDark = Color(red: 0.7490196228027344, green: 0.3529411852359772, blue: 0.9490196108818054, opacity: 1)
        public static let tintsPinkLight = Color(red: 0.9776389598846436, green: 0.2556943893432617, blue: 0.3932073712348938, opacity: 1)
        public static let tintsPinkDark = Color(red: 1, green: 0.21568627655506134, blue: 0.37254902720451355, opacity: 1)
        public static let tintsDisabledLight = Color(red: 0.6000000238418579, green: 0.6000000238418579, blue: 0.6000000238418579, opacity: 1)
        public static let tintsDisabledDark = Color(red: 0.4588235318660736, green: 0.4588235318660736, blue: 0.4588235318660736, opacity: 1)
        public static let greysGreyLight = Color(red: 0.5568627715110779, green: 0.5568627715110779, blue: 0.5764706134796143, opacity: 1)
        public static let greysGreyDark = Color(red: 0.5568627715110779, green: 0.5568627715110779, blue: 0.5764706134796143, opacity: 1)
        public static let greysGrey2Light = Color(red: 0.6823529601097107, green: 0.6823529601097107, blue: 0.6980392336845398, opacity: 1)
        public static let greysGrey2Dark = Color(red: 0.38823530077934265, green: 0.38823530077934265, blue: 0.4000000059604645, opacity: 1)
        public static let greysGrey3Light = Color(red: 0.7803921699523926, green: 0.7803921699523926, blue: 0.800000011920929, opacity: 1)
        public static let greysGrey3Dark = Color(red: 0.2823529541492462, green: 0.2823529541492462, blue: 0.29019609093666077, opacity: 1)
        public static let greysGrey4Light = Color(red: 0.8196078538894653, green: 0.8196078538894653, blue: 0.8392156958580017, opacity: 1)
        public static let greysGrey4Dark = Color(red: 0.22745098173618317, green: 0.22745098173618317, blue: 0.23529411852359772, opacity: 1)
        public static let greysGrey5Light = Color(red: 0.8980392217636108, green: 0.8980392217636108, blue: 0.9176470637321472, opacity: 1)
        public static let greysGrey5Dark = Color(red: 0.1725490242242813, green: 0.1725490242242813, blue: 0.18039216101169586, opacity: 1)
        public static let greysGrey6Light = Color(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9686274528503418, opacity: 1)
        public static let greysGrey6Dark = Color(red: 0.10980392247438431, green: 0.10980392247438431, blue: 0.11764705926179886, opacity: 1)
        public static let bgLightPrimary = Color(red: 1, green: 1, blue: 1, opacity: 1)
        public static let bgLightSecondary = Color(red: 0.9372549057006836, green: 0.9372549057006836, blue: 0.95686274766922, opacity: 1)
        public static let bgLightTertiary = Color(red: 1, green: 1, blue: 1, opacity: 1)
        public static let bgDarkBasePrimary = Color(red: 0, green: 0, blue: 0, opacity: 1)
        public static let bgDarkBaseSecondary = Color(red: 0.10980392247438431, green: 0.10980392247438431, blue: 0.11764705926179886, opacity: 1)
        public static let bgDarkBaseTertiary = Color(red: 0.1725490242242813, green: 0.1725490242242813, blue: 0.18039216101169586, opacity: 1)
        public static let bgDarkElevatedPrimary = Color(red: 0.10980392247438431, green: 0.10980392247438431, blue: 0.11764705926179886, opacity: 1)
        public static let bgDarkElevatedSecondary = Color(red: 0.1725490242242813, green: 0.1725490242242813, blue: 0.18039216101169586, opacity: 1)
        public static let bgDarkElevatedTertiary = Color(red: 0.22745098173618317, green: 0.22745098173618317, blue: 0.23529411852359772, opacity: 1)
        public static let bgGroupedLightPrimary = Color(red: 0.9372549057006836, green: 0.9372549057006836, blue: 0.95686274766922, opacity: 1)
        public static let bgGroupedLightSecondary = Color(red: 1, green: 1, blue: 1, opacity: 1)
        public static let bgGroupedLightTertiary = Color(red: 0.9372549057006836, green: 0.9372549057006836, blue: 0.95686274766922, opacity: 1)
        public static let bgGroupedDarkBasePrimary = Color(red: 0, green: 0, blue: 0, opacity: 1)
        public static let bgGroupedDarkBaseSecondary = Color(red: 0.10980392247438431, green: 0.10980392247438431, blue: 0.11764705926179886, opacity: 1)
        public static let bgGroupedDarkBaseTertiary = Color(red: 0.17100000381469727, green: 0.17100000381469727, blue: 0.18000000715255737, opacity: 1)
        public static let bgGroupedDarkElevatedPrimary = Color(red: 0.10980392247438431, green: 0.10980392247438431, blue: 0.11764705926179886, opacity: 1)
        public static let bgGroupedDarkElevatedSecondary = Color(red: 0.17100000381469727, green: 0.17100000381469727, blue: 0.18000000715255737, opacity: 1)
        public static let bgGroupedDarkElevatedTertiary = Color(red: 0.22745098173618317, green: 0.22745098173618317, blue: 0.23529411852359772, opacity: 1)
        public static let fillLightPrimary = Color(red: 0.47058823704719543, green: 0.47058823704719543, blue: 0.501960813999176, opacity: 0.20000000298023224)
        public static let fillLightSecondary = Color(red: 0.47058823704719543, green: 0.47058823704719543, blue: 0.501960813999176, opacity: 0.1599999964237213)
        public static let fillLightTertiary = Color(red: 0.4627451002597809, green: 0.4627451002597809, blue: 0.501960813999176, opacity: 0.11999999731779099)
        public static let fillLightQuarternary = Color(red: 0.45490196347236633, green: 0.45490196347236633, blue: 0.501960813999176, opacity: 0.07999999821186066)
        public static let fillDarkPrimary = Color(red: 0.47058823704719543, green: 0.47058823704719543, blue: 0.501960813999176, opacity: 0.36000001430511475)
        public static let fillDarkSecondary = Color(red: 0.47058823704719543, green: 0.47058823704719543, blue: 0.501960813999176, opacity: 0.3199999928474426)
        public static let fillDarkTertiary = Color(red: 0.4627451002597809, green: 0.4627451002597809, blue: 0.501960813999176, opacity: 0.23999999463558197)
        public static let fillDarkQuarternary = Color(red: 0.45490196347236633, green: 0.45490196347236633, blue: 0.501960813999176, opacity: 0.18000000715255737)
        public static let labelLightPrimary = Color(red: 0, green: 0, blue: 0, opacity: 1)
        public static let labelLightSecondary = Color(red: 0.23529411852359772, green: 0.23529411852359772, blue: 0.26274511218070984, opacity: 0.6000000238418579)
        public static let labelLightTertiary = Color(red: 0.23529411852359772, green: 0.23529411852359772, blue: 0.26274511218070984, opacity: 0.30000001192092896)
        public static let labelLightQuarternary = Color(red: 0.23529411852359772, green: 0.23529411852359772, blue: 0.26274511218070984, opacity: 0.18000000715255737)
        public static let labelDarkPrimary = Color(red: 1, green: 1, blue: 1, opacity: 1)
        public static let labelDarkSecondary = Color(red: 0.9215686321258545, green: 0.9215686321258545, blue: 0.9607843160629272, opacity: 0.6000000238418579)
        public static let labelDarkTertiary = Color(red: 0.9215686321258545, green: 0.9215686321258545, blue: 0.9607843160629272, opacity: 0.30000001192092896)
        public static let labelDarkQuarternary = Color(red: 0.9215686321258545, green: 0.9215686321258545, blue: 0.9607843160629272, opacity: 0.18000000715255737)
        public static let seperatorLightOpaque = Color(red: 0.7764706015586853, green: 0.7764706015586853, blue: 0.7843137383460999, opacity: 1)
        public static let seperatorLightNonOpaque = Color(red: 0.23529411852359772, green: 0.23529411852359772, blue: 0.26274511218070984, opacity: 0.28999999165534973)
        public static let seperatorDarkOpaque = Color(red: 0.21960784494876862, green: 0.21960784494876862, blue: 0.22745098173618317, opacity: 1)
        public static let seperatorDarkNonOpaque = Color(red: 0.3294117748737335, green: 0.3294117748737335, blue: 0.3450980484485626, opacity: 0.6499999761581421)
        public static let buttonWhiteFillNoOutline = Color(red: 1, green: 1, blue: 1, opacity: 1)
        public static let buttonWhiteFillGrayOutline = Color(red: 0.7490196228027344, green: 0.7490196228027344, blue: 0.7490196228027344, opacity: 1)
        public static let buttonWhiteFillBlackOutline = Color(red: 0, green: 0, blue: 0, opacity: 1)
        public static let buttonBlackFillNoOutline = Color(red: 0, green: 0, blue: 0, opacity: 1)
        public static let buttonBlackFillGrayOutline = Color(red: 0.3019607961177826, green: 0.3019607961177826, blue: 0.3019607961177826, opacity: 1)
    }
}

