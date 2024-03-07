import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/colours.dart';
import '../../common/constants.dart';
import '../../common/widgets/custom_appbar.dart';
import '../../common/widgets/loader.dart';
import '../../common/widgets/round_button.dart';
import '../../common/widgets/round_textfield.dart';

//Controller
import '../controller/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  bool isCheck = false, isHidePassword = true, isHideConfirmPassword = true;
  final TextEditingController _nameController = TextEditingController(),
      _teamNameController = TextEditingController(),
      _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _phoneController = TextEditingController(),
      _leaderIdController = TextEditingController();

  void signUpWithEmail() {
    ref.read(authControllerProvider.notifier).signUpWithEmail(
          context: context,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          teamName: _teamNameController.text.trim(),
          leaderName: _nameController.text.trim(),
          leaderId: _leaderIdController.text.trim(),
          leaderPhone: _phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    var media = MediaQuery.of(context).size;
    return isLoading
        ? const Loader(
            message: "Registering Your Team",
          )
        : Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(75),
              child: CustomAppBar(),
            ),
            backgroundColor: TColor.white,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Text(
                        "Welcome Explorer,",
                        style: TextStyle(color: TColor.gray, fontSize: 16),
                      ),
                      Text(
                        "Embark on the Hunt",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      RoundTextField(
                        hintText: "Team Name",
                        icon: Constants.teamName,
                        controller: _teamNameController,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hintText: "Leader Name",
                        icon: Constants.name,
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hintText: "Leader ID (Roll No)",
                        icon: Constants.id,
                        controller: _leaderIdController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hintText: "Email",
                        icon: Constants.email,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hintText: "Password",
                        icon: Constants.password,
                        obscureText: isHidePassword,
                        controller: _passwordController,
                        rigtIcon: TextButton(
                          onPressed: () {
                            setState(() {
                              isHidePassword = !isHidePassword;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 20,
                            height: 20,
                            child: Icon(
                              isHidePassword
                                  ? Icons.lock_open_outlined
                                  : Icons.lock_outline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hintText: "Phone Number",
                        icon: Constants.phone,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(
                        height: media.width * 0.5,
                      ),
                      RoundButton(
                        title: "START THE ADVENTURE!!!",
                        onPressed: () => signUpWithEmail(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
