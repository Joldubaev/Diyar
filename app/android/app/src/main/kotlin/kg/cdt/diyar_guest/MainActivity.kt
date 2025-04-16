package kg.cdt.diyar_guest
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setLocale("ru_RU")
        MapKitFactory.setApiKey("7c6c4061-eb9d-4f05-8acc-b5f5647ef03a") // Your generated API key
        super.configureFlutterEngine(flutterEngine)
    }
}
