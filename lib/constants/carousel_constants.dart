/// Carousel placement keys for different positions in the app
class CarouselPlacement {
  static const String homeMainCarousel = 'HOME_MAIN_CAROUSEL';
  static const String homePopupModal = 'HOME_POPUP_MODAL';
}

/// Media types for carousel content
enum MediaType {
  staticImage('STATIC_IMAGE'),
  loopingAnimation('LOOPING_ANIMATION'),
  lottie('LOTTIE'),
  video('VIDEO');

  final String value;
  const MediaType(this.value);

  static MediaType fromString(String value) {
    switch (value) {
      case 'STATIC_IMAGE':
        return MediaType.staticImage;
      case 'LOOPING_ANIMATION':
        return MediaType.loopingAnimation;
      case 'LOTTIE':
        return MediaType.lottie;
      case 'VIDEO':
        return MediaType.video;
      default:
        throw ArgumentError('Unknown MediaType: $value');
    }
  }
}

/// Action types when user taps on carousel item
enum ActionType {
  appPage('APP_PAGE'),
  externalUrl('EXTERNAL_URL'),
  deeplink('DEEPLINK'),
  none('NONE');

  final String value;
  const ActionType(this.value);

  static ActionType fromString(String value) {
    switch (value) {
      case 'APP_PAGE':
        return ActionType.appPage;
      case 'EXTERNAL_URL':
        return ActionType.externalUrl;
      case 'DEEPLINK':
        return ActionType.deeplink;
      case 'NONE':
        return ActionType.none;
      default:
        throw ArgumentError('Unknown ActionType: $value');
    }
  }
}
