# Cardápio Digital (flutter-restaurant)

Aplicativo em **Flutter** para pedidos dentro de um restaurante. O cliente vê o cardápio da mesa, abre os detalhes de um prato e monta o pedido para enviar à cozinha.

> Atividade "Saia da 5ª Série" — Primeira Parte: definindo o layout.

## Telas

| # | Tela | Arquivo | O que mostra |
|---|------|---------|--------------|
| 1 | Cardápio | `pages/menu_page.dart` | Mesa, busca, categorias e lista de pratos |
| 2 | Validação da busca | `pages/menu_page.dart` | Erro no campo quando a busca está vazia ou só com espaços |
| 3 | Resultados da pesquisa | `pages/search_results_page.dart` | Termo pesquisado e pratos encontrados |
| 4 | Nenhum resultado | `pages/search_results_page.dart` | Aviso e botão "Nova pesquisa" |
| 5 | Carregando | `widgets/state_view.dart` | Indicador enquanto o cardápio/pesquisa carrega |
| 6 | Sem conexão | `widgets/state_view.dart` | Aviso e botão "Tentar novamente" |
| 7 | Detalhe do prato | `pages/item_detail_page.dart` | Descrição, quantidade, observações e "Adicionar ao pedido" |
| 8 | Meu pedido | `pages/order_page.dart` | Itens, total e "Enviar pedido" |
| 9 | Pedido vazio | `pages/order_page.dart` | Aviso e botão "Ver cardápio" |
| 10 | Pedido enviado | `pages/order_sent_page.dart` | Confirmação e "Voltar ao cardápio" |

> Para ver a tela **Sem conexão**, use o menu ⋮ do Cardápio → "Simular sem conexão".

## Navegação

As rotas ficam em `lib/routes.dart`:

```
Cardápio ──(Pesquisar)──▶ Resultados ──(toque no prato)──▶ Detalhe
   │  ▲                       │
   │  └────(Nova pesquisa)────┘
   ├──(toque no prato)──▶ Detalhe ──(Adicionar)──▶ volta
   └──(aba Pedido / Ver pedido)──▶ Meu pedido ──(Enviar)──▶ Pedido enviado ──(Voltar ao cardápio)──▶ Cardápio
```

| Rota | Tela | Argumento |
|------|------|-----------|
| `/` | Abas Cardápio e Pedido | — |
| `/pesquisa` | Resultados da pesquisa | termo (`String`) |
| `/prato` | Detalhe do prato | prato (`MenuItem`) |
| `/pedido-enviado` | Pedido enviado | — |

## Funcionalidades

- [x] Layout de todas as telas
- [x] Navegação entre as telas
- [x] Pesquisa por nome com validação (vazio/espaços)
- [x] Filtro por categoria
- [x] Estados de carregamento, erro de conexão e nenhum resultado
- [x] Pedido com quantidade, total e envio
- [ ] Dados vindos de um servidor real

## Tecnologias

- [Flutter](https://flutter.dev/) e Dart
- Material 3

## Como rodar

```bash
flutter pub get
flutter run
```
