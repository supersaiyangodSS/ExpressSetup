#!/bin/bash

echo "########################################"
echo "# Script written by Vedant Kale        #"
echo "# GitHub: https://github.com/vedant8177 #"
echo "########################################"

read -p "Enter project name: " project_name

project_dir="${project_name}"
mkdir "${project_dir}"
cd "${project_dir}"

npm init -y

npm install express
npm install --save-dev nodemon

touch app.js
echo "const express = require('express');
const app = express();
const port = 3000 || process.env.PORT;

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.listen(port, () => console.log(\`Server running on port: \${port}\`));
" > app.js

sed -i 's/"main": "index.js"/"main": "app.js"/' package.json
sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"start": "node app.js",\n  "server": "nodemon app.js"/' package.json

echo "Node.js Express project setup complete."
