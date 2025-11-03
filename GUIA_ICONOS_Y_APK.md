# 📱 Guía: Cambiar Icono y Generar APK Instalable

## 🎨 Cambiar el Icono de la App

### 1. Reemplazar el Icono

1. Coloca tu nuevo icono (PNG de al menos 1024x1024 px) en `assets/images/`
2. Actualiza `pubspec.yaml` si cambiaste el nombre del archivo:

```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/images/tu-nuevo-icono.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/images/tu-nuevo-icono.png"
```

### 2. Generar los Iconos

```powershell
# Ejecutar generador de iconos
flutter pub run flutter_launcher_icons:main
```

Esto creará los iconos en:
- Android: `android/app/src/main/res/mipmap-*/`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

---

## 📦 Generar APK para Instalar en Celular

### Opción 1: APK Release (Recomendado para Testing)

```powershell
# Construir APK de producción
flutter build apk --release --flavor production --target lib/main_production.dart

# O para desarrollo
flutter build apk --release --flavor development --target lib/main_development.dart
```

**Ubicación del APK:**
- `build\app\outputs\flutter-apk\app-production-release.apk`
- Tamaño: ~48.6 MB

### Opción 2: App Bundle (Para Google Play Store)

```powershell
flutter build appbundle --release --flavor production --target lib/main_production.dart
```

---

## 📲 Instalar APK en tu Celular

### Método 1: Usar Flutter Install (Más Fácil)

```powershell
# Conecta tu celular por USB con depuración USB activada
flutter install --flavor production
```

### Método 2: Usar ADB Directamente

```powershell
# Verificar que el celular está conectado
adb devices

# Instalar el APK
adb install -r build\app\outputs\flutter-apk\app-production-release.apk
```

### Método 3: Transferir Manualmente

1. Copia el APK a tu celular (por cable USB, Google Drive, WhatsApp, etc.)
2. En tu celular, abre el APK
3. Activa "Instalar apps de orígenes desconocidos" si te lo pide
4. Instala la app

---

## ✅ Verificación

Una vez instalada:
1. La app aparecerá en tu cajón de apps con el icono configurado
2. **La app ahora funciona completamente sin necesidad del laptop** ✅
3. Usa la API pública de Pokémon TCG (https://api.pokemontcg.io/v2)
4. Abre la app directamente desde tu celular — las cartas cargarán automáticamente

### 🔄 Cambiar entre APIs

La app está configurada en `lib/pokemon_cards/data/config/api_config.dart`:

**Actualmente usando: API Pública Pokémon TCG** (Recomendado - Funciona siempre)
```dart
static const String baseUrl = 'https://api.pokemontcg.io/v2';
static const String? apiKey = '4639a28c-ca79-40d4-96b5-ccd487ea2a05';
```

**Para usar tu API local** (Solo funciona si el laptop está en misma WiFi):
```dart
static const String baseUrl = 'http://localhost:3000/api/v1';
static const String? apiKey = null;
```

**Para usar tu API deployed** (Cuando la despliegues en Railway/Render):
```dart
static const String baseUrl = 'https://tu-api.railway.app/api/v1';
static const String? apiKey = null;
```

Después de cambiar, debes reconstruir e reinstalar el APK.

---

## 🔧 Configuración de Firma (Signing)

Actualmente el proyecto usa el keystore de debug ubicado en:
- `C:/Users/jatni/.android/debug.keystore`
- Configurado en: `android/key.properties`

### Para Producción (Play Store):

1. Genera un keystore de producción:
```powershell
keytool -genkey -v -keystore app-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Actualiza `android/key.properties`:
```properties
storePassword=tu-password-seguro
keyPassword=tu-password-seguro
keyAlias=upload
storeFile=C:/ruta/a/app-release-key.jks
```

3. **Guarda el keystore y las contraseñas de forma segura** — los necesitarás para todas las actualizaciones futuras.

---

## 🚀 Comandos Rápidos

```powershell
# Generar iconos
flutter pub run flutter_launcher_icons:main

# Build APK de producción
flutter build apk --release --flavor production --target lib/main_production.dart

# Instalar en celular conectado
flutter install --flavor production

# Verificar dispositivos conectados
flutter devices
```

---

## 📝 Notas Importantes

1. **Flavors disponibles:**
   - `production` - App de producción (sin sufijo en package name)
   - `staging` - Para testing pre-producción (.stg)
   - `development` - Para desarrollo (.dev)

2. **Primera instalación:**
   - Si la app ya está instalada con un flavor diferente, desinstálala primero
   - Cada flavor se instala como una app separada

3. **API Local vs Deployed:**
   - Con API local (`localhost:3000`): La app solo funciona cuando el celular está en la misma red WiFi que tu laptop Y la API está corriendo
   - Con API deployed: La app funciona en cualquier lugar con internet

4. **Permisos de Internet:**
   - Ya están configurados en `android/app/src/main/AndroidManifest.xml`

---

## 🔄 Actualizar la App en el Celular

Cada vez que hagas cambios:

```powershell
# 1. Rebuild
flutter build apk --release --flavor production --target lib/main_production.dart

# 2. Reinstalar
flutter install --flavor production
```

O simplemente transfiere el nuevo APK a tu celular y reinstala.

---

## ❓ Troubleshooting

**Problema:** "App not installed"
- **Solución:** Desinstala la versión anterior primero

**Problema:** La app no se conecta a la API
- **Solución:** Verifica que `api_config.dart` apunta a la URL correcta y que la API está accesible desde el celular

**Problema:** "Installation failed"
- **Solución:** Activa "Instalar apps desconocidas" en configuración de Android

**Problema:** El icono no cambió
- **Solución:** Desinstala la app completamente y reinstala
