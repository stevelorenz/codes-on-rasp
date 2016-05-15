#!/bin/bash
# ---------------------------------------------------------
# About  : Install tools and libs used for this experiment
# Email  : xianglinks@gmail.com
# ---------------------------------------------------------

echo "starting install dependencies"
echo "including i2c-tools, wiringPi and cgdb"

sudo apt-get update

install="sudo apt-get install"

$install i2c-tools
$install cgdb

echo "installing wiringPi lib"
$install git
git clone git://git.drogon.net/wiringPi ~/wiringPi
cd ~/wiringPi || exit
./build

echo "installation finished"
echo "test wiringPi with /$ gpio readall"
