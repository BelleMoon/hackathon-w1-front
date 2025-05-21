import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../widgets/footer.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool isLogin = true;
  bool isLoading = false;

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLogin ? 'Fazendo login...' : 'Conta criada!'),
        ),
      );

      setState(() => isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login com Google realizado com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao entrar com Google: $e')),
      );
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login com Apple realizado com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao entrar com Apple: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: AppBar(
        backgroundColor: const Color(0xff0e1a1f),
        title: Image.asset('assets/imagens/logo-w1.png', height: 32),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8)
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    isLogin ? 'Entrar na sua conta' : 'Criar uma nova conta',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0e1a1f),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: isLogin
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Column(
                      children: [
                        TextFormField(
                          controller: _nomeController,
                          decoration: _inputDecoration('Nome completo',
                              icon: Icons.person),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Informe seu nome'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _usuarioController,
                          decoration: _inputDecoration('Usuário',
                              icon: Icons.account_box),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Informe um nome de usuário'
                              : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('E-mail', icon: Icons.email),
                    validator: (value) => value == null || !value.contains('@')
                        ? 'Informe um e-mail válido'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: !_senhaVisivel,
                    decoration:
                        _inputDecoration('Senha', icon: Icons.lock).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_senhaVisivel
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _senhaVisivel = !_senhaVisivel),
                      ),
                    ),
                    validator: (value) => value == null || value.length < 6
                        ? 'Senha deve ter pelo menos 6 caracteres'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  if (!isLogin)
                    TextFormField(
                      controller: _confirmarSenhaController,
                      obscureText: !_confirmarSenhaVisivel,
                      decoration: _inputDecoration('Confirmar senha',
                              icon: Icons.lock_outline)
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_confirmarSenhaVisivel
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() =>
                              _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
                        ),
                      ),
                      validator: (value) => value != _senhaController.text
                          ? 'Senhas não coincidem'
                          : null,
                    ),
                  const SizedBox(height: 24),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          icon: Icon(isLogin ? Icons.login : Icons.person_add),
                          label: Text(isLogin ? 'Entrar' : 'Cadastrar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0e1a1f),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 32),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _submit,
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _toggleMode,
                    child: Text(
                      isLogin
                          ? 'Não tem uma conta? Cadastre-se'
                          : 'Já tem uma conta? Entrar',
                      style: const TextStyle(color: Color(0xff0e1a1f)),
                    ),
                  ),
                  const Divider(height: 32),
                  const Text("ou", style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Image.asset('assets/imagens/google_icon.png',
                        height: 20),
                    label: const Text("Entrar com Google"),
                    onPressed: _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: Colors.black12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (Theme.of(context).platform == TargetPlatform.iOS)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.apple),
                      label: const Text("Entrar com Apple"),
                      onPressed: _signInWithApple,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
