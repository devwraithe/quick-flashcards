import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/app_colors.dart';

class UiHelpers {
  static loader() {
    return const SpinKitFadingFour(
      color: AppColors.white,
      size: 22,
    );
  }

  // dark loader
  static darkLoader() {
    return const SpinKitFadingFour(
      color: AppColors.black,
      size: 22,
    );
  }
}
