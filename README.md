# firebase_ai_testing

Projeto POC (Proof-of-Concept) em Flutter para experimentar integrações e recursos de AI do Firebase.

Descrição
- **Objetivo:** Provar e testar integrações do Firebase (Core, App Check e recursos de AI) junto com uma UI de câmera para captura/preview, usando patterns de injeção de dependência e roteamento.
- **Tipo:** Aplicação mobile multiplataforma (Android / iOS) construída com Flutter.

Estrutura principal do projeto
- `lib/` — código-fonte Dart do app
	- `main.dart` — inicialização do Firebase, App Check e injeção de dependências; monta o `MaterialApp.router`.
	- `firebase_options.dart` — opções de Firebase geradas (FlutterFire CLI).
	- `config/` — configurações e registro de dependências (`dependencies.dart`).
	- `routing/` — configuração de rotas (usa `go_router`).
	- `ui/` — componentes e telas (ex.: `camera_preview`, `home`, `expense`).
	- `utils/` — utilitários e tipos auxiliares.

Dependências importantes (ver `pubspec.yaml`)
- `firebase_core` — inicialização e integração com Firebase.
- `firebase_ai` — (POC) pacote relacionado a recursos de AI do Firebase.
- `camera` — integração com câmera para preview/captura.
- `firebase_app_check` — proteção de backend do Firebase (App Check).
- `go_router` — roteamento declarativo.
- `get_it` + `injectable` — injeção de dependências e geração de código.
- `freezed` + `freezed_annotation` + `json_serializable` — geração de modelos imutáveis e (de)serialização.

Pontos de atenção / configuração
- Arquivos nativos do Firebase:
	- Android: `android/app/google-services.json` (já presente no repositório `app/`)
	- iOS: `ios/Runner/GoogleService-Info.plist` (já presente no projeto iOS)
- O arquivo `lib/firebase_options.dart` foi gerado pela FlutterFire CLI e contém chaves/IDs do projeto Firebase (expostas aqui). Se for publicar o projeto, considere rotacionar credenciais e remover valores sensíveis do repositório.
- O `main.dart` define uma constante `kWebRecaptchaSiteKey` para App Check em Web. Ajuste essa chave se for usar outros ambientes.

Como rodar localmente
1. Instale o Flutter (compatível com SDK >= a versão do `pubspec.yaml`).
2. No terminal, na raiz do projeto:

```
flutter pub get
```

3. Para gerar código (injeção, modelos, etc):

```
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Para rodar no Android/iOS:

```
flutter run
```

Notas sobre desenvolvimento
- Uso de App Check: o projeto ativa `FirebaseAppCheck` no `main.dart` com providers diferentes para debug / release. Em release, usa `AndroidPlayIntegrityProvider`/`AppleDeviceCheckProvider`.
- Geração de código: mantenha o `build_runner` atualizado e rode-o sempre que alterar anotações (`@Injectable`, `@freezed`, etc.).
- Câmera: a UI de preview da câmera está em `lib/ui/camera_preview/` (viewmodels e widgets). Para testar a câmera, execute em um dispositivo real ou em emulador com suporte.

Contribuição e próximos passos recomendados
- Ajustar chaves sensíveis: remova ou proteja credenciais do `firebase_options.dart` antes de publicar o repositório publicamente.
- Documentar fluxos de uso do Firebase AI dentro do app (ex.: endpoints, formatos de dados esperados).
- Adicionar testes unitários / widget tests para componentes críticos.

Contato
- Autor/maintainer: configuração local do repositório (ver `lib/config/dependencies.dart` e comentários no código).

---
Arquivo atualizado automaticamente pelo assistente. Se quiser, eu também posso:
- adicionar seção de exemplos de chamadas ao Firebase AI;
- extrair instruções de configuração de Firebase mais detalhadas (FlutterFire CLI);
- ou commitar as mudanças para você.
