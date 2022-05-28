# Install Dropbox

64x 
``cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -``

32x 
``cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -``

``~/.dropbox-dist/dropboxd``

Now copy and paste the url into your browser and follow instructions. 

After success message, press ``CTRL + C``


# Install Dropbox CLI

``sudo apt install python -y``

``sudo wget -O /usr/local/bin/dropbox "https://www.dropbox.com/download?dl=packages/dropbox.py"``

``sudo chmod +x /usr/local/bin/dropbox``

``dropbox start``

# Start detect Script

``wget - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/dropbox_detect.sh``
