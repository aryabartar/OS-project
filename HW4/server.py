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


def accept_wrapper(sock):
    conn, addr = sock.accept()  # Should be ready to read
    print(conn)
    print("accepted connection from", addr)
    conn.setblocking(False)
    data = types.SimpleNamespace(addr=addr, inb=b"", outb=b"")
    events = selectors.EVENT_READ | selectors.EVENT_WRITE
    read_sockets.append(conn)
    write_sockets.append(conn)
    sel.register(conn, events, data=data)


def service_connection(key, mask):
    sock = key.fileobj
    data = key.data
    print(mask)
    if mask & selectors.EVENT_READ:
        message = sock.recv(1024)
        print(message)

        # if message.decode() == "quit" :
        #     print ("Closed connection.")
        #     sel.unregister(sock)
        #     sock.close()
        # recv_data = sock.recv(1024)  # Should be ready to read
        # if recv_data:
        #     data.outb += recv_data
        # else:
        #     print("closing connection to", data.addr)
        #     sel.unregister(sock)
        #     sock.close()

    if mask & selectors.EVENT_WRITE:
        if data.outb:
            print("echoing", repr(data.outb), "to", data.addr)
            sent = sock.send(data.outb)  # Should be ready to write
            data.outb = data.outb[sent:]


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
        time.sleep(.5)
        (readable, writable, excetpional) = select.select(
            read_sockets, write_sockets, read_sockets)
        # print("\n\nRunning while")
        # print(read_sockets)
        # print("READABLE IS: ", readable)
        # print("WRITABLE IS: ", writable)
        # print("EXCEPTIONAL IS: ", excetpional)
        for s in readable:
            if s == lsock:
                accept_wrapper(s)
            else:
                data = s.recv(1024)
                if data:
                    print("DATA IS: ", data)

        for s in writable:
            s.send("hello".encode())

except KeyboardInterrupt:
    print("caught keyboard interrupt, exiting")
finally:
    sel.close()
