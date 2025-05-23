import com.android.build.gradle.AppExtension

val android = project
  .extensions
  .getByType(AppExtension::class.java)

android.apply {
  flavorDimensions("flavor-type")

  productFlavors {
    create("prod") {
      dimension = "flavor-type"
      applicationId = "com.example.spotted"
      versionCode = 1

      // ← call the method, don’t assign
      minSdkVersion(28)

      // positional args instead of named
      resValue("string", "app_name", "Spotted")
    }
    create("dev") {
      dimension = "flavor-type"
      applicationId = "com.example.spotted.dev"
      versionCode = 1

      // a reasonable dev minSdk
      minSdkVersion(28)

      resValue("string", "app_name", "Spotted Dev")
    }
  }
}
