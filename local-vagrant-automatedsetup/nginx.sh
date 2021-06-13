echo "installing updates and upgrades..."
sudo apt update -y
sudo apt upgrade -y

echo "switching to root user..."
sudo -i

echo "installing nginx..."
apt install nginx -y

echo "cloning git repo..."
git clone https://github.com/ashikkhulal/my-site.git

echo "copying site files to /usr/share/nginx/html/..."
cp -R my-site/* /usr/share/nginx/html/

echo "making new site config file..."
cat <<EOT >> mysite
server {
        listen 80;

        server_name my-site;

        location / {
                root /usr/share/nginx/html/;
                index index.html;
        }
}

EOT

echo "starting nginx service..."
systemctl start nginx

echo "pinging the site..."
ping -c 2 192.168.33.11

echo "stopping nginx service..."
systemctl stop nginx

sleep 10

echo "moving config file to /etc/nginx/sites-available..."
mv mysite /etc/nginx/sites-available/mysite

echo "renaming default config files..."
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.txt
mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.txt

echo "linking new config files..."
ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/mysite

echo "restarting nginx service..."
systemctl restart nginx

sleep 30

echo "Your site should be up and running now at 192.168.33.11"