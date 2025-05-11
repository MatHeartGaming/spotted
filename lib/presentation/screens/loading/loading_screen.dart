import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  static const name = 'LoadingScreen';

  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends ConsumerState {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("loading_screen_loading_and_redirecting_txt").tr(),
            const Text("loading_screen_please_wait_txt").tr(),
            const SizedBox(
              height: 20,
            ),
            //_loadingRotatableImage(size),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator.adaptive()),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  /*Rotation3DEffect _loadingRotatableImage(Size size) {
    final appConfigs = ref.watch(appConfigsProvider).configs;
    return Rotation3DEffect.limitedReturnsInPlace(
      maximumPan: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ClipRRect(
          child: appConfigs.appIconUrlIsValid
              ? FadeInImage(
                  fit: BoxFit.cover,
                  height: size.height * 0.3,
                  placeholder: MemoryImage(kTransparentImage),
                  image: const AssetImage('assets/images/icona_app.png'))
              : const SizedBox(),
        ),
      ),
    );
  }*/
}
