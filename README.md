# Garfada

Aplicativo de receitas feito em **Flutter**. Lista receitas da API pública [DummyJSON](https://dummyjson.com/docs/recipes), permite pesquisar por nome, ver os detalhes de cada receita e salvar as favoritas.

## Funcionalidades

- Lista de receitas carregada da API DummyJSON (`/recipes`)
- Pesquisa de receitas por nome (`/recipes/search`)
- Tela de detalhes da receita (ingredientes, modo de preparo e informações gerais)
- Favoritar e desfavoritar receitas, com aba própria de Favoritos
- Estados de carregamento, erro de conexão e nenhum resultado
- Opção "Simular sem conexão" (menu ⋮ da tela inicial) para testar o estado de erro

## SDK utilizado

- **Flutter** 3.47 (canal stable)
- **Dart SDK** `^3.13.7`

## Dependências

| Pacote | Uso |
|--------|-----|
| `flutter` (SDK) | Framework de interface |
| `http` ^1.6.0 | Requisições à API DummyJSON |
| `cupertino_icons` ^1.0.8 | Ícones no estilo iOS |
| `flutter_lints` ^6.0.0 (dev) | Regras de análise de código |
| `flutter_test` (dev) | Testes |

## Como executar

Pré-requisitos: Flutter instalado ([guia oficial](https://docs.flutter.dev/get-started/install)) e um emulador, dispositivo ou navegador disponível.

```bash
# 1. Clonar o repositório
git clone <url-do-repositorio>
cd flutter-restaurant

# 2. Instalar as dependências
flutter pub get

# 3. Executar o app
flutter run
```

O app precisa de acesso à internet para buscar as receitas.
