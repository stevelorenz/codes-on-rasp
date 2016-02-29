Das Öffnen des /dev/mem Geräts auf dem RPi erfordert Root-Rechte, das Programm gdbserver ist dementsprechend beim Debuggen mit "sudo gdbserver :2345 " auszuführen.

Sie finden in diesem Verzeichnis das Skript gdbserver.dat, das in /usr/local/sbin auf dem Rasberry Pi zu speichern ist. Das Programm muss mit "chmod +x /usr/local/sbin/gdbserver.dat" ausführbar gemacht werden.
