import 'package:sitework/core/models/refs.dart';
import 'package:sitework/core/network/app_exception.dart';
import 'package:sitework/features/auth/data/auth_repository.dart';
import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

/// In-memory stand-in for the API's auth endpoints.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.saved, Map<String, AppSession>? accounts}) : accounts = accounts ?? {'+919000000101': ravi};

  static const ravi = AppSession(userId: 'staff-1', name: 'Ravi', role: UserRole.staff);
  static const password = 'Staff@123';

  /// Signed-in session found on "disk" at launch.
  StoredSession? saved;
  final Map<String, AppSession> accounts;
  AppSession? current;
  var signOuts = 0;
  String? changedTo;

  @override
  Future<StoredSession?> restore() async {
    current = saved?.user;
    return saved;
  }

  @override
  Future<AppSession> signIn(String identifier, String secret) async {
    final user = accounts[identifier.trim()];
    if (user == null || secret != password) {
      throw const ApiException(
        statusCode: 401,
        code: 'INVALID_CREDENTIALS',
        message: 'The mobile number/e-mail or password is incorrect.',
      );
    }
    return current = user;
  }

  /// No admin yet: the first one may sign up.
  var signUpIsOpen = false;

  @override
  Future<bool> signUpOpen() async => signUpIsOpen;

  @override
  Future<AppSession> signUp({
    required String name,
    required String phone,
    String? email,
    required String password,
  }) async {
    signUpIsOpen = false;
    return current = AppSession(userId: 'admin-1', name: name, role: UserRole.admin);
  }

  @override
  Future<void> signOut() async {
    signOuts += 1;
    current = null;
  }

  @override
  Future<MeProfile> fetchProfile() async {
    final user = current;
    if (user == null) throw const NetworkException();
    return MeProfile(
      id: user.userId,
      name: user.name,
      role: user.role,
      phone: '+919000000101',
      employeeCode: 'STF-001',
      mustChangePassword: user.mustChangePassword,
      assignment: const StaffAssignmentInfo(
        site: SiteRef(id: 'site-1', code: 'SITE-001', name: 'ABC Apartment Project', address: 'Anna Nagar'),
        engineer: PersonRef(id: 'eng-1', name: 'Arun Kumar', phone: '+919000000011'),
      ),
    );
  }

  @override
  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    if (currentPassword != password) {
      throw const ApiException(
        statusCode: 400,
        code: 'WRONG_CURRENT_PASSWORD',
        message: 'Your current password is incorrect.',
      );
    }
    changedTo = newPassword;
    current = current?.copyWith(mustChangePassword: false);
  }

  @override
  Future<String> requestPasswordReset(String identifier) async => 'We have sent a code if possible.';

  @override
  Future<void> resetPassword({required String identifier, required String code, required String newPassword}) async {}
}
