import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maize/Pages/Authentication/authentication_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  static Page page() => const MaterialPage<void>(child: AuthenticationPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: _Card(),
    );
  }
}

class _Card extends StatelessWidget {
  _Card();
  final TextEditingController usernameTFController = TextEditingController();
  final TextEditingController passwordTFController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const _MealieBanner(),
              const SizedBox(height: 50),
              const _MealieLogo(),
              const SizedBox(height: 25),
              _CardBody(
                usernameTFController: usernameTFController,
                passwordTFController: passwordTFController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealieBanner extends StatelessWidget {
  const _MealieBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(0),
        child: Container(
          color: MealieColors.orange,
          child: const Text(
            "Mealie",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
        ),
      ),
    );
  }
}

class _MealieLogo extends StatelessWidget {
  const _MealieLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        Center(
            child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
              color: MealieColors.orange,
              borderRadius: BorderRadius.all(Radius.circular(50))),
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset('assets/mealie_logo.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcATop)),
        ))
      ]),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.passwordTFController,
    required this.usernameTFController,
  });

  final TextEditingController usernameTFController;
  final TextEditingController passwordTFController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, snapshot) {
      return BlocProvider(
        create: (_) => AuthenticationCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.invalid:
              return const _Invalid();
            case AuthenticationStatus.valid:
              return const _Valid();
            case AuthenticationStatus.loading:
              return const _Loading();
            case AuthenticationStatus.ready:
            default:
              return _EnterEmailAndPassword(
                showPassword: state.showPassword,
                usernameTFController: usernameTFController,
                passwordTFController: passwordTFController,
              );
          }
        }),
      );
    });
  }
}

class _EnterEmailAndPassword extends StatelessWidget {
  const _EnterEmailAndPassword({
    required this.showPassword,
    required this.usernameTFController,
    required this.passwordTFController,
  });

  final bool showPassword;
  final TextEditingController usernameTFController;
  final TextEditingController passwordTFController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Sign In",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              clipBehavior: Clip.antiAlias,
              child: TextField(
                controller: usernameTFController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: "Email or Username",
                  border: InputBorder.none,
                  fillColor: Colors.grey[300],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              clipBehavior: Clip.antiAlias,
              child: TextField(
                controller: passwordTFController,
                obscureText: !showPassword,
                onSubmitted: (_) => context.read<AuthenticationCubit>().login(
                    usernameTFController.value.text,
                    passwordTFController.value.text),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: FaIcon(showPassword
                        ? FontAwesomeIcons.solidEyeSlash
                        : FontAwesomeIcons.solidEye),
                    onPressed: () =>
                        context.read<AuthenticationCubit>().togglePassword(),
                  ),
                  hintText: "Password",
                  border: InputBorder.none,
                  fillColor: Colors.grey[300],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(
                    activeColor: MealieColors.orange,
                    value: context.read<AuthenticationCubit>().state.rememberMe,
                    onChanged: (value) =>
                        context.read<AuthenticationCubit>().toggleRememberMe()),
                const Text("Remember Me")
              ],
            ),
            const SizedBox(height: 15),
            _SubmitButton(
              tfController: usernameTFController,
              onTap: () => context.read<AuthenticationCubit>().login(
                  usernameTFController.value.text,
                  passwordTFController.value.text),
              text: "Login",
            ),
            const SizedBox(height: 15),
            InkWell(
              child: const Text("Reset Domain"),
              onTap: () => context.read<AuthenticationCubit>().resetURI(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.tfController,
    required this.onTap,
    required this.text,
  });

  final TextEditingController tfController;
  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 40,
      child: InkWell(
        child: Container(
            decoration: const BoxDecoration(
                color: MealieColors.orange,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )),
        onTap: () => onTap(),
      ),
    );
  }
}

class _Invalid extends StatelessWidget {
  const _Invalid();

  @override
  Widget build(BuildContext context) {
    final TextEditingController tfController = TextEditingController();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Error",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(context
              .read<AuthenticationCubit>()
              .state
              .errorMessage
              .toString()),
          const SizedBox(height: 20),
          _SubmitButton(
            tfController: tfController,
            onTap: () => context.read<AuthenticationCubit>().reset(),
            text: "Retry",
          )
        ],
      ),
    );
  }
}

class _Valid extends StatelessWidget {
  const _Valid();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Looks Good!",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Authenticating...",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 30),
          CircularProgressIndicator(
            color: MealieColors.orange,
          ),
        ],
      ),
    );
  }
}
