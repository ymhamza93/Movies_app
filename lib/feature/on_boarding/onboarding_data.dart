import '../../core/utils/assets_manager.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String desc;
  final String buttonText;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.desc,
    required this.buttonText,
  });
}

abstract class OnboardingData {
  static final List<OnboardingModel> pages = [
    OnboardingModel(
      image: AssetsManager.onboarding1,
      title: "Find Your Next\nFavorite Movie Here",
      desc:
          "Get access to a huge library of movies to suit all tastes. You will surely like it.",
      buttonText: "Explore Now",
    ),
    OnboardingModel(
      image: AssetsManager.onboarding2,
      title: "Discover Movies",
      desc:
          "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
      buttonText: "Next",
    ),
    OnboardingModel(
      image: AssetsManager.onboarding3,
      title: "Explore All Genres",
      desc:
          "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
      buttonText: "Next",
    ),
    OnboardingModel(
      image: AssetsManager.onboarding4,
      title: "Create Watchlists",
      desc:
          "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
      buttonText: "Next",
    ),
    OnboardingModel(
      image: AssetsManager.onboarding5,
      title: "Rate, Review, and Learn",
      desc:
          "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
      buttonText: "Next",
    ),
    OnboardingModel(
      image: AssetsManager.onboarding6,
      title: "Start Watching Now",
      desc:
          "Enjoy a seamless cinematic experience tailored just for you. Your personalized movie journey begins right here.",
      buttonText: "Finish",
    ),
  ];
}
