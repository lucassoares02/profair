import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/details_provider.dart/components/body.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_controller.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_repository.dart';

class DetailsProvider extends StatefulWidget {
  const DetailsProvider({
    super.key,
    this.codeBranch,
    this.codeProvider,
    this.imageProvider,
    this.color,
    this.nameProvider,
  });

  final int? codeBranch;
  final int? codeProvider;
  final String? imageProvider;
  final String? nameProvider;
  final String? color;

  @override
  State<DetailsProvider> createState() => _DetailsProviderState();
}

class _DetailsProviderState extends State<DetailsProvider> {
  final DetailsProviderController detailsProviderController =
      DetailsProviderController(StateApp.start, DetailsProviderRepository());

  @override
  void initState() {
    detailsProviderController.findNegotiations(widget.codeBranch!, widget.codeProvider!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsProviderScreen(
      detailsProviderController: detailsProviderController,
      codeProvider: widget.codeProvider!,
      codeBranch: widget.codeBranch!,
      image: widget.imageProvider,
      nameProvider: widget.nameProvider!,
      color: widget.color,
    );
  }
}
