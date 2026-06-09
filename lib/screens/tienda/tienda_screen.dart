import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class TiendaScreen extends StatefulWidget {
  const TiendaScreen({super.key});

  @override
  State<TiendaScreen> createState() => _TiendaScreenState();
}

class _TiendaScreenState extends State<TiendaScreen> {
  static const _products = [
    _Product('Camiseta Pro', 49.99, Icons.checkroom),
    _Product('Sudadera PFL', 69.99, Icons.dry_cleaning),
    _Product('Gorra Fighter', 29.99, Icons.sports_baseball),
    _Product('Pala Carbon', 129.99, Icons.sports_tennis),
  ];

  final Map<_Product, int> _cart = {};

  int get _cartCount =>
      _cart.values.fold(0, (total, quantity) => total + quantity);

  double get _cartTotal => _cart.entries.fold(
        0,
        (total, entry) => total + entry.key.price * entry.value,
      );

  void _addToCart(_Product product) {
    setState(
        () => _cart.update(product, (value) => value + 1, ifAbsent: () => 1));
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} añadido al carrito'),
          backgroundColor: kTeal,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'VER',
            textColor: kOnGold,
            onPressed: _openCart,
          ),
        ),
      );
  }

  void _changeQuantity(_Product product, int delta) {
    setState(() {
      final next = (_cart[product] ?? 0) + delta;
      if (next <= 0) {
        _cart.remove(product);
      } else {
        _cart[product] = next;
      }
    });
  }

  void _openCart() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) {
          void update(_Product product, int delta) {
            _changeQuantity(product, delta);
            setSheetState(() {});
          }

          return _CartSheet(
            items: Map.unmodifiable(_cart),
            total: _cartTotal,
            onDecrease: (product) => update(product, -1),
            onIncrease: (product) => update(product, 1),
            onRemove: (product) {
              setState(() => _cart.remove(product));
              setSheetState(() {});
            },
            onCheckout: _cart.isEmpty
                ? null
                : () {
                    Navigator.pop(context);
                    setState(_cart.clear);
                    showDialog<void>(
                      context: this.context,
                      builder: (context) => AlertDialog(
                        backgroundColor: kCard,
                        icon: const Icon(
                          Icons.check_circle,
                          color: kTeal,
                          size: 42,
                        ),
                        title: const Text('Pedido confirmado'),
                        content: const Text(
                          'Tu compra de demostración se ha registrado.',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: AppTitleBar(title: 'Tienda Oficial'),
            ),
            SliverToBoxAdapter(
              child: AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShopHero(
                      cartCount: _cartCount,
                      onCartTap: _openCart,
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Colección oficial',
                      style: TextStyle(
                        color: kTextPrimary,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Diseñada para competir dentro y fuera de la pista.',
                      style: TextStyle(color: kTextSecondary),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 104),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.crossAxisExtent >= 700 ? 4 : 2;
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _products[index];
                        return _ProductCard(
                          product: product,
                          imageAlignment: _alignmentFor(index),
                          onAdd: () => _addToCart(product),
                        );
                      },
                      childCount: _products.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Alignment _alignmentFor(int index) {
    return const [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ][index];
  }
}

class _Product {
  final String name;
  final double price;
  final IconData icon;

  const _Product(this.name, this.price, this.icon);
}

String _price(double value) =>
    '${value.toStringAsFixed(2).replaceAll('.', ',')} €';

class _ShopHero extends StatelessWidget {
  final int cartCount;
  final VoidCallback onCartTap;

  const _ShopHero({
    required this.cartCount,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 8.8,
      child: Container(
        decoration: elegantCard(active: true, radius: 16),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const LocalOrNetworkImage(source: kShopImage),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xD9000000), Color(0x22000000)],
                ),
              ),
            ),
            const Positioned(
              left: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EQUÍPATE PARA GANAR',
                    style: TextStyle(
                      color: kGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Colección Fighter',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 14,
              top: 14,
              child: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                backgroundColor: Colors.redAccent,
                child: Material(
                  color: kBg.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    key: const Key('shop-cart-button'),
                    onTap: onCartTap,
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: kTeal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final Alignment imageAlignment;
  final VoidCallback onAdd;

  const _ProductCard({
    required this.product,
    required this.imageAlignment,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: elegantCard(radius: 14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  kProductsImage,
                  fit: BoxFit.cover,
                  alignment: imageAlignment,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.28),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Icon(product.icon, color: kGold, size: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kTextPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _price(product.price),
                        style: const TextStyle(
                          color: kGold,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    InkWell(
                      key: Key('add-${product.name}'),
                      onTap: onAdd,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: kTeal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Añadir',
                          style: TextStyle(
                            color: kOnGold,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartSheet extends StatelessWidget {
  final Map<_Product, int> items;
  final double total;
  final ValueChanged<_Product> onDecrease;
  final ValueChanged<_Product> onIncrease;
  final ValueChanged<_Product> onRemove;
  final VoidCallback? onCheckout;

  const _CartSheet({
    required this.items,
    required this.total,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.82;
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: const BoxDecoration(
          color: kBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: kCardBorder)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: kCardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart_outlined, color: kTeal),
                  SizedBox(width: 10),
                  Text(
                    'Tu carrito',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            if (items.isEmpty)
              const Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 36, 24, 56),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: kTextSecondary,
                        size: 52,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'El carrito está vacío',
                        style: TextStyle(
                          color: kTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Añade algún producto de la colección.',
                        style: TextStyle(color: kTextSecondary),
                      ),
                    ],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shrinkWrap: true,
                  children: items.entries
                      .map(
                        (entry) => _CartRow(
                          product: entry.key,
                          quantity: entry.value,
                          onDecrease: () => onDecrease(entry.key),
                          onIncrease: () => onIncrease(entry.key),
                          onRemove: () => onRemove(entry.key),
                        ),
                      )
                      .toList(),
                ),
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: const BoxDecoration(
                color: kCard,
                border: Border(top: BorderSide(color: kCardBorder)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: kTextPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _price(total),
                        key: const Key('cart-total'),
                        style: const TextStyle(
                          color: kGold,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: GoldPillButton(
                      label: 'FINALIZAR COMPRA',
                      icon: Icons.lock_outline,
                      onPressed: onCheckout,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final _Product product;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRemove;

  const _CartRow({
    required this.product,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('cart-${product.name}'),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: elegantCard(radius: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: kGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(product.icon, color: kGold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: kTextPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _price(product.price * quantity),
                  style: const TextStyle(
                    color: kGold,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _QuantityButton(
            key: Key('decrease-${product.name}'),
            icon: Icons.remove,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 30,
            child: Text(
              '$quantity',
              key: Key('quantity-${product.name}'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kTextPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _QuantityButton(
            key: Key('increase-${product.name}'),
            icon: Icons.add,
            onTap: onIncrease,
          ),
          IconButton(
            key: Key('remove-${product.name}'),
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: kActiveCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kCardBorder),
        ),
        child: Icon(icon, color: kTextPrimary, size: 17),
      ),
    );
  }
}
