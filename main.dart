import 'package:flutter/material.dart';

void main() {
  runApp(TravelAssistantApp());
}

class TravelAssistantApp extends StatefulWidget {
  @override
  _TravelAssistantAppState createState() => _TravelAssistantAppState();
}

class _TravelAssistantAppState extends State<TravelAssistantApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'India Travel Assistant',
      theme: ThemeData(primarySwatch: Colors.deepPurple, brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
      home: LoginPage(toggleTheme: toggleTheme),
    );
  }
}

// ---------------------- LOGIN PAGE ----------------------

class LoginPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  LoginPage({required this.toggleTheme});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  final Map<String, Map<String, dynamic>> users = {
    'admin': {'password': '1234', 'emailVerified': true},
    'testuser': {'password': 'abcd', 'emailVerified': false},
  };

  void login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (users.containsKey(username) && users[username]!['password'] == password) {
      if (users[username]!['emailVerified'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CitySelectionPage(username: username, toggleTheme: widget.toggleTheme)),
        );
      } else {
        setState(() {
          errorMessage = 'Email not verified. Please verify your email first.';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Invalid username or password';
      });
    }
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void loginWithFacebook() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Facebook login pressed (not implemented)')),
    );
  }

  void loginWithEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email login pressed (not implemented)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text('OR', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: loginWithFacebook,
              icon: Icon(Icons.facebook, color: Colors.white),
              label: Text('Login with Facebook'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: loginWithEmail,
              icon: Icon(Icons.email, color: Colors.white),
              label: Text('Login with Email'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: navigateToSignUp,
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- SIGN UP PAGE ----------------------

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? errorMessage;

  void signUp() {
    String username = usernameController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    // Normally here you'd add the user to your backend or database
    // For now, just show a success message and pop back to login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User registered successfully! Please login.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- CITY SELECTION PAGE ----------------------

class CitySelectionPage extends StatefulWidget {
  final String username;
  final VoidCallback toggleTheme;

  CitySelectionPage({required this.username, required this.toggleTheme});

  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  final List<String> cities = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Chennai',
    'Jaipur',
    'Goa',
  ];
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.username),
              accountEmail: Text('${widget.username}@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.username[0].toUpperCase(),
                  style: TextStyle(fontSize: 40.0, color: Colors.deepPurple),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(username: widget.username)));
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Toggle Theme'),
              onTap: () {
                Navigator.pop(context);
                widget.toggleTheme();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(toggleTheme: widget.toggleTheme)));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Select a City to explore:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Choose a city'),
              value: selectedCity,
              items: cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
                if (value != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DestinationInfoPage(city: value)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- PROFILE PAGE ----------------------

class ProfilePage extends StatelessWidget {
  final String username;

  ProfilePage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $username', style: TextStyle(fontSize: 22)),
            SizedBox(height: 10),
            Text('Email: $username@example.com', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Member since: January 2025', style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.deepPurple,
                child: Text(
                  username[0].toUpperCase(),
                  style: TextStyle(fontSize: 60, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- DESTINATION INFO PAGE ----------------------

class DestinationInfoPage extends StatelessWidget {
  final String city;

  DestinationInfoPage({required this.city});

  final Map<String, Map<String, dynamic>> cityData = {
    'Delhi': {
      'images': [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsPA9aUzGdlSYx3-95jnZeZfqT4Btm3KsvNw&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShc8xG4dWjMoiNV9EGgunww7OEBJOu028ztQ&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRG-Qk4xqrB9SKLv_PnWdk1mouSNasxWMTyzw&s',
      ],
      'climate': 'Delhi has a humid subtropical climate with hot summers and cool winters.',
      'places': 'India Gate, Qutub Minar, Red Fort, Lotus Temple.',
      'food': 'Famous for street food like chaat, butter chicken, parathas, and kebabs.',
      'tips': 'Use public transport to avoid traffic, stay hydrated in summers.',
      'itinerary': [
        'Day 1: Visit India Gate and Rashtrapati Bhavan.',
        'Day 2: Explore Qutub Minar and Lotus Temple.',
        'Day 3: Tour Red Fort and Chandni Chowk markets.',
      ],
    },
    'Mumbai': {
      'images': [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI0mdAH5bOYUcPYzmzmsSOsc1KL0YnBczeFPatphfq3U3w1eMMtSQ_UUrY0k5GuJRfakM&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS563i3y1j1VffI2GbbZiVnuJEhWVOWjtPN8u14k98Z2O1Zd7d76Up-zurTvCd0gYZ_Evk&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt6ODFVLV-s2KoqyK9hZ9Gl-_BmR0HDdcbtA&s',
      ],
      'climate': 'Mumbai has a tropical climate with a distinct monsoon season.',
      'places': 'Gateway of India, Marine Drive, Elephanta Caves, Chowpatty Beach.',
      'food': 'Famous for vada pav, pav bhaji, bhel puri, and seafood.',
      'tips': 'Avoid peak monsoon flooding, try local street food safely.',
      'itinerary': [
        'Day 1: Visit Gateway of India and Colaba Causeway.',
        'Day 2: Explore Elephanta Caves and Marine Drive.',
        'Day 3: Relax at Chowpatty Beach and try street snacks.',
      ],
    },
    'Bangalore': {
      'images': [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGsV0IMqdU39yj2qroRFhjKBZ64gws5J9h2g&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKAuaLNSE7V48HcUf2hrXuMxuSMRkS01tiWA&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnXWxYstftfsjpYaCTvyGyYxRmF4IvwbSkUQ&s',
      ],
      'climate': 'Bangalore has a tropical savanna climate with moderate temperatures.',
      'places': 'Lalbagh Botanical Garden, Vidhana Soudha, Cubbon Park, Bangalore Palace.',
      'food': 'Known for dosa, idli, filter coffee, and Mysore pak.',
      'tips': 'Evenings can get cool; carry a light jacket.',
      'itinerary': [
        'Day 1: Visit Lalbagh Botanical Garden and Cubbon Park.',
        'Day 2: Explore Bangalore Palace and Vidhana Soudha.',
        'Day 3: Enjoy shopping and cafes on MG Road.',
      ],
    },

    // --- New cities ---

    'Chennai': {
      'images': [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKh58YYhakDnWdZZtkqCxyzutkIIG_vDQnoQ&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuwgI3b_1d_iX1JmW1JpBa58Snlvc29_P5Wg&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjsokMsI7u6nZlpt1tHIWpd8IdR_DVFp8C2w&s',
      ],
      'climate': 'Chennai has a tropical wet and dry climate with hot and humid weather throughout the year.',
      'places': 'Marina Beach, Kapaleeshwarar Temple, Fort St. George, San Thome Basilica.',
      'food': 'Known for dosa, idli, filter coffee, and spicy Chettinad cuisine.',
      'tips': 'Visit early morning for beach walks, beware of heat during summer months.',
      'itinerary': [
        'Day 1: Relax at Marina Beach, visit Fort St. George.',
        'Day 2: Explore Kapaleeshwarar Temple and San Thome Basilica.',
        'Day 3: Visit local markets and try street food.',
      ],
    },
    'Jaipur': {
      'images': [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSy_4434_L-Fw3d7CF64dw6F9AMHZ63dNTm_Q&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb5wYA-VTXF2oJ5lWqP7MpKWHmMp8j9RKACg&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8iWYCOk9essTRAQQfKUkFOxVeMkpLQwnZmQ&s',
      ],
      'climate': 'Jaipur has a hot semi-arid climate with very hot summers and mild winters.',
      'places': 'Hawa Mahal, Amber Fort, City Palace, Jantar Mantar.',
      'food': 'Famous for dal bati churma, ghewar, kachori, and Rajasthani thali.',
      'tips': 'Wear comfortable shoes for exploring forts, visit early to avoid heat and crowds.',
      'itinerary': [
        'Day 1: Explore Hawa Mahal and City Palace.',
        'Day 2: Visit Amber Fort and Jaigarh Fort.',
        'Day 3: Shop and stroll through local bazaars.',
      ],
    },
    'Goa': {
      'images': [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZOEzO4AC-Vo5RH6kjNMyV6CyJYlVoxbSsZV64_I2QhxgYZkLDLfe2mCjL3m8yFny_6d8&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlpNxUSH0JM3aSHMOv_1oc6RQa9WeQLSnGYA&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTalsw5ITU_ot1tYDvKr4NSVNRr9-NXTpx74Q&s',
      ],
      'climate': 'Goa has a tropical monsoon climate with warm and humid weather.',
      'places': 'Baga Beach, Basilica of Bom Jesus, Dudhsagar Falls, Anjuna Market.',
      'food': 'Known for Goan fish curry, vindaloo, seafood, and feni drink.',
      'tips': 'Best visited in winter months. Beaches get crowded during peak season.',
      'itinerary': [
        'Day 1: Relax at Baga and Calangute beaches.',
        'Day 2: Visit Basilica of Bom Jesus and Old Goa.',
        'Day 3: Explore Dudhsagar Falls and spice plantations.',
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final cityInfo = cityData[city];
    if (cityInfo == null) {
      return Scaffold(
        appBar: AppBar(title: Text(city)),
        body: Center(child: Text('No information available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(city),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cityInfo['images'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Image.network(cityInfo['images'][index], width: 300, fit: BoxFit.cover),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Climate:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(cityInfo['climate']),
            SizedBox(height: 15),
            Text('Places to Visit:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(cityInfo['places']),
            SizedBox(height: 15),
            Text('Local Food:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(cityInfo['food']),
            SizedBox(height: 15),
            Text('Tips:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(cityInfo['tips']),
            SizedBox(height: 15),
            Text('Itinerary:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(cityInfo['itinerary'].length, (i) {
                return Text(cityInfo['itinerary'][i]);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
