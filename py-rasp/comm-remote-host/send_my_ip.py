#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date   : So 08 Nov 2015 10:23:39 CET
# @About  : Send ip addr to remote host with email
# @Author : Xiang,Zuo
# @Mail   : xianglinks@gmail.com

import socket
import fcntl
import struct
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


# get ip of interfaces using socket
def get_ip_addr(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, struct.pack('256s', ifname[:15]))[20:24])

# sender informations
from_addr = 'your email addr'
password = 'your password'
smtp_server = 'smtp.gmail.com'
# reciever informations
to_addr = 'your object email addr'

# set smtp server
# server = smtplib.SMTP(smtp_server, 587)  # using port 587 with starttls
server = smtplib.SMTP_SSL(smtp_server, 465)  # using port 465 with SMTP_SSL
# if you using starttls you need to use ehlo() function
server.ehlo()
# server.starttls()

# define the send message
msg = MIMEMultipart()
# add from to and Subject to this email
msg['From'] = from_addr
msg['To'] = to_addr
msg['Subject'] = 'Report My IP_Addr'
# the body message hier using text(not html)
my_ip = get_ip_addr('wlan0')
body = str(my_ip)
msg.attach(MIMEText(body, 'plain', 'utf-8'))
text = msg.as_string()

# show the debug messages
server.set_debuglevel(1)
server.login(from_addr, password)
# send email
server.sendmail(from_addr, [to_addr], text)
# close the server
server.close()
print("Successful send the IP_Addr...")
