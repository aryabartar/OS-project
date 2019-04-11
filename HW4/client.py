#!/usr/bin/python

import sys
import socket
import selectors
import types
import threading
import time
import select

user_message = None


def write(sock, message):
    sock.sendall(message.encode())


def read(sock):
    message = sock.recv(1024).decode()
    print(message)
    if message == '-quit-':
        time.sleep(.3)
        quit()
        sys.exit(0)


def start_connections(host, port, client_name):
    server_addr = (host, port)
    print("starting connection", client_name, "to", server_addr)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setblocking(False)
    sock.connect_ex(server_addr)
    write(sock, "-SetName- {}".format(client_name))
    return sock


def get_user_message():
    global user_message
    while True:
        user_message = input()


if len(sys.argv) != 4:
    print("usage:", sys.argv[0], "<host> <port> <client_name>")
    sys.exit(1)

host, port, client_name = sys.argv[1:4]
sock = start_connections(host, int(port), client_name)

try:
    input_thread = threading.Thread(
        target=get_user_message, name="get_input_thread")
    input_thread.daemon = True
    input_thread.start()
    while True:
        (readable, writable, excetpional) = select.select(
            [sock], [sock], [sock] )

        for s in readable:
            read(s)

        for s in writable:
            if user_message is not None:
                write(s, user_message)
                user_message = None


except KeyboardInterrupt:
    print("caught keyboard interrupt, exiting")
    print("Closing connection!")
    sock.close()
