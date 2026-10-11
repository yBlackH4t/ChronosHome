# Chronos Home — comece por aqui

Contexto para começar o projeto numa conversa nova. Escrito em 2026-10-11, a partir das decisões
tomadas com o dono numa conversa sobre o Chronos Inventory.

---

## 1. O que é

Um app para **gerenciar o estoque da casa pelo celular**: alimentos, produtos de limpeza e o que
mais a pessoa guarda. Não é para vender: é para **saber o que tem, o que está aberto, o que está
acabando e o que vence**.

O uso típico:
- **Chegou das compras:** bipa cada item → entrada.
- **Na cozinha:** abriu um extrato de tomate → bipa → "Abrir?" → um toque. Acabou → bipa →
  "Acabou?" → um toque.
- **Avisos:** "maionese aberta há 5 dias", "o iogurte vence amanhã", lista de compras automática.
- **Assistente:** "tem extrato de tomate?", "o que vence esta semana?".

## 2. Por que um app separado

- O Chronos Inventory (`github.com/yBlackH4t/ChronosInventory`) é o app de estoque **da empresa**
  (turbinas, várias filiais). A empresa não deve ver "modo casa".
- **Repositório separado** porque o Chronos atualiza a partir das versões publicadas no repositório
  dele: publicar o app de casa lá faria os computadores da empresa receberem a versão de casa.
- O Chronos é "computador primeiro" (Python + FastAPI + SQLite no PC). Em casa, ninguém vai ao
  computador dar baixa num extrato de tomate: o Chronos Home é **"celular primeiro"**.

## 3. Decisões

| Decisão | Escolha | Motivo |
|---|---|---|
| Plataforma | **Android** primeiro (iPhone depois, se fizer sentido) | o celular do dono é Android |
| Onde ficam os dados | **No celular** | funciona sem internet e sem PC ligado; nada exposto na rede |
| Quantos celulares | **Um só** na primeira versão | sincronizar vários vem depois; desde já os registros usam **UUID** para isso ser possível |
| Framework | **Flutter (Dart)** | escolha do dono: visual mais fluido e bonito no celular (motor gráfico próprio). React Native e Tauri 2 foram avaliados (seção 9) |
| Assistente de IA | **Vai junto**, chamando o **Groq** (plano gratuito) direto do celular | sem custo; a chave é do usuário |
| WhatsApp | **Não** nesta fase | precisaria de um aparelho sempre ligado como ponte |

## 4. Stack (a conferir e fixar versões no passo 1)

| Camada | Pacote (pub.dev) | Para quê |
|---|---|---|
| Interface | Flutter + **Material 3** | telas, tema claro e escuro, animações |
| Estado | `flutter_riverpod` | estado das telas, testável |
| Navegação | `go_router` | abas e telas |
| Banco | `drift` (SQLite com tipos e migrações) | dados no celular |
| Criptografia do banco | `sqlcipher_flutter_libs` (SQLCipher) | banco ilegível fora do app |
| Chaves | `flutter_secure_storage` (Android Keystore) | chave do banco e a do Groq |
| Desbloqueio | `local_auth` (digital) | abrir o app com a digital |
| Código de barras | `mobile_scanner` | câmera lendo EAN-13, EAN-8, UPC, QR |
| Produtos novos | API do **Open Food Facts** (`openfoodfacts`, ou HTTP direto) | nome, marca e foto pelo código de barras |
| Avisos | `flutter_local_notifications` | vence amanhã, aberto há N dias |
| Gráficos | `fl_chart` | consumo, gastos, desperdício |
| Rede | `dio` ou `http` | Groq e Open Food Facts |
| Testes | `flutter_test`, testes do drift em memória | regras e banco |

Empacotamento e atualização:
- `flutter build apk --split-per-abi`: o A10s usa o `armeabi-v7a`.
- Versões publicadas nas **GitHub Releases** deste repositório. No celular, o app gratuito
  **Obtainium** acompanha as releases e instala as novas. Sem Play Store, que só faz falta para
  distribuir ao público (taxa única de cadastro).
- **Backup:** exportar o banco criptografado (arquivo ou Google Drive) e importar de volta.

## 5. Modelo de dados (rascunho)

| Tabela | Campos principais |
|---|---|
| `produtos` | `id` (UUID), `nome`, `marca`, `categoria`, `foto`, `estoque_minimo`, `dias_validade_aberto`, `criado_em` |
| `codigos_barras` | `codigo` (único), `produto_id` (um produto pode ter vários códigos) |
| `locais` | `id`, `nome` (Despensa, Geladeira, Freezer...) |
| `unidades` | cada **unidade física** em casa: `id`, `produto_id`, `local_id`, `estado` (fechado, aberto, acabou, descartado), `entrou_em`, `aberto_em`, `saiu_em`, `vence_em` (opcional) |
| `movimentos` | histórico: `id`, `unidade_id`, `acao` (entrada, abrir, acabou, descartar, mover), `quando` |

Guardar **cada unidade** (e não só "quantos tenho") é o que permite "aberto há N dias", validade
por unidade e "descartado" para medir desperdício. A quantidade é a contagem de unidades.
Quantidades em kg ou litros com decimais ficam para depois.

