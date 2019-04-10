#!/usr/bin/python

import sys
import socket
import selectors
import types
import threading

message = "Hello world!"


def start_connections(host, port, client_name):
    server_addr = (host, port)
    print("starting connection", client_name, "to", server_addr)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setblocking(False)
    sock.connect_ex(server_addr)
    return sock


def write(sock):
    sock.send("hello".encode())


def read(sock):
    print(sock.recv(1024))


if len(sys.argv) != 4:
    print("usage:", sys.argv[0], "<host> <port> <client_name>")
    sys.exit(1)

host, port, client_name = sys.argv[1:4]
sock = start_connections(host, int(port), client_name)


try:
    write_thread = threading.Thread(
        target=write, name="write_thread", args=(sock,))
    # read_thread = threading.Thread(
    #     target=read, name="read_thread", args=(sock,))

    write_thread.start()
    # read_thread.start()

    write_thread.join()
    # read_thread.join()

except KeyboardInterrupt:
    print("caught keyboard interrupt, exiting")
finally:
    print("Closing connection!")
    sock.close()
