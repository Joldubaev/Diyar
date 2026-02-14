import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/home_content/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class SalePage extends StatefulWidget {
  final SaleEntity? sale;
  const SalePage({super.key, this.sale});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  SaleEntity? sale;

  @override
  void initState() {
    setState(() {
      sale = widget.sale;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () {
              context.router.maybePop();
            },
          ),
          title: Text(context.l10n.sales,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.white))),
      body: sale == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/amico.svg', width: 200, height: 200),
                  const SizedBox(height: 20),
                  Text(context.l10n.emptyText,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: sale?.photoLink ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 200,
                      errorWidget: (context, url, error) {
                        return Image.asset("assets/images/app_icon.png", fit: BoxFit.cover);
                      },
                      placeholder: (context, url) => const Center(
                        child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    sale?.name ?? "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(sale?.description ?? ""),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
