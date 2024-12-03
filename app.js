const express = require('express');
const app = express();
const { engine } = require('express-handlebars');

app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.use(express.json());
app.use(express.static('public'));

let isLoggedIn = false; // Sisselogimise olek.
const validCredentials = { email: '', password: '' }; // Näidisandmed admini jaoks.
const doctors = [
    { id: 1, name: 'Dr. John Doe', speciality: 'Cardiologist', age: 45, price: 50, photo: 'https://via.placeholder.com/150' },
    { id: 2, name: 'Dr. Jane Smith', speciality: 'Dermatologist', age: 38, price: 40, photo: 'https://via.placeholder.com/150' },
    { id: 3, name: 'Dr. Alex Johnson', speciality: 'Neurologist', age: 50, price: 60, photo: 'https://via.placeholder.com/150' },
    { id: 4, name: 'Dr. Emily Brown', speciality: 'Pediatrician', age: 35, price: 30, photo: 'https://via.placeholder.com/150' }
];

let users = []; // Kasutajate andmebaasi simulatsioon (registreerimise jaoks).

// Koduleht
app.get('/', (req, res) => {
    if (isLoggedIn) {
        res.render('home', { doctors }); // Kuvame arstide nimekirja, kui kasutaja on sisse logitud.
    } else {
        res.render('sign-in'); // Kui pole sisse logitud, näidatakse sisselogimise vormi.
    }
});

// Sisselogimine
app.post('/login', (req, res) => {
    const { email, password } = req.body;

    if (email === validCredentials.email && password === validCredentials.password) {
        isLoggedIn = true; // Kasutaja logitakse sisse.

        res.json({ success: true });
    } else {
        res.json({ success: false, message: 'Incorrect username or password' }); // Vale andmete korral tagastatakse veateade.
    }
});

// Registreerimine (sign-up)
app.post('/signup', (req, res) => {
    const { username, email, password } = req.body;

    // Kontrollime, kas email on juba kasutusel
    const userExists = users.some(user => user.email === email);

    if (userExists) {
        return res.json({ success: false, message: 'Email is already in use' });
    }

    // Lisame uue kasutaja
    users.push({ username, email, password });
    res.json({ success: true, message: 'Account created successfully!' });
});

// Logi välja
app.get('/logout', (req, res) => {
    isLoggedIn = false; // Kasutaja logitakse välja.
    res.redirect('/'); // Suunatakse tagasi kodulehele.
});

// Arsti profiil
app.get('/doctor/:id', (req, res) => {
    const doctor = doctors.find(d => d.id === parseInt(req.params.id));
    if (doctor) {
        res.render('profile', { doctor }); // Kuvame valitud arsti profiili.
    } else {
        res.status(404).send('Doctor not found'); // Kui ID-d ei leita, tagastame veateate.
    }
});

// Serveri käivitamine
app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});