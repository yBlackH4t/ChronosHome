# Chronos Home

App de **estoque da casa no celular** (Android primeiro): bipar as compras, abrir, acabou, lista de
compras, gráficos e assistente de IA. Feito em **Flutter**, com os dados no próprio celular.
Produto separado do Chronos Inventory (o app da empresa), com outro repositório, outro nome e
outras atualizações.

## Antes de qualquer tarefa

- Leia `docs/CONTEXTO.md`: decisões, stack, plano e cuidados. Atualize-o quando o estado mudar.

## Regras

- O dono fala português do Brasil, **não quer custos** e prefere passos curtos com comandos
  prontos. Textos do app e da documentação em português do Brasil.
- **Nunca peça nem mostre chaves de API** (Groq). No app, a chave é digitada pelo usuário e fica
  no armazenamento seguro do Android; nunca no código nem no git.
- Trabalhe em branches; o merge na `main` é feito só pelo dono.
- Teste no celular do dono (**Galaxy A10s, Android 11, 32 bits / `armeabi-v7a`**): é fraco de
  propósito; o que roda liso nele roda em qualquer um.
- Bibliotecas: versões fixas e lançadas há pelo menos duas semanas.

## Verificações

```powershell
flutter analyze
flutter test
flutter build apk --debug --target-platform android-arm
```
