#-----------------------------------------------------PRE-EVENT SET-UP-----------------------------------------------------
# Update and upgrade everything before moving on
sudo apt update && sudo apt upgrade -y

# Get the time zone
x=$(cat /etc/timezone)

# Create a folder to hold all the files
sudo mkdir /Home-Assistant

#-----------------------------------------------------HOME ASSISTANT-----------------------------------------------------

# Download and run the container
docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=$x \# Replace with correct timezone
  -v /Home-Assistant:/config \# Replace with correct folder location
  -v /run/dbus:/run/dbus:ro \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable

echo "You can now access your install by going to http://(Your IP):8123"