import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/constants/styles.dart';
import 'package:real_estate/providers/mainprovider.dart';
import 'package:provider/provider.dart';

class FavoritBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainProvider bolc = Provider.of<MainProvider>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colors.white,
          border: Border.all(
            color: colors.orange,
            width: 1,
          )),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      // color: Colors.grey[100],
      child: Row(
        children: <Widget>[
          Expanded(
            // child: Visibility(
            child: FlatButton(
                padding: EdgeInsets.zero,
                textColor: colors.black,
                disabledColor: colors.grey,
                splashColor: colors.trans,
                highlightColor: colors.trans,
                onPressed: () {
                  if (bolc.favocurrentIndex == 1) {
                    bolc.changeTabBarIndex(0);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: colors.white),
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text("fav1",
                          style: styles.underHeadorange),
                    ),
                    AnimatedOpacity(
                        opacity: bolc.visible1 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 700),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: colors.orange),
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text("fav2",
                              style: styles.underHeadwhite2),
                        ))
                  ],
                )),
            // visible: bolc.visible1,
            // replacement: FlatButton(
            //     padding: EdgeInsets.zero,
            //     textColor: colors.black,
            //     disabledColor: colors.grey,
            //     splashColor: colors.trans,
            //     highlightColor: colors.trans,
            //     onPressed: () {
            //       if (bolc.favocurrentIndex == 1) {
            //         bolc.changeTabBarIndex(0);
            //       }
            //     },
            //     child: Stack(
            //       children: <Widget>[
            //         AnimatedOpacity(
            //             opacity: bolc.visible2 ? 1.0 : 0.0,
            //             duration: const Duration(milliseconds: 700),
            //             child: Container(
            //               decoration: BoxDecoration(
            //                   borderRadius:
            //                       const BorderRadius.all(Radius.circular(12)),
            //                   color: colors.trans),
            //               alignment: Alignment.center,
            //               height: 50,
            //               width: MediaQuery.of(context).size.width * .5,
            //               child: Text(trans(context, 'stores'),
            //                   style: styles.underHeadorange),
            //             ))
            //       ],
            //     )),
            //)
          ),
          Expanded(
            //  child: Visibility(
            child: FlatButton(
                padding: EdgeInsets.zero,
                textColor: colors.black,
                disabledColor: colors.grey,
                splashColor: colors.trans,
                highlightColor: colors.trans,
                onPressed: () {
                  if (bolc.favocurrentIndex == 0) {
                    bolc.changeTabBarIndex(1);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: colors.white),
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text("خصومات",
                          style: styles.underHeadorange),
                    ),
                    AnimatedOpacity(
                        opacity: bolc.visible2 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: colors.orange),
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text("خصومات",
                              style: styles.underHeadwhite2),
                        ))
                  ],
                )),
            // visible: bolc.visible2,
            // replacement: FlatButton(
            //     padding: EdgeInsets.zero,
            //     textColor: colors.black,
            //     disabledColor: colors.grey,
            //     splashColor: colors.trans,
            //     highlightColor: colors.trans,
            //     onPressed: () {
            //       if (bolc.favocurrentIndex == 0) {
            //         bolc.changeTabBarIndex(1);
            //       }
            //     },
            //     child: Stack(
            //       children: <Widget>[
            //         AnimatedOpacity(
            //             opacity: bolc.visible1 ? 1.0 : 0.0,
            //             duration: const Duration(milliseconds: 800),
            //             child: Container(
            //               decoration: BoxDecoration(
            //                   borderRadius: const BorderRadius.all(
            //                       Radius.circular(12)),
            //                   color: colors.white),
            //               alignment: Alignment.center,
            //               height: 50,
            //               width: MediaQuery.of(context).size.width * .5,
            //               child: Text(trans(context, 'discounts'),
            //                   style: styles.underHeadorange),
            //             ))
            //       ],
            //     ))),
          )
        ],
      ),
    );
  }
}
