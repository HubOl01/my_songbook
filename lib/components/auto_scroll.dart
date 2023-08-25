import 'package:flutter/material.dart';

import '../settings/currentNumber.dart';

autoScroll(ScrollController _scrollController) {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (_scrollController.offset <= maxScrollExtent / 16) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: speed * 1000), curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 16 &&
        _scrollController.offset <= maxScrollExtent / 12) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 1000),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 12 &&
        _scrollController.offset <= maxScrollExtent / 10) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 900),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 10 &&
        _scrollController.offset <= maxScrollExtent / 8) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 800),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 8 &&
        _scrollController.offset <= maxScrollExtent / 6) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 700),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 6 &&
        _scrollController.offset <= maxScrollExtent / 4) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 600),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 4 &&
        _scrollController.offset <= maxScrollExtent / 2) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 500),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 2 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.1) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 400),
          curve: Curves.linear);
          
    } else if (_scrollController.offset > maxScrollExtent / 2 * 1.1 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.2) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 400),
          curve: Curves.linear);
          
    } else if (_scrollController.offset > maxScrollExtent / 2 * 1.2 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.3) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 300),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 2 * 1.3 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.4) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 300),
          curve: Curves.linear);
          
    } else if (_scrollController.offset > maxScrollExtent / 2 * 1.4 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.5) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 200),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 2 * 1.5 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.6) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 200),
          curve: Curves.linear);
          
    } else if (_scrollController.offset > maxScrollExtent / 2 * 1.6 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.7) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 100),
          curve: Curves.linear);
    } else if (_scrollController.offset > maxScrollExtent / 2 * 1.7 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.8) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 100),
          curve: Curves.linear);
          
    } else if (_scrollController.offset > maxScrollExtent / 2 * 1.8 &&
        _scrollController.offset <= maxScrollExtent / 2 * 1.9) {
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 50),
          curve: Curves.linear);
          
    } else{
      _scrollController.animateTo(maxScrollExtent,
          duration: Duration(milliseconds: (speed) * 25),
          curve: Curves.linear);
    }
    // else{
    //   _scrollController.animateTo(maxScrollExtent, duration: Duration(milliseconds: (speed) * 1000-90), curve: Curves.linear);
    // }

    print("_scrollController.offset ${_scrollController.offset}");

    // });
    // }else{
    // _timer?.cancel();
    // _scrollController.dispose();
    // }
    // });
  }