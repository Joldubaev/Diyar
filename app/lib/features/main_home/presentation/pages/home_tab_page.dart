import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart' show showAddressConfirmBottomSheet;
import 'package:diyar/common/components/text/row_text_widget.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<FoodEntity> menu = [];
  String? _savedAddress;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadSavedAddress();
    _checkAddressConfirmation();
  }

  Future<void> _initializeData() async {
    context.read<PopularCubit>().getPopularProducts();
    context.read<ProfileCubit>().getUser();
    context.read<HomeContentCubit>().getSales();
    if (UserHelper.isAuth()) {
      context.read<ActiveOrderCubit>().getActiveOrders();
    }
  }

  void _loadSavedAddress() {
    final addressStorage = sl<AddressStorageService>();
    setState(() {
      _savedAddress = addressStorage.getAddress();
    });
  }

  Future<void> _checkAddressConfirmation() async {
    final addressStorage = sl<AddressStorageService>();
    if (!addressStorage.shouldShowAddressConfirmation()) return;

    final address = addressStorage.getAddress();
    if (address == null) return;

    // Показываем после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final result = await showAddressConfirmBottomSheet(
        context,
        address: address,
      );

      if (!mounted) return;

      if (result == true) {
        // Подтвердить текущий адрес
        await addressStorage.confirmAddress();
      } else if (result == false) {
        // Изменить адрес — перейти на карту
        context.router.push(const AddressSelectionRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _HomeAppBar(
        savedAddress: _savedAddress,
        onAddressTap: () async {
          await context.router.push(const AddressSelectionRoute());
          if (mounted) _loadSavedAddress();
        },
      ),
      body: SafeArea(
        child: BlocConsumer<PopularCubit, PopularState>(
          listener: (context, state) {
            if (state is PopularError) {
              _showErrorSnackbar(context, state.message);
            } else if (state is PopularLoaded) {
              setState(() {
                menu = state.products;
              });
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _initializeData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    const ActiveOrdersBannerWidget(),
                    const BonusCardWidget(),
                    RowTextWidget(text: context.l10n.popularFood, theme: Theme.of(context)),
                    if (menu.isNotEmpty) PopularFoodSectionWidget(menu: menu),
                    RowTextWidget(text: 'Анонсы', theme: Theme.of(context)),
                    NewsWidgets(
                      subtitle: context.l10n.news,
                      title: 'Дияр',
                      image: 'assets/images/news_da.png',
                      onTap: () => context.router.push(const NewsRoute()),
                    ),
                    RowTextWidget(text: 'Инфоцентр', theme: Theme.of(context)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? savedAddress;
  final VoidCallback onAddressTap;

  const _HomeAppBar({
    required this.savedAddress,
    required this.onAddressTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.colorScheme.primary,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 56,
      titleSpacing: 16,
      title: GestureDetector(
        onTap: onAddressTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  savedAddress ?? 'Укажите адрес доставки',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
      actions: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final userName = context.read<ProfileCubit>().user?.userName;
            if (userName != null) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
