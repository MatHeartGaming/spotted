enum Flavor {
  prod,
  dev,
}

class F {
  static late final Flavor? appFlavor;

  static String get name => appFlavor?.name ?? Flavor.dev.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.prod:
        return 'Spotted';
      case Flavor.dev:
        return 'Spotted Dev';
      case null:
        return 'Spotted Dev';
    }
  }

}
