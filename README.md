# Chronos Home

Estoque da casa no celular: bipar as compras, abrir, acabou, lista de compras, avisos de
validade, gráficos e assistente de IA. Os dados ficam no próprio celular, **criptografados**.

Feito em **Flutter** (Android primeiro). Produto separado do
[Chronos Inventory](https://github.com/yBlackH4t/ChronosInventory), o app de estoque da empresa.

## Como vai funcionar

| Momento | O que a pessoa faz |
|---|---|
| Chegou das compras | bipa cada item → entrada no estoque |
| Abriu um produto | bipa → "Abrir?" → um toque |
| Acabou | bipa → "Acabou?" → um toque |
| No dia a dia | avisos: "maionese aberta há 5 dias", "o iogurte vence amanhã", lista de compras |
| Dúvida rápida | assistente: "tem extrato de tomate?" |

## Andamento

| Passo | Entrega | Situação |
|---|---|---|
| 0 | Flutter instalado | ✅ |
| 1 | App criado: nome, tema claro/escuro e ícone | ✅ |
| 2 | Prova no A10s: câmera, banco criptografado, animação | ✅ testado no celular |
| 3 | Modelo de dados com regras de estado e migração | ✅ |
| 4 | Compras: bipar → entrada; produto novo pelo Open Food Facts | ⏳ |
| 5 | Cozinha: bipar → Abrir ou Acabou | |
| 6 | Início: abertos há N dias, acabando, lista de compras | |
| 7 | Avisos e validade | |
| 8 | Gráficos | |
| 9 | Assistente (Groq) | |
| 10 | Digital, backup e restauração | |
| 11 | Versão 1.0 nas GitHub Releases (instalação pelo Obtainium) | |

O plano completo, as decisões e os riscos estão em [docs/CONTEXTO.md](docs/CONTEXTO.md).

## Documentação

| Documento | Para quê |
|---|---|
| [docs/CONTEXTO.md](docs/CONTEXTO.md) | O que é, decisões, stack, plano e estado de cada passo |
| [docs/ARQUITETURA.md](docs/ARQUITETURA.md) | Pastas, banco de dados, regras de estado e criptografia |
| [docs/DESENVOLVIMENTO.md](docs/DESENVOLVIMENTO.md) | Preparar o PC, rodar, testar no celular e o fluxo de branches e PRs |

## Começo rápido

Com o Flutter 3.47.5 instalado (veja [docs/DESENVOLVIMENTO.md](docs/DESENVOLVIMENTO.md)):

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

## Licença

Projeto pessoal; todos os direitos reservados.
