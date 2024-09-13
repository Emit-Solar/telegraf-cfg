#!/bin/bash

read -p "Solis/Growatt/Huawei? [S/G/H]: " x

if [[ ! $x =~ ^(S|s|G|g|H|h)$ ]]; then
    echo "invalid option"
    exit 1
fi

echo "Installing telegraf..."
sleep 2
curl -fsSL https://repos.influxdata.com/influxdata-archive_compat.key -o /etc/apt/keyrings/influxdata-archive_compat.key
echo "deb [signed-by=/etc/apt/keyrings/influxdata-archive_compat.key] https://repos.influxdata.com/debian stable main" | tee /etc/apt/sources.list.d/influxdata.list 
apt update
apt -y install telegraf

echo "Enabling the telegraf service..."
sleep 2
usermod -aG dialout telegraf
sudo systemctl enable telegraf

echo "Creating telegraf.conf..."
if [[ "$x" == "s" || "$x" == "S" ]]; then
    sudo cp ./solis_telegraf.conf /etc/telegraf/telegraf.conf
    echo "Enabling the CAN HAT..."
    sleep 2
    sudo bash -c 'echo "enable_uart=1" >> /boot/firmware/config.txt'
elif [[ "$x" == "g" || "$x" == "G" ]]; then
    sudo cp ./growatt_telegraf.conf /etc/telegraf/telegraf.conf
    echo "Enabling the CAN HAT..."
    sleep 2
    sudo bash -c 'echo "enable_uart=1" >> /boot/firmware/config.txt'
elif [[ "$x" == "h" || "$x" == "H" ]]; then
    sudo cp ./huawei_telegraf.conf /etc/telegraf/telegraf.conf
fi


loginctl enable-linger

echo "Modifying hosts file..."
sleep 2
sudo bash -c 'echo "211.24.220.161  723tgfhf7917f32.time.com.my" >> /etc/hosts'

echo "Installing rpi-clone..."
sleep 2
curl https://raw.githubusercontent.com/geerlingguy/rpi-clone/master/install | sudo bash 

echo "Rebooting..."
sleep 2
sudo reboot now
