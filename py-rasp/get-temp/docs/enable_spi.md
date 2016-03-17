# Enable SPI on Raspberry Pi

The Raspberry Pi has a Serial Peripheral Interface (SPI) bus which can be enabled on [Pins](http://sur.ly/o/pinout.xyz/AA000014) 19,21,23,24 & 26. 
It is a synchronous serial data link standard and is used for short distance single master communication between devices. 
As far as the Pi is concerned this is usually relevant to certain sensors and add-on boards.

The default Raspbian image disable SPI by default, so you should enable it before using.

## Enable SPI

####Method 1 - Using "Raspi-Config"

`sudo raspi-config`

advance -> SPI -> SPI kernel module loaded -> yes -> finish -> reboot

####Method 2 - Editing file manually 

`sudo nano /boot/config.txt`

uncommit the following line in the file or add it at the end of file

`dtparam=spi=on`

save file and reboot using `sudo reboot`

## Check if SPI ist enabled 

check if SPI module is loaded by system using:

`lsmod | grep spi_`
