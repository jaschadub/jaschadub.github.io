#!/bin/bash
# Script to update and deploy the MkDocs site

# Activate virtual environment
source .venv/bin/activate

# Display menu options
echo "==== Jascha's Website Management ===="
echo "1. Build site"
echo "2. Run development server"
echo "3. Deploy to GitHub Pages"
echo "4. Update and deploy in one step"
echo "5. Exit"
echo ""
echo -n "Enter your choice (1-5): "
read choice

case $choice in
  1)
    echo "Building site..."
    mkdocs build
    echo "Site built in 'site/' directory."
    ;;
  
  2)
    echo "Starting development server..."
    echo "Press Ctrl+C to stop the server when done."
    echo "Access your site at http://127.0.0.1:9081"
    mkdocs serve --dev-addr=127.0.0.1:9081
    ;;
  
  3)
    echo "Deploying to GitHub Pages..."
    mkdocs gh-deploy
    echo "Site deployed!"
    ;;
  
  4)
    echo "Building and deploying site..."
    mkdocs build
    mkdocs gh-deploy
    echo "Site updated and deployed!"
    ;;
  
  5)
    echo "Exiting..."
    exit 0
    ;;
  
  *)
    echo "Invalid choice. Please run the script again."
    exit 1
    ;;
esac

# Deactivate virtual environment
deactivate
