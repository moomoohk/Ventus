import "../../lib/ventus.dart";
import "dart:html" as html;
import "dart:async";
import "dart:js";

import "package:dquery/dquery.dart";

void main() {
  WindowManager wm = new WindowManager();

  Window terminalWin = wm.createWindow.fromQuery(
      ".terminal-app",
      new WindowOptions(
          title: "Terminal",
          classname: "terminal-window",
          width: 600,
          height: 300,
          x: 50,
          y: 60));

  terminalWin.signals.on("click", allowInterop((Window window, dynamic event) {
    print("Terminal focus");
  }));

  Window todoWin = wm.createWindow.fromQuery(".todo-app",
      new WindowOptions(title: "Todo", width: 330, height: 400, x: 670, y: 60));

  Window playerWin = wm.createWindow.fromQuery(
      '.player-app',
      new WindowOptions(
          title: 'Video Player',
          classname: 'player-window',
          width: 635,
          height: 300,
          x: 490,
          y: 320,
          resizable: false,
          opacity: 1 // To fix problems with chrome video on Linux
          ));

  Window aboutWin = wm.createWindow.fromQuery(
      '.about-app',
      new WindowOptions(
          title: 'About Ventus', width: 250, height: 280, x: 140, y: 380));

  var loader = $("#loading-screen");

  void openWithDelay(Window win, num delay) {
    new Timer(new Duration(milliseconds: delay), () => win.open());
  }

  void init() {
    loader.addClass("hide");
    loader.on(browser.animationEventName(), (_) {
      loader.hide();

      openWithDelay(terminalWin, 0);
      openWithDelay(todoWin, 200);
      openWithDelay(aboutWin, 400);
      openWithDelay(playerWin, 600);
    });
  }

  new Timer(new Duration(seconds: 3), () {
    bool isChrome =
        new RegExp("Chrome").hasMatch(html.window.navigator.userAgent) &&
            new RegExp("Google Inc").hasMatch(html.window.navigator.vendor);
    bool isSafari =
        new RegExp("Safari").hasMatch(html.window.navigator.userAgent) &&
            new RegExp("Apple Computer").hasMatch(html.window.navigator.vendor);
    var browserAlert = $(".browser-overlay");

    if (!isChrome && !isSafari) {
      browserAlert.find(".close-button").click((_) {
        browserAlert.hide();

        init();
      });

      browserAlert.show();
    } else {
      init();
    }
  });

  // Exposé test button
  $(".expose-button").click((_) {
    wm.mode = "expose";
    return false;
  });
}
