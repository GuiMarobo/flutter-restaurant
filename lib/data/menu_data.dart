import 'package:flutter/material.dart';

import '../models/menu_item.dart';

const categories = ['Todos', 'Entradas', 'Pratos', 'Bebidas', 'Sobremesas'];

const menuItems = [
  MenuItem(
    name: 'Bruschetta',
    description: 'Pão italiano tostado com tomate, manjericão e azeite.',
    price: 24.90,
    category: 'Entradas',
    icon: Icons.bakery_dining,
  ),
  MenuItem(
    name: 'Batata Rústica',
    description: 'Batatas assadas com alecrim e molho da casa.',
    price: 29.90,
    category: 'Entradas',
    icon: Icons.restaurant,
  ),
  MenuItem(
    name: 'Filé à Parmegiana',
    description: 'Filé empanado com molho de tomate, queijo, arroz e fritas.',
    price: 59.90,
    category: 'Pratos',
    icon: Icons.dinner_dining,
  ),
  MenuItem(
    name: 'Risoto de Cogumelos',
    description: 'Arroz arbóreo cremoso com mix de cogumelos e parmesão.',
    price: 54.90,
    category: 'Pratos',
    icon: Icons.ramen_dining,
  ),
  MenuItem(
    name: 'Hambúrguer da Casa',
    description: 'Blend de 180g, cheddar, bacon e salada no pão brioche.',
    price: 42.90,
    category: 'Pratos',
    icon: Icons.lunch_dining,
  ),
  MenuItem(
    name: 'Suco Natural',
    description: 'Laranja, limão, abacaxi ou maracujá (500ml).',
    price: 12.90,
    category: 'Bebidas',
    icon: Icons.local_drink,
  ),
  MenuItem(
    name: 'Refrigerante',
    description: 'Lata 350ml.',
    price: 7.90,
    category: 'Bebidas',
    icon: Icons.local_cafe,
  ),
  MenuItem(
    name: 'Petit Gâteau',
    description: 'Bolinho de chocolate com recheio cremoso e sorvete.',
    price: 26.90,
    category: 'Sobremesas',
    icon: Icons.cake,
  ),
  MenuItem(
    name: 'Pudim',
    description: 'Pudim de leite condensado com calda de caramelo.',
    price: 16.90,
    category: 'Sobremesas',
    icon: Icons.icecream,
  ),
];
