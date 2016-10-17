@JS("Ventus")
library ventus;

import "dart:html";

import "package:js/js.dart";
import "package:dquery/dquery.dart";

dynamic View(dynamic root) {
  if (root is Function) {
    // It's a template
    return (options) {
      return $(root(options ?? {}));
    };
  } else {
    // It's a selector
    return $(root);
  }
}

@JS()
class browser {
  external static String animationEventName();
}

@JS()
class InternalEmitter {
  external InternalEmitter();

  external int listenersCount(String signal);
  external void on(String signal, dynamic slot([Window win, dynamic event]),
      [dynamic scope]);
  external void off(String signal, dynamic slot([Window win, dynamic event]),
      [dynamic scope]);
  external void once(String signal, dynamic slot([Window win, dynamic event]),
      [dynamic scope]);
  external void emit(String signal, [dynamic varargs]);
  // connect
  // disconnect
}

class Emitter {
  InternalEmitter _jsObj;

  Emitter() : _jsObj = new InternalEmitter();

  int listenersCount(String signal) => _jsObj.listenersCount(signal);

  void on(String signal, dynamic slot([Window win]), [dynamic scope]) {
    _jsObj.on(signal, allowInterop(slot), scope);
  }

  void off(String signal, dynamic slot([Window win]), [dynamic scope]) {
    _jsObj.off(signal, allowInterop(slot), scope);
  }

  void once(String signal, dynamic slot([Window win]), [dynamic scope]) {
    _jsObj.once(signal, allowInterop(slot), scope);
  }

  void emit(String signal, [dynamic varargs]) {
    _jsObj.emit(signal);
  }
}

@JS()
@anonymous
class Event {
  external String get eventName;
  external dynamic get callback;

  external factory Event({String eventName, void callback()});
}

@JS()
@anonymous
class Coordinates {
  external int get x;
  external int get y;

  external factory Coordinates({int x, int y});
}

@JS()
@anonymous
class WindowOptions {
  external String get title;
  external int get width;
  external int get height;
  external int get x;
  external int get y;

  external void set content(dynamic content);
  external dynamic get content;

  external bool get movable;
  external bool get closable;
  external bool get resizable;
  external bool get widget;
  external bool get titlebar;

  external num get opacity;
  external List<Event> get events;
  external String get classname;

  external factory WindowOptions(
      {String title,
      int width,
      int height,
      int x,
      int y,
      var content,
      bool movable,
      bool closable,
      bool resizable,
      bool widget,
      bool titlebar,
      num opacity,
      List<Event> events,
      String classname});
}

@JS()
class Window {
  external InternalEmitter get signals;
  external Element get el;

  external void set space(Element el);
  external dynamic get space;

  external void set maximized(bool value);
  external bool get maximized;

  external void set minimized(bool value);
  external bool get minimized;

  external void set active(bool value);
  external bool get active;

  external void set enable(bool value);
  external bool get enabled;

  external void set movable(bool value);
  external bool get movable;

  external void set resizable(bool value);
  external bool get resizable;

  external bool get closed;
  external bool get destroyed;

  external void set widget(bool value);
  external bool get widget;

  external void set titlebar(bool value);
  external bool get titlebar;

  external void set width(int value);
  external int get width;

  external void set height(int value);
  external int get height;

  external void set x(int value);
  external int get x;

  external void set y(int value);
  external int get y;

  external void set z(int value);
  external int get z;

  external Window();

  external dynamic open();
  external dynamic close();
  external void destroy();
  external void resize(int w, int h);
  external void move(int x, int y);
  external void center();
  // stamp
  external void restore();
  external void maximize();
  external void minimize();
  external void focus();
  external void blur();
  external void toLocal(Coordinates coord);
  external void toGlobal(Coordinates coord);
  external void append(Element el);
}

@JS("WindowManager")
class InternalWindowManager {
  external InternalWindowManager();

  external void set mode(String mode);
  external String get mode;

  external dynamic get currentMode;

  external void set overlay(bool overlay);
  external bool get overlay;

  external List<Window> get windows;

  external Window createWindow(WindowOptions options);
}

class _WindowCreator {
  InternalWindowManager windowManager;

  _WindowCreator(this.windowManager);

  Window call(WindowOptions options) {
    return windowManager.createWindow(options);
  }

  fromQuery(String selector, WindowOptions options) {
    options.content = View(selector);
    return windowManager.createWindow(options);
  }

  fromElement(Element element, WindowOptions options) {
    options.content = View(element);
    return windowManager.createWindow(options);
  }
}

class WindowManager {
  InternalWindowManager _jsObj;
  _WindowCreator createWindow;

  WindowManager() : _jsObj = new InternalWindowManager() {
    createWindow = new _WindowCreator(_jsObj);
  }

  void set mode(String mode) {
    _jsObj.mode = mode;
  }

  List<Window> get windows {
    return _jsObj.windows;
  }

  String get mode => _jsObj.mode;

  dynamic get currentMode => _jsObj.currentMode;

  void set overlay(bool overlay) {
    _jsObj.overlay = overlay;
  }

  bool get overlay => _jsObj.overlay;
}
