const express = require('express')
const app = express()
const port = 3000
const { engine } = require('express-handlebars');

app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.get('/', (req, res) => {
    res.render('Home')
})

app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`)
})