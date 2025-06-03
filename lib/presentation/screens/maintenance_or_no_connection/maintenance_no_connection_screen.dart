import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotation_three_d_effect/rotation_three_d_effect.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/error/maintenance_errors.dart';
import 'package:transparent_image/transparent_image.dart';

class MaintenanceNoConnectionScreen extends ConsumerWidget {
  final String firstText;
  final String secondText;
  final String imageAsset;
  final MaintenanceErrors issue;

  static const name = 'MaintenanceNoConnectionScreen';

  const MaintenanceNoConnectionScreen({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.imageAsset,
    this.issue = MaintenanceErrors.maintenance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = Theme.of(context).textTheme;
    if (issue == MaintenanceErrors.noConnection) {
      ref.listen(
        connectivityStreamProvider,
        (previous, next) {
          final authStatus = ref.read(authStatusProvider.notifier);
          if (next.value ?? false) authStatus.checkAuthStatus();
        },
      );
    }
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                firstText,
                textAlign: TextAlign.center,
                style: texts.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                secondText,
                textAlign: TextAlign.center,
              ),
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
              const SizedBox(
                height: 8,
              ),
              if (!kIsWeb && (issue == MaintenanceErrors.iOSBuildNumberIsHigher ||
                  issue == MaintenanceErrors.androidBuildNumberIsHigher))
                FilledButton.icon(
                  onPressed: () => _openStoreAction(ref),
                  label:
                      const Text('maintenance_screen_go_to_store_btn_txt').tr(),
                  icon: const Icon(Icons.upgrade_outlined),
                )
            ],
          ),
        ),
      ),
    ));
  }

  // ignore: unused_element
  Rotation3DEffect _loadingRotatableImage(Size size) {
    ImageProvider<Object> image = (issue != MaintenanceErrors.noConnection
        ? NetworkImage(imageAsset)
        : AssetImage('assets/images/$imageAsset')) as ImageProvider;
    return Rotation3DEffect.limitedReturnsInPlace(
      maximumPan: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        //child: Shimmer(
        child: ClipRRect(
          child: FadeInImage(
              fit: BoxFit.cover,
              height: size.height * 0.3,
              placeholder: MemoryImage(kTransparentImage),
              image: image),
        ),
      ),
      //),
    );
  }

  Future<void> _openStoreAction(WidgetRef ref) async {
    //final packageName = await ref.read(platformInfoProvider).getPackageName();
    //openStore(packageName);
  }
}
