# Arquitetura

Como o Chronos Home está organizado por dentro. As decisões e o porquê de cada uma estão em
[CONTEXTO.md](CONTEXTO.md).

## Pastas

```
lib/
  main.dart              início do app: tema, cores e abertura do banco
  dados/
    tabelas.dart         as tabelas do banco (drift) e os enums de estado
    banco.dart           o banco e as regras (entrada, abrir, acabou, descartar, mover)
    banco.g.dart         código gerado pelo drift: não editar à mão
    abrir_banco.dart     abre o arquivo com SQLCipher e cuida da chave no Keystore
  telas/
    inicio.dart          tela inicial
    bipar.dart           câmera lendo códigos (mobile_scanner)
    prova_banco.dart     confere o SQLCipher (prova do passo 2)
    animacao.dart        lista animada (prova do passo 2)
test/
  banco_test.dart        regras de estado e migração do banco
  widget_test.dart       tela inicial e SQLCipher
android/                 projeto Android (ícone, nome, NDK)
docs/                    documentação
```

Regra geral: **`dados/` não conhece telas**, e as telas falam com o banco só pelos métodos de
`Banco`. Assim as regras são testadas sem celular.

## Banco de dados

SQLite pelo [drift](https://drift.simonbinder.eu/), com SQLCipher. Esquema atual: **versão 2**.

```mermaid
erDiagram
    produtos ||--o{ codigos_barras : "tem"
    produtos ||--o{ unidades : "tem"
    locais ||--o{ unidades : "guarda"
    unidades ||--o{ movimentos : "histórico"

    produtos {
        text id PK "UUID"
        text nome
        text marca
        text categoria
        text foto
        int estoque_minimo
        int dias_validade_aberto
        datetime criado_em
    }
    codigos_barras {
        text codigo PK
        text produto_id FK
    }
    locais {
        text id PK
        text nome "Despensa, Geladeira, Freezer"
    }
    unidades {
        text id PK
        text produto_id FK
        text local_id FK
        text estado "fechado, aberto, acabou, descartado"
        datetime entrou_em
        datetime aberto_em
        datetime saiu_em
        datetime vence_em
    }
    movimentos {
        text id PK
        text unidade_id FK
        text acao "entrada, abrir, acabou, descartar, mover"
        datetime quando
        text local_id FK
    }
```

- Cada **unidade física** (um pote, uma lata) é uma linha em `unidades`. A quantidade em casa é a
  contagem das unidades fechadas ou abertas.
- Os ids são **UUID**, para um dia sincronizar mais de um celular sem conflito.
- A tabela `leituras` é provisória (prova do passo 2) e sai no passo 4.

## Regras de estado

```mermaid
stateDiagram-v2
    [*] --> fechado: entrada
    fechado --> aberto: abrir
    fechado --> acabou: acabar
    aberto --> acabou: acabar
    fechado --> descartado: descartar
    aberto --> descartado: descartar
    acabou --> [*]
    descartado --> [*]
```

- Qualquer outra transição lança `TransicaoInvalida`, e nada fica gravado pela metade (cada
  operação roda numa transação).
- Toda mudança gera uma linha em `movimentos`, usada depois para gráficos e desperdício.
- **Ao bipar para abrir**, o app escolhe a unidade fechada que vence primeiro; sem validade, a
  mais antiga.
- **Ao bipar para acabar**, escolhe a unidade aberta há mais tempo; se não houver, a próxima a abrir.

## Migrações

`schemaVersion` fica em `lib/dados/banco.dart`. Ao mudar o esquema:

1. Suba a versão e escreva o passo em `onUpgrade` (nunca apague dados do usuário).
2. Rode `dart run build_runner build`.
3. Escreva um teste que crie o banco da versão anterior e confira o novo
   (veja o teste de migração em `test/banco_test.dart`).

| Versão | Passo | Mudança |
|---|---|---|
| 1 | 2 | tabela `leituras` (prova da câmera) |
| 2 | 3 | `produtos`, `codigos_barras`, `locais`, `unidades`, `movimentos` e locais padrão |

## Criptografia

- O pacote `sqlite3` baixa o **SQLCipher** no lugar do SQLite comum, configurado no fim do
  `pubspec.yaml` (`hooks: user_defines: sqlite3: source: sqlcipher`).
- A chave do banco são 32 bytes aleatórios criados na primeira abertura e guardados no
  **Android Keystore** pelo `flutter_secure_storage`. Ela nunca aparece no código nem no git.
- Ao abrir, o app confere que o SQLCipher foi carregado; se não foi, recusa abrir para não gravar
  sem criptografia.
- Perder a chave (ex.: limpar os dados do app) é perder o banco. O backup do passo 10 vai tratar
  disso.
