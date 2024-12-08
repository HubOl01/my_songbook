import 'package:flutter/material.dart';

import '../core/utils/currentNumber.dart';

autoScroll(ScrollController scrollController) {
    double maxScrollExtent = scrollController.position.maxScrollExtent;

    if (scrollController.offset <= maxScrollExtent / 16) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: speed * 1000), curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 16 &&
        scrollController.offset <= maxScrollExtent / 12) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 1000),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 12 &&
        scrollController.offset <= maxScrollExtent / 10) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 900),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 10 &&
        scrollController.offset <= maxScrollExtent / 8) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 800),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 8 &&
        scrollController.offset <= maxScrollExtent / 6) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 700),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 6 &&
        scrollController.offset <= maxScrollExtent / 4) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 600),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 4 &&
        scrollController.offset <= maxScrollExtent / 2) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 500),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 2 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.1) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 400),
          curve: Curves.linear);
          
    } else if (scrollController.offset > maxScrollExtent / 2 * 1.1 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.2) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 400),
          curve: Curves.linear);
          
    } else if (scrollController.offset > maxScrollExtent / 2 * 1.2 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.3) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 300),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 2 * 1.3 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.4) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 300),
          curve: Curves.linear);
          
    } else if (scrollController.offset > maxScrollExtent / 2 * 1.4 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.5) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 200),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 2 * 1.5 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.6) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 200),
          curve: Curves.linear);
          
    } else if (scrollController.offset > maxScrollExtent / 2 * 1.6 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.7) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 100),
          curve: Curves.linear);
    } else if (scrollController.offset > maxScrollExtent / 2 * 1.7 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.8) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 100),
          curve: Curves.linear);
          
    } else if (scrollController.offset > maxScrollExtent / 2 * 1.8 &&
        scrollController.offset <= maxScrollExtent / 2 * 1.9) {
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 50),
          curve: Curves.linear);
          
    } else{
      scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 25),
          curve: Curves.linear);
    }
    // else{
    //   _scrollController.animateTo(maxScrollExtent, duration: Duration(milliseconds: (speed) * 1000-90), curve: Curves.linear);
    // }

    print("_scrollController.offset ${scrollController.offset}");

    // });
    // }else{
    // _timer?.cancel();
    // _scrollController.dispose();
    // }
    // });
  }