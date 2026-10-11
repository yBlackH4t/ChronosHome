# Desenvolvimento

Como preparar o PC, rodar o app, testar no celular e mandar mudanças para o GitHub.

## Preparar o PC (Windows)

| O quê | Versão | Onde |
|---|---|---|
| Flutter | **3.47.5** (stable, Dart 3.13.4) | `C:\src\flutter`, com `C:\src\flutter\bin` no PATH |
| Android Studio + SDK | SDK 36, build-tools 36 | `%LOCALAPPDATA%\Android\Sdk` |
| NDK | **30.0.16248370** | já instalado; o `android/app/build.gradle.kts` aponta para ele |
| Java | o que vem com o Android Studio | `JAVA_HOME` = `C:\Program Files\Android\Android Studio\jbr` |

Conferir:

```powershell
flutter doctor
```

Tudo deve sair com `[√]`.

## Comandos do dia a dia

```powershell
flutter pub get                       # baixa as bibliotecas
dart run build_runner build           # gera o código do drift (depois de mexer em lib/dados)
flutter analyze                       # procura erros no código
flutter test                          # roda os testes
flutter build apk --debug --target-platform android-arm   # APK para o A10s
```

## Testar no celular

O celular de teste é o **Galaxy A10s** (Android 11, 32 bits, `armeabi-v7a`). Ele é fraco de
propósito: o que roda liso nele roda em qualquer um.

1. Ligue a **depuração USB** no celular e conecte o cabo.
2. Confira se ele aparece:

   ```powershell
   flutter devices
   ```

3. Rode direto no celular:

   ```powershell
   flutter run
   ```

   Ou instale o APK já gerado:

   ```powershell
   & "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" install -r build\app\outputs\flutter-apk\app-debug.apk
   ```

## Bibliotecas

- **Versões fixas** no `pubspec.yaml` (sem `^`), todas lançadas há **pelo menos duas semanas**.
- O `analyzer` está fixo em 14.4.0: o 14.5.0 quebra o `drift_dev` 2.35.0.
- Ao trocar uma versão, anote o motivo num comentário no `pubspec.yaml`.

## Branches, commits e PRs

- A `main` só recebe código por **pull request**, e quem faz o merge é o dono.
- **Um PR por passo do plano** ([CONTEXTO.md](CONTEXTO.md), seção 7). O PR conta o que mudou,
  como foi testado (incluindo no A10s) e o que ficou para depois; o modelo está em
  `.github/pull_request_template.md`.
- Commits pequenos, em português, no formato `tipo: o que mudou`:
  - `feat:` coisa nova para quem usa o app
  - `fix:` correção
  - `docs:` só documentação
  - `test:` só testes
  - `chore:` manutenção (versões, configuração)
- Todo PR roda a verificação automática do GitHub (`.github/workflows/ci.yml`): `flutter analyze`
  e `flutter test`. O PR só vai para merge com ela verde.
- Ao terminar um passo, atualize a seção de estado do [CONTEXTO.md](CONTEXTO.md) e a tabela de
  andamento do [README](../README.md).

## Segredos

- **Nunca** coloque chaves (Groq, assinatura do APK) no código ou no git.
- A chave do Groq será digitada no app e guardada no armazenamento seguro do Android.
