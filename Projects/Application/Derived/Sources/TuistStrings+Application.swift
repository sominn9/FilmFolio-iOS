// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum ApplicationStrings {
  public enum LaunchScreen {
  }
  public enum Localizable {
    /// Animation
    public static let animation = ApplicationStrings.tr("Localizable", "Animation")
    /// Episodes
    public static let episodes = ApplicationStrings.tr("Localizable", "Episodes")
    /// First Air
    public static let firstAir = ApplicationStrings.tr("Localizable", "First Air")
    /// Home
    public static let home = ApplicationStrings.tr("Localizable", "Home")
    /// Movie
    public static let movie = ApplicationStrings.tr("Localizable", "Movie")
    /// Now Playing
    public static let nowPlayingMovies = ApplicationStrings.tr("Localizable", "Now Playing Movies")
    /// On The Air
    public static let onTheAirMovies = ApplicationStrings.tr("Localizable", "On The Air Movies")
    /// Popular
    public static let popularMovies = ApplicationStrings.tr("Localizable", "Popular Movies")
    /// Popular
    public static let popularSeries = ApplicationStrings.tr("Localizable", "Popular Series")
    /// Release
    public static let release = ApplicationStrings.tr("Localizable", "Release")
    /// Review
    public static let review = ApplicationStrings.tr("Localizable", "Review")
    /// Search
    public static let search = ApplicationStrings.tr("Localizable", "Search")
    /// Search Movie
    public static let searchMovie = ApplicationStrings.tr("Localizable", "Search Movie")
    /// Search TV Series
    public static let searchTVSeries = ApplicationStrings.tr("Localizable", "Search TV Series")
    /// Series
    public static let series = ApplicationStrings.tr("Localizable", "Series")
    /// Top Rated
    public static let topRatedMovies = ApplicationStrings.tr("Localizable", "Top Rated Movies")
    /// Top Rated
    public static let topRatedSeries = ApplicationStrings.tr("Localizable", "Top Rated Series")
    /// Upcoming
    public static let upcoming = ApplicationStrings.tr("Localizable", "Upcoming")
    /// Write a review.
    public static let writeAReview = ApplicationStrings.tr("Localizable", "Write a review.")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension ApplicationStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = ApplicationResources.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
// swiftlint:enable all
// swiftformat:enable all
