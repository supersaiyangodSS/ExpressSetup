#!/bin/bash

echo "########################################"
echo "# Script written by Vedant Kale        #"
echo "# GitHub: https://github.com/supersaiyangodss #"
echo "########################################"

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to install dependencies based on package manager
install_dependencies() {
    if [ "$package_manager" == "npm" ]; then
        npm install express
        npm install --save-dev nodemon
    elif [ "$package_manager" == "pnpm" ]; then
        pnpm install express
        pnpm install nodemon
    else
        handle_error "Invalid package manager specified."
    fi
}

# Function to initialize Git repository
initialize_git() {
    git init
    git add .
    git commit -m "Initial commit"
}

# Generate .gitignore file
generate_gitignore() {
    echo "node_modules/" > .gitignore
}

# Function to show loading message
show_loading() {
    echo -ne "Installing dependencies... \r"
    sleep 1
    echo -ne "Installing dependencies... Done!  \n"
}

read -p "Enter project name: " project_name

project_dir="${project_name}"
mkdir "${project_dir}" || handle_error "Failed to create project directory."
cd "${project_dir}" || handle_error "Failed to change directory."

package_managers=("npm" "pnpm")
select package_manager in "${package_managers[@]}"; do
    if [ "$package_manager" ]; then
        echo "Selected package manager: $package_manager"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

npm init -y || handle_error "Failed to initialize package.json."

install_dependencies & show_loading

touch app.js
cat << EOF > app.js
const express = require("express");
const app = express();
const port = 3000 || process.env.PORT;

app.get('/', (req, res) => {
  res.send('Hello, World!')
});

app.listen(port, () => console.log(\`Server running on port: \${port}\`));
EOF

sed -i 's/"main": "index.js"/"main": "app.js"/' package.json
sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"start": "node app.js",\n  "server": "nodemon app.js"/' package.json

generate_gitignore

echo "Node.js Express project setup complete."

read -p "Do you want to initialize a Git repository? (y/n): " initialize_git_option
if [ "$initialize_git_option" == "y" ]; then
    initialize_git
fi

echo "Project setup complete."
