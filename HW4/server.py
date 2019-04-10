#!/usr/bin/python

import sys
import socket
import selectors
import types
import time
import select

sel = selectors.DefaultSelector()

read_sockets = []
write_sockets = []

group_message = None
sockets_data = {}


def accept_wrapper(sock):
    conn, addr = sock.accept()  # Should be ready to read
    print(conn)
    print("accepted connection from", addr)
    conn.setblocking(False)
    data = types.SimpleNamespace(addr=addr, inb=b"", outb=b"")
    events = selectors.EVENT_READ | selectors.EVENT_WRITE

    read_sockets.append(conn)
    write_sockets.append(conn)
    sockets_data[conn] = {"name": None, "groups": []}

    sel.register(conn, events, data=data)


def set_socket_name(sock, name):
    sockets_data[s]["name"] = name


if len(sys.argv) != 3:
    print("usage:", sys.argv[0], "<host> <port>")
    sys.exit(1)

host, port = sys.argv[1], int(sys.argv[2])
lsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
lsock.bind((host, port))
lsock.listen()
print("listening on", (host, port))
lsock.setblocking(False)
read_sockets.append(lsock)

try:
    while True:
        (readable, writable, excetpional) = select.select(
            read_sockets, write_sockets, read_sockets)

        # Readable sockets
        for s in readable:
            if s == lsock:
                accept_wrapper(s)
            else:
                data = s.recv(1024).decode()

                if data.split(" ")[0] == "-SetName-":
                    set_socket_name(s, data.split(' ')[1])
                elif data:
                    message = sockets_data[s]["name"] + " says: " + data
                    group_message = message

        # Writable sockets
        if s != [] and group_message is not None:
            for s in writable:
                s.send(group_message.encode())
            group_message = None

except KeyboardInterrupt:
    print("caught keyboard interrupt, exiting")
    sel.close()
