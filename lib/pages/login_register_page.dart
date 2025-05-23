import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:w1app/widgets/topbar_clean2.dart';
import '../widgets/footer.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _checkToken() async {
    try {
      final userData = await ApiService.getUserData();
      print(userData);
      if (userData != null) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      // Token inválido ou expirado, permanecer na tela de login
    }
  }

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _submit() async {
    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.contains('@')) {
      _showError('Informe um e-mail válido.');
      return;
    }

    if (_senhaController.text.length < 6) {
      _showError('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (!isLogin) {
      if (_nomeController.text.trim().isEmpty) {
        _showError('Informe seu nome completo.');
        return;
      }

      if (_usuarioController.text.trim().isEmpty) {
        _showError('Informe um nome de usuário.');
        return;
      }

      if (_confirmarSenhaController.text != _senhaController.text) {
        _showError('As senhas não coincidem.');
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        print('Tentando login com: ${_emailController.text}');

        final token = await ApiService.login(
          _emailController.text,
          _senhaController.text,
        );

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          final userData = await ApiService.getUserData();
          if (userData != null) {
            Navigator.pushReplacementNamed(context, '/');
          } else {
            _showError('Login falhou. Token inválido.');
            await prefs.remove('jwt_token');
          }
        } else {
          _showError('Email ou senha incorretos.');
        }
      } else {
        final success = await ApiService.register(
          nome: _nomeController.text,
          usuario: _usuarioController.text,
          email: _emailController.text,
          senha: _senhaController.text,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Conta criada! Faça login.')),
          );
          setState(() {
            isLogin = true;
          });
        } else {
          _showError('Erro ao criar conta.');
        }
      }
    } catch (e) {
      _showError('Erro inesperado: $e');
      debugPrint('Erro login: $e');
    }

    setState(() => isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
      Navigator.pushReplacementNamed(context, '/cadastro-patrimonio');
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
      Navigator.pushReplacementNamed(context, '/cadastro-patrimonio');
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
      appBar: TopBarLogoOnly2(),
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
                    textInputAction:
                        TextInputAction.done, // muda o botão no teclado
                    onFieldSubmitted: (_) =>
                        _submit(), // executa quando Enter for pressionado
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
                      onFieldSubmitted: (_) => _submit(),
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
