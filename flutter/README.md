# Smanck

Squelette d'application flutter

## Prérequis

- [Flutter](https://flutter.dev/docs/get-started/install)
  - version minimum : 3.13.6
- [Visual Studio Code](https://code.visualstudio.com/download) (recommandé)
  - Plugins VSCode:
    [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
    [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
    [Flutter Intl](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl)
    [Pubspec Assist](https://marketplace.visualstudio.com/items?itemName=jeroen-meijer.pubspec-assist)

#### Vérifier la version de Flutter :

```bash
flutter --version
```

#### Vérifier que Flutter est correctement installé :

```bash
flutter doctor
```

#### Installer les librairies du projet :

```bash
flutter pub get
```

## Lancement du projet en local

#### Lancement du projet en mode debug

En ligne de commande (mais preferez VSCode) :

```bash
flutter run -d chrome
```

En utilisant VSCode :

- Ouvrir le projet dans VSCode
- Sélectionner le device `Chrome` dans la barre de status
- Vérifier la configuration de lancement (cf. `.vscode/launch.json`)
- Vérifier que le fichier `lib/main.dart` est ouvert
- Dans le menu latéral, sélectionner `Run and Debug`
- Selectionner la configuration souhaitée dans le menu déroulant (ex: `Dev Preprod`)
- Cliquer sur le bouton `Run and Debug` (ou `F5`)

NB:
En local, préférer la configuration `Dev` avec API locale et BDD locale.
Car la configuration `Preprod` utilise l'API de préprod et pose un problème de CORS pour la connexion des socket.

## Architecture

- `assets` : contient les ressources du projet
  - `fonts` : fonts du projet. Inclure les fonts dans le projet via le fichier `pubspec.yaml` (cf. [documentation](https://flutter.dev/docs/cookbook/design/fonts))
  - `img` : images du projet
- `build` : contient les fichiers générés par flutter (ne pas modifier)
  - `web` : contient les fichiers générés par flutter pour le web (ne pas modifier)
- `lib` : contient le code source du projet
  - `generated` : contient les fichiers I10n générés par flutter (ne pas modifier)
  - `I10n` : contient les fichiers I10n du projet
    - `intl_en.arb` : contient les traductions en anglais du projet
    - `intl_fr.arb` : contient les traductions en français du projet
  - `shared` : contient les fichiers partagés du projet
    - `models` : contient les modèles de données du projet
    - `services` : contient les services du projet
    - `api.config.dart` : contient la configuration de l'API
    - `resource.dart` : contient les ressources du projet
    - `utils.dart` : contient les fonctions utilitaires du projet
  - `themes` : contient les fichiers de thèmes du projet
  - `ui` : contient les fichiers de l'interface du projet
    - `layout` : contient les fichiers de layout du projet
    - `navigation` : contient les fichiers de navigation du projet
      - `application.state.dart` : contient la classe d'état interne de l'application (ex: current user)
      - `navigation_delegate.dart` : contient la classe de navigation du projet (C'est cette classe qui en fonction de l'etat de l'application va afficher la bonne page)
      - `navigation_path.dart` : classes de navigation du projet. Contient ce qui peut être extrait de l'URL
      - `navigation_route_parser.dart` : contient la classe de parsing de l'URL du projet
      - `navigation.state.dart` : contient la classe d'état de navigation du projet (ex: current screen)
    - `screens` : contient les fichiers d'écran du projet
    - `widgets` : contient les fichiers de widget du projet
  - `main.dart` : point d'entrée de l'application

## Compilation

### Versionning

Le fichier `.build-info` contient le code de version de l'application. Il est utilisé par le script `build.bat` pour toutes nouvelles compilations (et sera affiché dans l'application).

Pour compiler une nouvelle version, il faut exécuter le script `build.bat` avec l'option `--major`, `--minor` ou `--patch` ainsi :

```bash
.\build.bat --patch
```

### Production

Le fichier `.env.prod` contient les variables d'environnement pour la compilation en production. Il est utilisé par le script `build.bat` pour la compilation en production.

Pour compiler en production, il faut exécuter le script `build.bat` ainsi :

```bash
.\build.bat --env prod
```

### Développement

Copier le fichier `.env.prod` en `.env` et modifier les variables d'environnement pour la compilation en développement.

Pour compiler en développement, il faut exécuter le script `build.bat` ainsi :

```bash
.\build.bat
```

### Autres environnements

Pour compiler en d'autres environnements, il faut créer un fichier `.env.<env>` et modifier les variables d'environnement pour la compilation en `<env>`.

Pour compiler en `<env>`, il faut exécuter le script `build.bat` ainsi :

```bash
.\build.bat --env <env>
```

## Déploiement

Si possible éviter de cloner l'intégralité du projet sur le serveur de production.
Seulement les fichiers suivants sont nécessaires :

- `build/web`

Pour ce faire, il est possible de réaliser un clone partiel du projet en utilisant la commande suivante :

```bash
git clone --depth 1 --filter=blob:none --no-checkout --branch prod <url> <folder>
cd <folder>
git config core.sparseCheckout true
echo "build/web/*" >> .git/info/sparse-checkout
git pull
git checkout prod
```

En cas de mise à jour du projet, il est possible de mettre à jour le clone partiel en utilisant la commande suivante :

```bash
git pull
```
