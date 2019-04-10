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
    sock.connect(server_addr)
    return sock


def service_connection(key, mask):
    sock = key.fileobj
    data = key.data

    if mask & selectors.EVENT_READ:
        print("READ EVENT")
        recv_data = sock.recv(1024)  # Should be ready to read
        if recv_data:
            print("received", repr(recv_data),
                  "from connection", data.client_name)
            data.recv_total += len(recv_data)
        if not recv_data or data.recv_total == data.message_len:
            print("closing connection", data.client_name)
            sel.unregister(sock)
            sock.close()

    if mask & selectors.EVENT_WRITE:
        print("\nWRITE EVENT")
        print(sock)
        if not data.outb and data.message:
            data.outb = message.encode()
        if data.outb:
            print("sending", repr(data.outb),
                  "to connection", data.client_name)
            sent = sock.send(data.outb)  # Should be ready to write
            data.outb = data.outb[sent:]


def write(sock):
    pass


def read(sock):
    pass


if len(sys.argv) != 4:
    print("usage:", sys.argv[0], "<host> <port> <client_name>")
    sys.exit(1)

host, port, client_name = sys.argv[1:4]
sock = start_connections(host, int(port), client_name)


try:
    write_thread = threading.Thread(
        target=write(), name="write_thread", args=(sock))
    read_thread = threading.Thread(
        target=read(), name="read_thread", args=(sock))

    write_thread.start()
    read_thread.start()

    write_thread.join()
    read_thread.join()

except KeyboardInterrupt:
    print("caught keyboard interrupt, exiting")
finally:
    sel.close()
