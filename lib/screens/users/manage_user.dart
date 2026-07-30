import 'package:creafton_financial_services/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';

import '../../providers/user_provider.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUsers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _openUserForm({User? user}) {
    showDialog(
      context: context,
      builder: (_) => _UserFormDialog(user: user),
    );
  }

  Future<void> _confirmDelete(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: Text(
          "Are you sure you want to delete \"${user.fullName}\"? "
          "This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.deleteUser(user.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "User deleted"
              : (userProvider.error ?? "Failed to delete user"),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openUserForm(),
        icon: const Icon(Icons.person_add),
        label: const Text("Add User"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) => context.read<UserProvider>().search(value),
              decoration: InputDecoration(
                hintText: "Search by name, username or phone",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context.read<UserProvider>().loadUsers();
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, provider, _) {
                if (provider.loading && provider.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.users.isEmpty) {
                  return _ErrorState(
                    message: provider.error!,
                    onRetry: provider.loadUsers,
                  );
                }

                if (provider.users.isEmpty) {
                  return const _EmptyState();
                }

                return RefreshIndicator(
                  onRefresh: provider.loadUsers,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: provider.users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final user = provider.users[index];
                      return _UserTile(
                        user: user,
                        onEdit: () => _openUserForm(user: user),
                        onDelete: () => _confirmDelete(user),
                        onToggleStatus: () => provider.toggleStatus(user),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// User row
// ---------------------------------------------------------------------------

class _UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const _UserTile({
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.12),
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : "?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "@${user.username}"
                    "${user.phone != null && user.phone!.isNotEmpty ? ' · ${user.phone}' : ''}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (user.roleName != null)
                        _Badge(
                          text: user.roleName!,
                          color: AppColors.primaryBlue,
                        ),
                      _Badge(
                        text: user.isActive ? "ACTIVE" : "DISABLED",
                        color: user.isActive ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(
                  value: user.isActive,
                  onChanged: (_) => onToggleStatus(),
                  activeTrackColor: Colors.green,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: "Edit",
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      tooltip: "Delete",
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Create / edit dialog
// ---------------------------------------------------------------------------

class _UserFormDialog extends StatefulWidget {
  final User? user; // null => create mode

  const _UserFormDialog({this.user});

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController usernameController;
  late final TextEditingController fullNameController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  int? roleId;
  bool active = true;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  bool get isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();

    final user = widget.user;

    usernameController = TextEditingController(text: user?.username ?? "");
    fullNameController = TextEditingController(text: user?.fullName ?? "");
    phoneController = TextEditingController(text: user?.phone ?? "");
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    roleId = user?.roleId;
    active = user?.isActive ?? true;
  }

  @override
  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();

    final user = User(
      id: widget.user?.id,
      username: usernameController.text.trim(),
      password:
          passwordController.text, // repository keeps old one if empty on edit
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      roleId: roleId,
      status: active ? 1 : 0,
      createdAt: widget.user?.createdAt ?? DateTime.now().toIso8601String(),
    );

    final success = isEditing
        ? await provider.updateUser(user)
        : await provider.createUser(user);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? "User updated" : "User created"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? "Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(
        isEditing ? "Edit User" : "Add User",
        style: TextStyle(color: AppColors.primaryBlue),
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? "Full name is required"
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return "Username is required";
                    if (v.trim().contains(" "))
                      return "Username can't contain spaces";
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone (optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<int>(
                  initialValue: roleId,
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(),
                  ),
                  items: provider.roles
                      .map(
                        (r) =>
                            DropdownMenuItem(value: r.id, child: Text(r.name)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => roleId = value),
                  validator: (v) => v == null ? "Select a role" : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: isEditing
                        ? "New Password (leave blank to keep current)"
                        : "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => obscurePassword = !obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (!isEditing && (v == null || v.isEmpty)) {
                      return "Password is required";
                    }
                    if (v != null && v.isNotEmpty && v.length < 4) {
                      return "Password must be at least 4 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => obscureConfirm = !obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (passwordController.text.isEmpty)
                      return null; // nothing to confirm
                    if (v != passwordController.text)
                      return "Passwords don't match";
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Active"),
                  subtitle: const Text("Disabled users can't log in"),
                  value: active,
                  onChanged: (v) => setState(() => active = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: provider.savingUser ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: provider.savingUser ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: provider.savingUser
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(isEditing ? "Save Changes" : "Create User"),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Empty / error states
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text("No users yet", style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(
            "Tap \"Add User\" to create the first one.",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 42, color: Colors.redAccent),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
