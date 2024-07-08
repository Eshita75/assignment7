import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utility/assets_path.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // eikhane stack use hobe cz background image er opor logo img ta thakbe
      //stack means first in last out .since we use background img first so ei image er opore logo image asbe.
      children: [
        SvgPicture.asset(
          AssetsPaths.backgroundSVG,
          height: double.maxFinite,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
        child
      ],
    );
  }
}
