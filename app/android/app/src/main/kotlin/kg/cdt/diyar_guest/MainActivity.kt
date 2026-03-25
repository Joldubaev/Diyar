package kg.cdt.diyar_guest
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import com.yandex.mapkit.MapKitFactory
import android.util.Log

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        val apiKey = BuildConfig.YANDEX_MAPKIT_API_KEY

        MapKitFactory.setLocale("ru_RU")

        if (apiKey.isBlank()) {
            Log.e(
                "MainActivity",
                "Yandex MapKit API key is empty. Add 'yandex.mapkit.api_key' to local.properties (project root) " +
                    "or set environment variable 'YANDEX_MAPKIT_API_KEY', then rebuild."
            )
        } else {
            MapKitFactory.setApiKey(apiKey)
        }
        super.configureFlutterEngine(flutterEngine)
    }
}
