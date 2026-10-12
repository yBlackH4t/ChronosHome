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
| Criptografia do banco | `sqlite3` 3.x com `hooks: user_defines: sqlite3: source: sqlcipher` no `pubspec.yaml` (o `sqlcipher_flutter_libs` foi descontinuado) | banco ilegível fora do app |
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

**Passo 2 (2026-10-11):** telas de prova (Bipar, Banco criptografado, Animação) em `lib/telas/`,
banco drift em `lib/dados/` com uma tabela `leituras` provisória. Versões: `mobile_scanner` 7.4.2,
`drift`/`drift_dev` 2.35.0, `sqlite3` 3.6.0 (SQLCipher), `flutter_secure_storage` 11.2.0,
`build_runner` 2.16.1, `uuid` 4.6.0. O `analyzer` está fixo em 14.4.0 porque o 14.5.0 quebra o
`drift_dev` 2.35.0. A chave do banco (32 bytes aleatórios) fica no Keystore; o arquivo é
`chronos_home.db` na pasta de documentos do app. O APK leva `lib/armeabi-v7a/libsqlcipher.so`.
Depois de mudar `lib/dados/banco.dart`: `dart run build_runner build`. **Testado pelo dono no A10s:
câmera, banco criptografado (sobrevive a fechar e abrir) e animação funcionando.**

**Passo 3 (2026-10-11):** modelo da seção 5 em `lib/dados/tabelas.dart` (esquema **versão 2**) e
regras em `lib/dados/banco.dart`: `cadastrarProduto`, `produtoPorCodigo`, `darEntrada`, `abrir`,
`acabar`, `descartar`, `mover`, `unidadeParaAbrir` (a que vence primeiro; sem validade, a mais
antiga) e `unidadeParaAcabar` (a aberta há mais tempo). Transição proibida lança
`TransicaoInvalida` e nada fica pela metade (tudo em transação). Locais padrão: Despensa, Geladeira,
Freezer. `foreign_keys` ligado. A migração 1 → 2 cria as tabelas novas e mantém a `leituras` do
passo 2 (provisória, sai no passo 4). Testes em `test/banco_test.dart` (18 no total), incluindo a
migração e a conferência do esquema com `validateDatabaseSchema`.

**Passo 4 (2026-10-11):** tela **Compras** (`lib/telas/compras.dart`): a câmera lê EAN/UPC;
produto conhecido entra direto como unidade fechada no local escolhido (Despensa por padrão); o
mesmo código só conta de novo depois de 2 segundos; botões + e − na lista "nesta compra" (o −
usa `desfazerEntrada`, que só vale para unidade ainda não usada). Código desconhecido abre
**Produto novo** (`lib/telas/produto_novo.dart`), que busca no **Open Food Facts**
(`lib/servicos/open_food_facts.dart`, pacote `http` 1.6.0, sem chave; nome em português quando
houver, marca, categoria mais específica e foto) e deixa conferir, escolher a quantidade e salvar;
sem internet, avisa e deixa preencher à mão. A **tela inicial** agora lista o estoque
(`observarEstoque`) com o botão Compras. Banco **versão 3**: sai a tabela `leituras` e as telas de
prova do passo 2. Permissão `INTERNET` no manifesto principal. 28 testes (com o Open Food Facts
simulado). **Testado pelo dono no A10s: funcionando.**

**Passo 5 (2026-10-11):** tela **Cozinha** (`lib/telas/cozinha.dart`): bipou → abre o painel de
ações do produto (`lib/componentes/acoes_do_produto.dart`) com **Abrir**, **Acabou** e
**Descartar**. O botão em destaque é a sugestão: **Acabou** se já há um aberto, senão **Abrir**.
O painel mostra quantos fechados e abertos há e há quantos dias o mais antigo está aberto. Depois
do toque aparece um aviso com **Desfazer** (`desfazerUltimaAcao` no banco: volta o estado e apaga
a linha do histórico). Código não cadastrado manda usar Compras. O mesmo painel abre tocando no
produto no Início, que agora tem os botões Compras e Cozinha embaixo. 33 testes. **Testado pelo
dono no A10s: funcionando.**

**Passo 6 (2026-10-11):** o **Início** tem três abas. **Agora**: produtos abertos, do mais
urgente para o menos (passou do prazo, acabando, depois o aberto há mais tempo), com "aberto há N
dias" contado em dias de calendário e o aviso pelo prazo depois de aberto; e **Acabando** (só sobrou
o aberto). **Comprar**: produtos abaixo do estoque mínimo com quanto falta, número na aba e botão
"Copiar a lista" (texto para colar no WhatsApp). **Estoque**: tudo o que tem em casa. As contas
ficam em `lib/dados/resumo.dart` (sem banco nem tela, testadas com qualquer data). O painel do
produto ganhou os ajustes **Estoque mínimo** e **Dura depois de aberto** (`ajustarProduto`), que
alimentam a lista e os avisos. `observarEstoque` agora traz `abertoDesde`. 43 testes. **Testado
pelo dono no A10s: funcionando.**

**Passo 7 (2026-10-11):** **validade opcional** na entrada: em Compras, tocar no item da lista
abre o calendário (vale para as unidades daquela compra, e as próximas herdam); em Produto novo há
o campo "Validade (opcional)". Calendário e textos do Flutter em português (`flutter_localizations`).
A aba **Agora** ganhou **Vencendo** (até 3 dias à frente ou já vencido). **Avisos no celular**
com `flutter_local_notifications` 22.3.1, `timezone` 0.11.1 e `flutter_timezone` 5.1.0: as contas
ficam em `lib/dados/avisos.dart` (véspera e dia da validade; último dia do prazo depois de aberto
e o dia seguinte; sempre às 9h; no máximo 40, os mais próximos) e o agendamento em
`lib/servicos/avisos_no_celular.dart`, refeito a cada mudança do estoque. Agendamento **inexato**
(sem pedir permissão de alarme exato): pode atrasar minutos, mas sai no dia certo. Android:
desugaring ligado (`desugar_jdk_libs` 2.1.4), permissões `POST_NOTIFICATIONS` e
`RECEIVE_BOOT_COMPLETED` e os recebedores do plugin no manifesto. 50 testes. **Testado pelo dono
no A10s: sem erros.**

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
