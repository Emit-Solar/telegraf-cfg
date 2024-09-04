#!/bin/bash

echo "Installing telegraf..."
curl -fsSL https://repos.influxdata.com/influxdata-archive_compat.key -o /etc/apt/keyrings/influxdata-archive_compat.key
echo "deb [signed-by=/etc/apt/keyrings/influxdata-archive_compat.key] https://repos.influxdata.com/debian stable main" | tee /etc/apt/sources.list.d/influxdata.list 
apt update
apt -y install telegraf

usermod -aG dialout telegraf
sudo systemctl enable telegraf

read -p "Huawei or Growatt? [H/G]: " x
if [[ "$x" == "h" || "$x" == "H" ]]; then
    sudo cp ./huawei_telegraf.conf /etc/telegraf/telegraf.conf
elif [[ "$x" == "g" || "$x" == "G" ]]; then
    sudo cp ./growatt_telegraf.conf /etc/telegraf/telegraf.conf
else
    echo "invalid option"
    exit 1
fi

echo "Modifying config.txt..."
sudo bash -c 'echo "enable_uart=1" >> /boot/firmware/config.txt'

echo "Installing rpi-connect..."
apt-get install rpi-connect-lite
sudo loginctl enable-linger

sudo bash -c 'echo "211.24.220.161  723tgfhf7917f32.time.com.my" >> /etc/hosts'

sudo reboot now