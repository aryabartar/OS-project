import os
import socket
import subprocess

s = socket.socket()
host = '127.0.0.1'
port = 9996
s.connect((host, port))


while True:
    print("Client recienving.")
    print(s.recv(1024))

    print("Client sending.")
    s.send(input().encode())
