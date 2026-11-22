import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MonCvApp());
}

class MonCvApp extends StatelessWidget {
  const MonCvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV - BAHATI IRUMVA EUGENE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifiantController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _seConnecter() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(
            utilisateur: _identifiantController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _identifiantController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Color(0xFF1565C0),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Connexion',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Portfolio de BAHATI IRUMVA EUGENE',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _identifiantController,
                        decoration: const InputDecoration(
                          labelText: 'Identifiant',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez entrer votre identifiant';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _seConnecter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final String utilisateur;
  const MainNavigationScreen({super.key, required this.utilisateur});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CvHomePage(),
    FamillePage(),
    ContactPage(),
  ];

  final List<String> _titles = const [
    'Mon CV',
    'Ma Famille',
    'Mes Coordonnées',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1565C0),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.badge),
            label: 'CV / Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

class CvHomePage extends StatelessWidget {
  const CvHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blue.shade100,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profil.jpg',
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 60, color: Color(0xFF1565C0)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'BAHATI IRUMVA EUGENE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Étudiant en Licence 3 – Informatique Appliquée à la Gestion des Entreprises (ISIG Goma)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Futur analyste-programmeur spécialisé dans la conception de solutions logicielles, mobiles et de systèmes d’information pour la gestion des entreprises.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          _buildSectionTitle(Icons.school, 'Formation'),
          _buildTimelineItem(
'Licence 3 en Informatique Appliquée à la Gestion des Entreprises',
'ISIG Goma (Institut Supérieur d’Informatique et de Gestion) • 2025 - 2026',
'Développement mobile (Flutter), Développement Web, Bases de données (SQL), Comptabilité et Gestion d’entreprise.',
),
_buildTimelineItem(
'Diplôme d’État',
'Goma, Nord-Kivu',
'Obtention du diplôme d’État.',
),
_buildSectionTitle(Icons.work, 'Expériences & Projets'),
_buildTimelineItem(
'Développeur Application Mobile Flutter (Projet Académique)',
'ISIG Goma • 2026',
'Conception et développement d’une application mobile multi-écrans présentant mon CV, ma famille et mes coordonnées.',
),
_buildTimelineItem(
'Conception d’un Système d’Information de Gestion',
'Projet Universitaire (Licence 3) • 2025 - 2026',
'Analyse, modélisation de base de données et automatisation des opérations de gestion.',
),
_buildSectionTitle(Icons.code, 'Compétences Techniques'),
const Wrap(
spacing: 8,
runSpacing: 8,
children: [
Chip(label: Text('Flutter & Dart')),
Chip(label: Text('Bases de données & SQL')),
Chip(label: Text('Informatique de Gestion')),
Chip(label: Text('HTML / CSS / PHP / JS')),
Chip(label: Text('Git & GitHub')),
Chip(label: Text('Bureautique (Excel, Word)')),
],
),
const SizedBox(height: 16),
_buildSectionTitle(Icons.language, 'Compétences Linguistiques'),
const ListTile(
dense: true,
leading: Icon(Icons.check_circle, color: Colors.green),
title: Text('Français : Courant (Lu, écrit, parlé)'),
),
const ListTile(
dense: true,
leading: Icon(Icons.check_circle, color: Colors.green),
title: Text('Swahili : Courant'),
),
const ListTile(
dense: true,
leading: Icon(Icons.check_circle, color: Colors.green),
title: Text('Anglais : Niveau technique / intermédiaire'),
),
_buildSectionTitle(Icons.favorite, 'Centres d’intérêt'),
const Wrap(
spacing: 8,
runSpacing: 8,
children: [
Chip(avatar: Icon(Icons.computer, size: 18), label: Text('Programmation mobile')),
Chip(avatar: Icon(Icons.business_center, size: 18), label: Text('Gestion & Entrepreneuriat')),
Chip(avatar: Icon(Icons.menu_book, size: 18), label: Text('Lecture')),
Chip(avatar: Icon(Icons.sports_soccer, size: 18), label: Text('Sport')),
],
),
const SizedBox(height: 20),
],
),
);
}
Widget _buildSectionTitle(IconData icon, String title) {
return Padding(
padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
child: Row(
children: [
Icon(icon, color: const Color(0xFF1565C0)),
const SizedBox(width: 8),
Text(
title,
style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
],
),
);
}
Widget _buildTimelineItem(String titre, String sousTitre, String description) {
return Card(
margin: const EdgeInsets.only(bottom: 10),
child: Padding(
padding: const EdgeInsets.all(12.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
const SizedBox(height: 2),
Text(sousTitre, style: const TextStyle(color: Color(0xFF1565C0), fontSize: 13)),
const SizedBox(height: 6),
Text(description, style: const TextStyle(fontSize: 13)),
],
),
),
);
}
}
class MembreFamille {
final String nom;
final String lien;
final String profession;
final String photoAsset;
const MembreFamille({
required this.nom,
required this.lien,
required this.profession,
required this.photoAsset,
});
}
class FamillePage extends StatelessWidget {
const FamillePage({super.key});
final List membres = const [
MembreFamille(
nom: 'Claude',
lien: 'Frère',
profession: 'Membre de la famille',
photoAsset: 'assets/images/claude.jpg',
),
MembreFamille(
nom: 'Ange',
lien: 'Sœur',
profession: 'Membre de la famille',
photoAsset: 'assets/images/ange.jpg',
),
MembreFamille(
nom: 'Innocent',
lien: 'Frère',
profession: 'Membre de la famille',
photoAsset: 'assets/images/innocent.jpg',
),
MembreFamille(
nom: 'Josephine',
lien: 'Mère / Sœur',
profession: 'Membre de la famille',
photoAsset: 'assets/images/josephine.jpg',
),
MembreFamille(
nom: 'Theo',
lien: 'Frère',
profession: 'Membre de la famille',
photoAsset: 'assets/images/theo.jpg',
),
MembreFamille(
nom: 'Divine',
lien: 'Sœur',
profession: 'Membre de la famille',
photoAsset: 'assets/images/divine.jpg',
),
MembreFamille(
nom: 'Kadere',
lien: 'Membre de la famille',
profession: 'Membre de la famille',
photoAsset: 'assets/images/kadere.jpg',
),
];
@override
Widget build(BuildContext context) {
return ListView.builder(
padding: const EdgeInsets.all(16.0),
itemCount: membres.length,
itemBuilder: (context, index) {
final membre = membres[index];
return Card(
elevation: 3,
margin: const EdgeInsets.only(bottom: 12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: ListTile(
contentPadding: const EdgeInsets.all(12),
leading: CircleAvatar(
radius: 30,
backgroundColor: Colors.blue.shade100,
child: ClipOval(
child: Image.asset(
membre.photoAsset,
width: 60,
height: 60,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) =>
const Icon(Icons.person, size: 32, color: Color(0xFF1565C0)),
),
),
),
title: Text(
membre.nom,
style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),
subtitle: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 4),
Text(
'Lien : ${membre.lien}',
style: const TextStyle(
color: Color(0xFF1565C0),
fontWeight: FontWeight.w600,
),
),
Text('Profession : ${membre.profession}'),
],
),
),
);
},
);
}
}
class ContactPage extends StatelessWidget {
const ContactPage({super.key});
Future _ouvrirLien(String url) async {
final Uri uri = Uri.parse(url);
if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
debugPrint('Impossible d’ouvrir $url');
}
}
@override
Widget build(BuildContext context) {
return ListView(
padding: const EdgeInsets.all(16.0),
children: [
const Text(
'Mes coordonnées directes (cliquez pour interagir) :',
style: TextStyle(fontSize: 15, color: Colors.black87),
),
const SizedBox(height: 16),
Card(
child: ListTile(
leading: const Icon(Icons.phone, color: Colors.green),
title: const Text('Téléphone principal'),
subtitle: const Text('+243 980 576 900'),
trailing: const Icon(Icons.call),
onTap: () => _ouvrirLien('tel:+243980576900'),
),
),
Card(
child: ListTile(
leading: const Icon(Icons.phone_android, color: Colors.teal),
title: const Text('Téléphone secondaire'),
subtitle: const Text('+243 903 886 201'),
trailing: const Icon(Icons.call),
onTap: () => _ouvrirLien('tel:+243903886201'),
),
),
Card(
child: ListTile(
leading: const Icon(Icons.email, color: Colors.red),
title: const Text('Adresse E-mail'),
subtitle: const Text('marloweugene2000@gmail.com'),
trailing: const Icon(Icons.send),
onTap: () => _ouvrirLien('mailto:marloweugene2000@gmail.com'),
),
),
const Card(
child: ListTile(
leading: Icon(Icons.location_on, color: Colors.orange),
title: Text('Adresse'),
subtitle: Text('Goma, Nord-Kivu, RDC (ISIG Goma)'),
),
),
Card(
child: ListTile(
leading: const Icon(Icons.code, color: Colors.black),
title: const Text('GitHub'),
subtitle: const Text('github.com'),
trailing: const Icon(Icons.open_in_new),
onTap: () => _ouvrirLien('https://github.com'),
),
),
Card(
child: ListTile(
leading: const Icon(Icons.work_outline, color: Color(0xFF0A66C2)),
title: const Text('LinkedIn'),
subtitle: const Text('BAHATI IRUMVA EUGENE'),
trailing: const Icon(Icons.open_in_new),
onTap: () => _ouvrirLien('linkedin.com'),
),
),
],
);
}
}