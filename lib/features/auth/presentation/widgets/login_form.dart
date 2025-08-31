import 'package:exchange_darr/features/auth/domain/use_cases/login_usecase.dart';
import 'package:exchange_darr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:exchange_darr/features/prices/presentation/pages/my_prices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/state_managment/bloc_state.dart';
import '../../../../../common/widgets/custom_progress_indecator.dart';
import '../../../../../common/widgets/custom_text_field.dart';
import '../../../../../common/widgets/large_button.dart';
import '../../../../../common/widgets/toast_dialog.dart';
import '../../../../../core/di/injection.dart';
import 'package:toastification/toastification.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode usernameNode = FocusNode();
  final FocusNode passwardNode = FocusNode();
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.loginStatus == Status.failure) {
            ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
          }
          if (state.loginStatus == Status.success && state.loginResponse != null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PageDecider()));
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              buildTextField(
                hint: "اسم المستخدم",
                preIcon: Icon(Icons.person_outline_outlined, color: context.onPrimaryColor.withAlpha(170)),
                controller: usernameController,
                focusNode: usernameNode,
                focusOn: passwardNode,
              ),

              SizedBox(height: 5),
              buildTextField(
                hint: "كلمة السر",
                preIcon: Icon(Icons.lock_outline, color: context.onPrimaryColor.withAlpha(170)),
                obSecure: true,
                controller: passwordController,
                focusNode: passwardNode,
              ),
              SizedBox(height: 10),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: LargeButton(
                          onPressed: state.loginStatus == Status.loading
                              ? () {}
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    final LoginParams params = LoginParams(
                                      username: usernameController.text,
                                      password: passwordController.text,
                                    );

                                    context.read<AuthBloc>().add(LoginEvent(params: params));
                                  }
                                },
                          text: "تسجيل الدخول",
                          backgroundColor: context.onTertiary,
                          circularRadius: 12,
                          isOutlined: true,
                          child: state.loginStatus == Status.loading ? CustomProgressIndecator() : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    void Function(String)? onChanged,
    String validatorTitle = "",
    int mxLine = 1,
    Widget? sufIcon,
    bool? readOnly,
    dynamic Function()? onTap,
    TextInputType? keyboardType,
    bool needValidation = true,
    FocusNode? focusNode,
    FocusNode? focusOn,
    Widget? preIcon,
    bool? obSecure,
  }) {
    return CustomTextField(
      textAlign: TextAlign.start,
      onTap: onTap,
      readOnly: readOnly,
      preIcon: preIcon,
      obSecure: obSecure,
      onChanged: onChanged,
      keyboardType: keyboardType,
      mxLine: mxLine,
      controller: controller,
      hint: hint,
      focusNode: focusNode,
      focusOn: focusOn,
      filledColor: context.primaryColor,
      validator: needValidation
          ? (value) {
              if (value == null || value.isEmpty) {
                return validatorTitle.isNotEmpty ? validatorTitle : "لا يمكن للحقل ان يكون فارعاً";
              }
              return null;
            }
          : null,
      sufIcon: sufIcon,
    );
  }
}
