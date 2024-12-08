#-----------------------------------------------------PRE-EVENT SET-UP-----------------------------------------------------
# Update and upgrade everything before moving on
sudo apt update && sudo apt upgrade -y

#-----------------------------------------------------DOCKER-----------------------------------------------------
# Remove any old packages that may exist
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Confirm installation
echo "You can now test that the install has worked by typing -- sudo docker run hello-world"

#-----------------------------------------------------PORTAINER-----------------------------------------------------
# Create the volume used to store portainer data
sudo docker volume create portainer_data

# Download and install the docker container
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.2

# Verify everything is running
sudo docker ps -a

# Inform the user of the IP address to access the panel
x=$(hostname -I)

echo "You can access your instance via the link below:"
echo "https://" $x ":9443" | sed 's/ //g'

#-----------------------------------------------------HOME ASSISTANT-----------------------------------------------------

# Makea da cantainer from de file

docker compose up -d

x=$(hostname -I)

echo "You can now access your install by going to http://" $x ":8123" | sed 's/ //g'

#-----------------------------------------------------TAILSCALE-----------------------------------------------------
# Actually install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Enable port forwarding
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# Run as exit node
sudo tailscale up --advertise-exit-node --advertise-routes=192.0.2.0/24,198.51.100.0/24 --ssh

# Reboot
sudo reboot
