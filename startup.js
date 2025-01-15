#!/bin/bash
// Update package lists
const exec = require('child_process').exec;
exec('sudo apt-get update -y', (err, stdout, stderr) => {
  if (err) {
    console.error(`Error updating packages: ${stderr}`);
    return;
  }
  
  // Install Nginx
  exec('sudo apt-get install -y nginx', (err, stdout, stderr) => {
    if (err) {
      console.error(`Error installing Nginx: ${stderr}`);
      return;
    }

    // Create the required directory for the web content
    exec('sudo mkdir -p /var/www/html', (err, stdout, stderr) => {
      if (err) {
        console.error(`Error creating directory: ${stderr}`);
        return;
      }

      // Write "Hello World" to the index.html file
      exec('echo "Hello World" | sudo tee /var/www/html/index.html', (err, stdout, stderr) => {
        if (err) {
          console.error(`Error writing index.html: ${stderr}`);
          return;
        }

        // Restart Nginx to apply changes
        exec('sudo systemctl restart nginx', (err, stdout, stderr) => {
          if (err) {
            console.error(`Error restarting Nginx: ${stderr}`);
            return;
          }

          console.log('Nginx is set up and "Hello World" page is configured.');
        });
      });
    });
  });
});
