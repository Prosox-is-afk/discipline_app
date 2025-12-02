<!-- Copilot/AI agent instructions for the discipline_app Flutter project -->

# Guide rapide pour les agents d'aide au code

Ce dépôt est une application Flutter standard (multi-platforme) générée depuis le template Flutter.
Ces instructions donnent l'essentiel pour être immédiatement productif et respecter les conventions du projet.

**Architecture & points d'entrée**

-   **Racine app Flutter**: le point d'entrée est `lib/main.dart` (widget `MyApp`).
-   **Configuration des packages**: `pubspec.yaml` gère dépendances, assets et `publish_to: 'none'` (ne pas publier).
-   **Plateformes**: dossiers `android/`, `ios/`, `linux/`, `windows/`, `macos/`, `web/` contiennent les intégrations natives. Android utilise Gradle Kotlin DSL (`build.gradle.kts`).

**Flux de travail critique (communes)**

-   Installer dépendances: `flutter pub get`.
-   Analyse statique: `flutter analyze`. Le projet inclut `analysis_options.yaml` qui active `flutter_lints`.
-   Tests unitaires/widget: `flutter test` (voir `test/widget_test.dart`).
-   Lancer en mode développement: `flutter run` (hot reload: sauvegarder ou appuyer `r` dans la console; hot restart: `R`).
-   Construire artefacts: Android APK/AAB `flutter build apk` / `flutter build appbundle`, iOS `flutter build ios` (macOS requise), web `flutter build web`.
-   Sur Windows (PowerShell): lancer wrapper Gradle si nécessaire: `./gradlew.bat` depuis `android/` ; préférez `flutter` CLI.

**Conventions observées / choses à ne PAS faire**

-   Ne modifiez pas `publish_to` dans `pubspec.yaml` sans intention de publication.
-   Le code suit les lint rules de `flutter_lints` défini dans `analysis_options.yaml` — respecter ces règles.
-   Eviter de changer radicalement les structures de dossiers natives (`android/`, `ios/`) sans tests de build.

**Points d'intégration et fichiers clés**

-   `pubspec.yaml` — dépendances, assets, versioning.
-   `lib/main.dart` — point d'entrée et exemple de pattern Stateful/Stateless.
-   `analysis_options.yaml` — linter/rules du projet.
-   `android/app/build.gradle.kts` et `gradle/` — configuration Android (Kotlin DSL).
-   `ios/Runner/` — entêtes Swift/ObjC, bridging header et plist pour iOS metadata.

**Conseils pratiques pour agents**

-   Toujours lancer `flutter pub get` puis `flutter analyze` après modifications de dépendances.
-   Pour changements UI, utiliser `flutter run` et hot reload en dev; pour changement d'état global, recommander hot restart.
-   Quand vous modifiez des fichiers natifs (Gradle, Info.plist), exécutez un build complet (`flutter build`) pour valider.
-   Fournir exemples concrets dans les PRs: quels fichiers changés et commande testée (ex: `flutter test && flutter analyze`).

Si une section est incomplète ou si vous voulez que j'ajoute des exemples de commandes PowerShell spécifiques (ex: signing Android, config iOS), dites-le et je mets à jour ce fichier.
