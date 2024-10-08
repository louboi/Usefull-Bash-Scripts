# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

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