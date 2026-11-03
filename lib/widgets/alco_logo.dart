import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlcoLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const AlcoLogo({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        'assets/images/alco_logo_vector.svg',
        key: const Key('alco-logo'),
        fit: BoxFit.contain,
        semanticsLabel: 'ALCO - PT. Alcotraindo Batam',
      ),
    );
  }
}