## 6. Lições da prova de conceito (feita em Tauri, 2026-10-11)

A prova de conceito (branch `claude/poc-casa-android` do Chronos Inventory) mostrou o ambiente
funcionando neste PC:
- **Android Studio + SDK + NDK já instalados**, com `JAVA_HOME`, `ANDROID_HOME` e `NDK_HOME`
  configurados para o usuário. **Modo de Desenvolvedor do Windows ligado.**
- **Celular:** Galaxy A10s (Android 11, `armeabi-v7a`), depuração USB autorizada, cabo de dados
  funcionando. `adb` em `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe`.
- **A permissão da câmera precisa ser pedida pelo app** antes de usar; sem isso o Android a deixa
  negada (no Flutter, o `mobile_scanner` cuida disso, mas o erro precisa aparecer legível).
- A câmera leu o EAN de uma maionese sem problemas.
- No Windows, o `python` do PATH é o 3.14 de 32 bits (não importa aqui: o Chronos Home não usa
  Python).

## 7. Plano

| Passo | Entrega | Pronto quando |
|---|---|---|
| 0 | **Instalar o Flutter** (flutter.dev → Windows → baixar o zip, extrair em `C:\src\flutter`, pôr `C:\src\flutter\bin` no PATH), `flutter doctor`, `flutter doctor --android-licenses` | `flutter doctor` sem erro na parte Android |
| 1 | `flutter create` (org `com.yblackh4t`, nome `chronos_home`), versões fixas, tema, ícone e nome "Chronos Home" | app abre no A10s |
| 2 | **Prova das partes arriscadas no A10s:** bipar com `mobile_scanner`, gravar no banco **criptografado** e reabrir, uma tela com animação | as três funcionam lisas no A10s |
| 3 | Banco (seção 5) com migrações e testes | testes das regras de estado |
| 4 | **Compras:** bipar → entrada; produto novo → Open Food Facts → confirmar | cadastrar e dar entrada só bipando |
| 5 | **Cozinha:** bipar → sugere Abrir ou Acabou → um toque; Descartar | estados e histórico certos |
| 6 | **Início:** abertos há N dias, acabando, lista de compras (estoque mínimo) | listas certas |
| 7 | **Avisos** (notificações locais) e **validade** opcional na entrada | aviso aparece no dia certo |
| 8 | **Gráficos** (consumo, desperdício) | — |
| 9 | **Assistente** (Groq, chave digitada no app) | responde sobre o estoque |
| 10 | **Segurança:** digital para abrir, backup e restauração | restaurar um backup em outro celular |
| 11 | **Versão 1.0:** APK assinado, GitHub Release, Obtainium | instalado e atualizando pelo Obtainium |

**Estado (2026-10-11):** passo 0 feito. Flutter **3.47.5** (stable, Dart 3.13.4) em
`C:\src\flutter`, com `C:\src\flutter\bin` no PATH do usuário e analytics desligado. A 3.47.7
existia, mas tinha menos de duas semanas. `flutter doctor` sem problemas: licenças Android aceitas
e o A10s aparece como `SM A107M (android-arm)`.

**Passo 1 (2026-10-11):** projeto criado com `flutter create` (só Android), pacote
`com.yblackh4t.chronos_home`, nome "Chronos Home", Material 3 com tema claro e escuro (cor
`#1E5E57`) e ícone próprio (casa com relógio: vetor adaptável + PNGs). `cupertino_icons` removido;
`flutter_lints` fixo em 6.0.0. O Flutter 3.47.5 pede o NDK 28.2, que não está instalado; o
`android/app/build.gradle.kts` aponta para o **NDK 30.0.16248370** que já existe no PC, e o build
`armeabi-v7a` passa. APK de debug instalado no A10s.

Cada passo: `flutter analyze`, `flutter test`, build e teste no A10s, depois commit e push numa
branch.

## 8. Riscos

1. **O A10s é fraco:** animações e listas precisam ser leves. Medir sempre nele.
2. **SQLCipher no Android de 32 bits:** provar no passo 2 antes de construir em cima.
3. **Flutter é Dart:** linguagem nova para o dono; explicar as decisões nos commits e na
   documentação.
4. **Perder a chave do banco = perder os dados:** o backup (passo 10) precisa levar um jeito de
   recuperar.

## 9. Por que Flutter (e não as outras)

- **Tauri 2:** reaproveitaria o Chronos e já funcionou na prova de conceito, mas no celular a tela
  é uma página web dentro do app, menos fluida num aparelho fraco. Ecossistema mobile jovem.
- **React Native + Expo:** visual nativo e mesma linguagem do Chronos (TypeScript); era a
  alternativa mais próxima.
- **Flutter:** motor gráfico próprio, o mais fluido e bonito de fábrica, com pacotes maduros para
  câmera, banco criptografado, digital e notificações. Custo: Dart é linguagem nova. **Escolhido
  pelo dono.**

## 10. Primeira mensagem na conversa nova

> Leia `CLAUDE.md` e `docs/CONTEXTO.md` e comece pelo passo 0 do plano.
