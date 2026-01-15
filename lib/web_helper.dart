// Web helper for web platform
import 'dart:html' as html;

String getOrigin() {
  return html.window.location.origin;
}

void openUrl(String url) {
  html.window.open(url, '_self');
}
