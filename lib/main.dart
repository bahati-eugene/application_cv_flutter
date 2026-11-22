import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

String get apiBaseUrl {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2';
  }
  return 'http://localhost/api-test/public';
}

void main() {
  runApp(const MonCvApp());
}

class MonCvApp extends StatelessWidget {
  const MonCvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV - BAHATI IRUMVA EUGENE (TP2)',
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
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;
  bool isRegisterMode = false;

  Future<void> soumettreFormulaire() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final endpoint = isRegisterMode ? '/accounts/register' : '/accounts/login';
    final url = Uri.parse('$apiBaseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (!mounted) return;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        if (isRegisterMode) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Compte cree ! Connectez-vous maintenant.'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() => isRegisterMode = false);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigationScreen(
                utilisateurEmail: emailController.text.trim(),
              ),
            ),
          );
        }
      } else {
        String errorMsg = data['message'] ?? 'Erreur authentification';
        if (data['errors'] != null && data['errors'] is Map) {
          errorMsg += '\n${(data['errors'] as Map).values.join('\n')}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur serveur WampServer : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_person, size: 80, color: Color(0xFF1565C0)),
                      const SizedBox(height: 16),
                      Text(
                        isRegisterMode ? 'Creer un compte' : 'Connexion',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Portfolio de BAHATI IRUMVA EUGENE',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Adresse E-mail',
                          hintText: 'marloweugene2000@gmail.com',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            (v == null || !v.contains('@')) ? 'E-mail valide requis' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe (6 caracteres min.)',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => obscurePassword = !obscurePassword),
                          ),
                        ),
                        validator: (v) =>
                            (v == null || v.length < 6) ? '6 caracteres minimum' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : soumettreFormulaire,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(isRegisterMode ? 'Enregistrer le compte' : 'Se connecter'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => setState(() => isRegisterMode = !isRegisterMode),
                        child: Text(
                          isRegisterMode
                              ? 'Deja un compte ? Se connecter'
                              : 'Pas encore de compte ? Creer un compte',
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
  final String utilisateurEmail;
  const MainNavigationScreen({super.key, required this.utilisateurEmail});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    CvHomePage(),
    FamillePage(),
    ContactPage(),
  ];

  final List<String> titles = const ['Mon CV', 'Ma Famille (API)', 'Mes Coordonnees'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Se deconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ),
          ),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFF1565C0),
        onTap: (index) => setState(() => selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.badge), label: 'CV / Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: 'Famille'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_phone), label: 'Contact'),
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
errorBuilder: (ctx, err, st) =>
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
'Etudiant en Licence 3 - Informatique Appliquee a la Gestion des Entreprises (ISIG Goma)',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 15,
color: Color(0xFF1565C0),
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 8),
const Text(
'Futur analyste-programmeur specialise dans la conception de solutions logicielles, mobiles et de systemes information pour la gestion des entreprises.',
textAlign: TextAlign.center,
),
],
),
),
const Divider(height: 32),
buildSection(Icons.school, 'Formation'),
buildCard(
'Licence 3 en Informatique Appliquee a la Gestion des Entreprises',
'ISIG Goma • 2025 - 2026',
'Developpement mobile (Flutter), API REST, Bases de donnees (SQL), Comptabilite et Gestion.',
),
buildCard('Diplome Etat', 'Goma, Nord-Kivu', 'Obtention du diplome Etat.'),
buildSection(Icons.work, 'Experiences & Projets'),
buildCard(
'Application Mobile Flutter connectee a une API REST (TP2)',
'ISIG Goma • 2026',
'Authentification reelle et gestion dynamique (CRUD) de la famille avec MySQL.',
),
buildSection(Icons.code, 'Competences Techniques'),
const Wrap(
spacing: 8,
runSpacing: 8,
children: [
Chip(label: Text('Flutter & Dart')),
Chip(label: Text('API REST & JSON')),
Chip(label: Text('PHP & MySQL')),
Chip(label: Text('Informatique de Gestion')),
Chip(label: Text('Git & GitHub')),
],
),
const SizedBox(height: 16),
buildSection(Icons.language, 'Competences Linguistiques'),
const ListTile(dense: true, leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Francais : Courant')),
const ListTile(dense: true, leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Swahili : Courant')),
const ListTile(dense: true, leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Anglais : Intermediaire')),
buildSection(Icons.favorite, 'Centres interet'),
const Wrap(
spacing: 8,
runSpacing: 8,
children: [
Chip(label: Text('Programmation mobile')),
Chip(label: Text('Gestion & Entrepreneuriat')),
Chip(label: Text('Lecture')),
Chip(label: Text('Sport')),
],
),
],
),
);
}
Widget buildSection(IconData icon, String title) => Padding(
padding: const EdgeInsets.only(top: 12, bottom: 8),
child: Row(
children: [
Icon(icon, color: const Color(0xFF1565C0)),
const SizedBox(width: 8),
Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
],
),
);
Widget buildCard(String t, String s, String d) => Card(
margin: const EdgeInsets.only(bottom: 10),
child: Padding(
padding: const EdgeInsets.all(12),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
Text(s, style: const TextStyle(color: Color(0xFF1565C0), fontSize: 13)),
const SizedBox(height: 4),
Text(d, style: const TextStyle(fontSize: 13)),
],
),
),
);
}
class MembreFamilleApi {
final int id;
final String nom, postnom, prenom, lieuNaissance, dateNaissance, parente;
final String? imageUrl;
MembreFamilleApi({
required this.id,
required this.nom,
required this.postnom,
required this.prenom,
required this.lieuNaissance,
required this.dateNaissance,
required this.parente,
this.imageUrl,
});
factory MembreFamilleApi.fromJson(Map<String, dynamic> j) => MembreFamilleApi(
id: int.parse(j['id'].toString()),
nom: j['nom'] ?? '',
postnom: j['postnom'] ?? '',
prenom: j['prenom'] ?? '',
lieuNaissance: j['lieu_naissance'] ?? '',
dateNaissance: j['date_naissance'] ?? '',
parente: j['parente'] ?? '',
imageUrl: j['image_url'],
);
}
class FamillePage extends StatefulWidget {
const FamillePage({super.key});
@override
State createState() => _FamillePageState();
}
class _FamillePageState extends State {
List membres = [];
bool isLoading = true;
String? erreur;
@override
void initState() {
super.initState();
chargerMembres();
}
Future chargerMembres() async {
setState(() {
isLoading = true;
erreur = null;
});
try {
final res = await http.get(Uri.parse('$apiBaseUrl/famille-membres'));
final data = jsonDecode(res.body);
if (res.statusCode == 200 && data['success'] == true) {
final List list = data['data'] ?? [];
setState(() {
membres = list.map((e) => MembreFamilleApi.fromJson(e)).toList();
isLoading = false;
});
} else {
setState(() {
erreur = data['message'] ?? 'Erreur de chargement';
isLoading = false;
});
}
} catch (e) {
setState(() {
erreur = 'Erreur connexion API : $e';
isLoading = false;
});
}
}
Future supprimerMembre(MembreFamilleApi m) async {
final ok = await showDialog(
context: context,
builder: (ctx) => AlertDialog(
title: const Text('Supprimer'),
content: Text('Supprimer ${m.prenom} ${m.nom} ?'),
actions: [
TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
onPressed: () => Navigator.pop(ctx, true),
child: const Text('Supprimer'),
),
],
),
);
if (ok != true) return;
final res = await http.delete(Uri.parse('$apiBaseUrl/famille-membres/${m.id}'));
final data = jsonDecode(res.body);
if (!mounted) return;
if (res.statusCode == 200 && data['success'] == true) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Membre supprime'), backgroundColor: Colors.green),
);
chargerMembres();
}
}
Future ouvrirFormulaire({MembreFamilleApi? existant}) async {
final dlgFormKey = GlobalKey<FormState>();
final nomCtrl = TextEditingController(text: existant?.nom ?? 'BAHATI');
final postnomCtrl = TextEditingController(text: existant?.postnom ?? 'IRUMVA');
final prenomCtrl = TextEditingController(text: existant?.prenom ?? '');
final lieuCtrl = TextEditingController(text: existant?.lieuNaissance ?? 'Goma');
final dateCtrl = TextEditingController(text: existant?.dateNaissance ?? '2000-01-01');
final parenteCtrl = TextEditingController(text: existant?.parente ?? 'Frere');
XFile? photo;
bool envoi = false;
await showDialog(
context: context,
barrierDismissible: false,
builder: (ctx) => StatefulBuilder(
builder: (context, setDlg) => AlertDialog(
title: Text(existant == null ? 'Ajouter un membre' : 'Modifier ${existant.prenom}'),
content: SingleChildScrollView(
child: Form(
key: dlgFormKey,
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextFormField(
controller: nomCtrl,
decoration: const InputDecoration(labelText: 'Nom *'),
validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
),
TextFormField(
controller: postnomCtrl,
decoration: const InputDecoration(labelText: 'Postnom *'),
validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
),
TextFormField(
controller: prenomCtrl,
decoration: const InputDecoration(labelText: 'Prenom *'),
validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
),
TextFormField(
controller: parenteCtrl,
decoration: const InputDecoration(labelText: 'Lien de parente *'),
validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
),
TextFormField(
controller: lieuCtrl,
decoration: const InputDecoration(labelText: 'Lieu de naissance *'),
validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
),
TextFormField(
controller: dateCtrl,
decoration: const InputDecoration(labelText: 'Date naissance (AAAA-MM-JJ) *'),
validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
),
const SizedBox(height: 10),
OutlinedButton.icon(
onPressed: () async {
final p = await ImagePicker().pickImage(source: ImageSource.gallery);
if (p != null) setDlg(() => photo = p);
},
icon: const Icon(Icons.photo_camera),
label: Text(photo != null ? photo!.name : 'Choisir une photo'),
),
],
),
),
),
actions: [
TextButton(onPressed: envoi ? null : () => Navigator.pop(ctx), child: const Text('Annuler')),
ElevatedButton(
onPressed: envoi
? null
: () async {
if (!dlgFormKey.currentState!.validate()) return;
setDlg(() => envoi = true);
final isModif = existant != null;
final url = isModif
? Uri.parse('$apiBaseUrl/famille-membres/${existant.id}')
: Uri.parse('$apiBaseUrl/famille-membres');
http.Response res;
if (photo != null || !isModif) {
final req = http.MultipartRequest('POST', url);
req.fields['nom'] = nomCtrl.text.trim();
req.fields['postnom'] = postnomCtrl.text.trim();
req.fields['prenom'] = prenomCtrl.text.trim();
req.fields['lieu_naissance'] = lieuCtrl.text.trim();
req.fields['date_naissance'] = dateCtrl.text.trim();
req.fields['parente'] = parenteCtrl.text.trim();
if (photo != null) {
req.files.add(http.MultipartFile.fromBytes(
'image',
await photo!.readAsBytes(),
filename: photo!.name,
));
}
res = await http.Response.fromStream(await req.send());
} else {
res = await http.put(
url,
headers: {'Content-Type': 'application/json'},
body: jsonEncode({
'nom': nomCtrl.text.trim(),
'postnom': postnomCtrl.text.trim(),
'prenom': prenomCtrl.text.trim(),
'lieu_naissance': lieuCtrl.text.trim(),
'date_naissance': dateCtrl.text.trim(),
'parente': parenteCtrl.text.trim(),
}),
);
}
final data = jsonDecode(res.body);
if (!mounted) return;
if ((res.statusCode == 200 || res.statusCode == 201) &&
data['success'] == true) {
Navigator.pop(ctx);
chargerMembres();
} else {
setDlg(() => envoi = false);
ScaffoldMessenger.of(this.context).showSnackBar(
SnackBar(
content: Text(data['message'] ?? 'Erreur'),
backgroundColor: Colors.red,
),
);
}
},
child: const Text('Enregistrer'),
),
],
),
),
);
}
@override
Widget build(BuildContext context) {
return Scaffold(
body: isLoading
? const Center(child: CircularProgressIndicator())
: erreur != null
? Center(child: Text(erreur!))
: ListView.builder(
padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
itemCount: membres.length,
itemBuilder: (context, i) {
final m = membres[i];
return Card(
margin: const EdgeInsets.only(bottom: 12),
child: ListTile(
leading: CircleAvatar(
backgroundColor: Colors.blue.shade100,
child: m.imageUrl != null && m.imageUrl!.isNotEmpty
? ClipOval(
child: Image.network(
m.imageUrl!,
width: 40,
height: 40,
fit: BoxFit.cover,
errorBuilder: (ctx, err, st) => const Icon(Icons.person),
),
)
: const Icon(Icons.person),
),
title: Text('${m.prenom} ${m.nom} ${m.postnom}',
style: const TextStyle(fontWeight: FontWeight.bold)),
subtitle: Text('${m.parente} • Ne(e) le ${m.dateNaissance} a ${m.lieuNaissance}'),
trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
IconButton(
icon: const Icon(Icons.edit, color: Colors.orange),
onPressed: () => ouvrirFormulaire(existant: m),
),
IconButton(
icon: const Icon(Icons.delete, color: Colors.red),
onPressed: () => supprimerMembre(m),
),
],
),
),
);
},
),
floatingActionButton: FloatingActionButton.extended(
onPressed: () => ouvrirFormulaire(),
backgroundColor: const Color(0xFF1565C0),
foregroundColor: Colors.white,
icon: const Icon(Icons.person_add),
label: const Text('Ajouter'),
),
);
}
}
class ContactPage extends StatelessWidget {
const ContactPage({super.key});
Future ouvrir(String url) async {
await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
@override
Widget build(BuildContext context) {
return ListView(
padding: const EdgeInsets.all(16),
children: [
Card(
child: ListTile(
leading: const Icon(Icons.phone, color: Colors.green),
title: const Text('Telephone principal'),
subtitle: const Text('+243 980 576 900'),
onTap: () => ouvrir('tel:+243980576900'),
),
),
Card(
child: ListTile(
leading: const Icon(Icons.phone_android, color: Colors.teal),
title: const Text('Telephone secondaire'),
subtitle: const Text('+243 903 886 201'),
onTap: () => ouvrir('tel:+243903886201'),
),
),
Card(
child: ListTile(
leading: const Icon(Icons.email, color: Colors.red),
title: const Text('E-mail'),
subtitle: const Text('marloweugene2000@gmail.com'),
onTap: () => ouvrir('mailto:marloweugene2000@gmail.com'),
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
onTap: () => ouvrir('github.com'),
),
),
],
);
}
}
