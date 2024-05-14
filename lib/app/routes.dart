import 'package:flutter/material.dart';
import 'package:maize/Pages/Loading/loading_page.dart';
import 'package:maize/Pages/Authentication/authentication_page.dart';
import 'package:maize/Pages/Home/Page/home_page.dart';
import 'package:maize/Pages/ProvideURI/provide_uri_page.dart';
import 'app_bloc.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.loading:
      return [LoadingPage.page()];
    case AppStatus.noURI:
      return [ProvideURIPage.page()];
    case AppStatus.uninitialized:
    case AppStatus.initialized:
      return [LoadingPage.page()];
    case AppStatus.unauthenticated:
    default:
      return [AuthenticationPage.page()];
  }
}
