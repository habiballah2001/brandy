import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      //height: size.height,
      child: Stack(
        //alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              "assets/images/top_R.svg",
              //width: size.width
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SvgPicture.asset(
              "assets/images/top_L.svg",
              //width: size.width
            ),
          ),
          Positioned(
            bottom: 0,
            right: -3,
            child: SvgPicture.asset(
              "assets/images/bott_R.svg",
              //width: size.width
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              "assets/images/bott_L.svg",
              //width: size.width
            ),
          ),
          Center(child: child)
        ],
      ),
    );
  }
}
