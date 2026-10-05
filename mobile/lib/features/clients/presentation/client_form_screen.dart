import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/clients_repository.dart';
import '../domain/client_models.dart';

/// New client, or edit the client with [id].
class ClientFormScreen extends ConsumerWidget {
  const ClientFormScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = this.id;
    return Scaffold(
      appBar: AppBar(title: Text(id == null ? l10n.clientNew : l10n.clientEdit)),
      body: id == null
          ? const _ClientForm()
          : AsyncValueView(
              value: ref.watch(clientDetailProvider(id)),
              onRetry: () => ref.invalidate(clientDetailProvider(id)),
              data: (client) => _ClientForm(initial: client),
            ),
    );
  }
}

class _ClientForm extends ConsumerStatefulWidget {
  const _ClientForm({this.initial});

  final ClientDetail? initial;

  @override
  ConsumerState<_ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends ConsumerState<_ClientForm> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _company = TextEditingController(text: widget.initial?.company);
  late final _phone = TextEditingController(text: widget.initial?.phone);
  late final _email = TextEditingController(text: widget.initial?.email);
  late final _address = TextEditingController(text: widget.initial?.address);
  late final _notes = TextEditingController(text: widget.initial?.notes);

  @override
  void dispose() {
    for (final controller in [_name, _company, _phone, _email, _address, _notes]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(clientsRepositoryProvider);
    final body = {
      'name': _name.text.trim(),
      'company': textOrNull(_company),
      'phone': _phone.text.trim(),
      'email': textOrNull(_email),
      'address': textOrNull(_address),
      'notes': textOrNull(_notes),
    };
    final initial = widget.initial;
    final saved = await runSubmit(
      () => initial == null ? repository.create(body) : repository.update(initial.id, body),
    );
    if (saved == null || !mounted) return;
    ref.bump(DataSet.clients);
    showSnack(context, l10n.clientSaved);
    if (initial == null) {
      context.pushReplacement(AppRoutes.adminClient(saved.id));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextFormField(
            controller: _name,
            decoration: InputDecoration(labelText: l10n.fieldName),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: requiredText(l10n),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _company,
            decoration: InputDecoration(labelText: l10n.fieldCompany),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _phone,
            decoration: InputDecoration(labelText: l10n.fieldPhone, prefixIcon: const Icon(Icons.phone_outlined)),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: phoneValidator(l10n),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(labelText: l10n.fieldEmail, prefixIcon: const Icon(Icons.email_outlined)),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: emailValidator(l10n),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _address,
            decoration: InputDecoration(labelText: l10n.fieldAddress),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _notes,
            decoration: InputDecoration(labelText: l10n.fieldNotes),
            minLines: 2,
            maxLines: 6,
          ),
          if (submitError != null) ...[const SizedBox(height: AppSpacing.lg), InlineMessage(message: submitError!)],
          const SizedBox(height: AppSpacing.xl),
          SubmitButton(label: l10n.commonSave, busy: submitting, onPressed: _save),
        ],
      ),
    );
  }
}
