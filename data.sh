#!/bin/bash

# Install Apache on Ubuntu
sudo apt -y update
# apache installation, enabling and status check
sudo apt -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd | grep Active
# firewall installation, start and status check
sudo apt install firewalld
sudo systemctl start firewalld
sudo systemctl status firewalld | grep Active
# adding http services
sudo firewall-cmd — permanent — add-service=http
# reloading the firewall
sudo firewall-cmd — reload

sudo apt install nodejs -y
sudo apt install npm -y

nodejs --version
npm --version

mkdir ~/myapp
cd ~/myapp
npm init -y
node -e "console.log('Running Node.js ' + process.version)"
npm install express dotenv

cat > app.js << EOF
const express = require("express");
const app = express();

function fibo(n) {
  if (n < 2) return 1;
  else return fibo(n - 2) + fibo(n - 1);
}

app.get("/alive", (req, res) => res.send("Alive!"));
app.get("/", (req, res) => {
  res.send(fibo(req.query.fiboIdx || 40).toString());
});

app.listen(80, () => console.log(`YoYo server listening on port 80!`));
EOF

node app.js
