#!/usr/bin/python

import sys
import socket
import selectors
import types

sel = selectors.DefaultSelector()
messages = [b"Message 1 from client.",
            b"Message 2 from client.", b"Message 3 from client."]
message = "Hello world!"

def start_connections(host, port, client_name):
    server_addr = (host, port)
    print("starting connection", client_name, "to", server_addr)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setblocking(False)
    sock.connect_ex(server_addr)
    events = selectors.EVENT_READ | selectors.EVENT_WRITE
    data = types.SimpleNamespace(
        client_name=client_name,
        recv_total=0,
        message = message,
        message_len = len(message),
        outb=b"",
    )
    sel.register(sock, events, data=data)


def service_connection(key, mask):
    sock = key.fileobj
    data = key.data
    
    if mask & selectors.EVENT_READ:
        recv_data = sock.recv(1024)  # Should be ready to read
        if recv_data:
            print("received", repr(recv_data), "from connection", data.client_name)
            data.recv_total += len(recv_data)
        if not recv_data or data.recv_total == data.message_len:
            print("closing connection", data.client_name)
            sel.unregister(sock)
            sock.close()

    if mask & selectors.EVENT_WRITE:
        if not data.outb and data.message:
            data.outb = message.encode()
        if data.outb:
            print("sending", repr(data.outb), "to connection", data.client_name)
            sent = sock.send(data.outb)  # Should be ready to write
            data.outb = data.outb[sent:]


if len(sys.argv) != 4:
    print("usage:", sys.argv[0], "<host> <port> <client_name>")
    sys.exit(1)

host, port, client_name = sys.argv[1:4]
start_connections(host, int(port), client_name)

try:
    while True:
        events = sel.select(timeout=1)
        if events:
            for key, mask in events:
                service_connection(key, mask)
        # Check for a socket being monitored to continue.
        if not sel.get_map():
            break
except KeyboardInterrupt:
    print("caught keyboard interrupt, exiting")
finally:
    sel.close()
