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

sockets_data = {}
groups = {}


def accept_wrapper(sock):
    conn, addr = sock.accept()  # Should be ready to read
    conn.setblocking(False)
    data = types.SimpleNamespace(addr=addr, inb=b"", outb=b"")
    events = selectors.EVENT_READ | selectors.EVENT_WRITE

    read_sockets.append(conn)
    write_sockets.append(conn)
    sockets_data[conn] = {"name": None, "groups": []}

    sel.register(conn, events, data=data)


def set_socket_name(sock, name):
    sockets_data[s]["name"] = name


def get_or_make_group(group_name):
    group = groups.get(group_name, None)
    if group is None:
        groups[group_name] = {"members": [], "message": None}
        group = groups[group_name]
    return group


def join_group(group_name, sock):
    group = get_or_make_group(group_name)
    if sock in group['members']:
        raise ValueError("This member is already joined to {group_name} group.".format(
            group_name=group_name))
    else:
        group['members'].append(sock)


def leave_group(group_name, sock):
    group = groups.get(group_name, None)
    if group is None:
        raise ValueError(
            "Group {group_name} is not available.".format(group_name=group_name))
    try:
        member_index = group['members'].index(sock)
    except ValueError:
        raise ValueError(
            "This user is not a member of {group_name} group.".format(
                group_name=group_name)
        )
    del(group['members'][member_index])


def check_user_permission(group_name, sock):
    group = groups.get(group_name, None)
    if group is None:
        raise ValueError(
            "Group {group_name} is not available.".format(group_name=group_name))

    try:
        member_index = group['members'].index(sock)
    except ValueError:
        raise ValueError(
            "This user is not a member of {group_name} group.".format(
                group_name=group_name)
        )


def send_group_message(group_name, group_message):
    group = groups.get(group_name, None)
    if group is None:
        raise ValueError(
            "Group {group_name} is not available.".format(
                group_name=group_name)
        )
    group['message'] = group_message


def get_unsend_groups():
    unsend_groups = []
    for key in groups.keys():
        value = groups[key]
        if value['message'] is not None:
            unsend_groups.append(value)
    return unsend_groups


def make_list_string(li):
    temp_str = ""
    for item in li:
        temp_str += item + " "
    return temp_str


def remove_from_groups(sock):
    for key in groups.keys():
        value = groups[key]
        if s in value['members']:
            value['members'].remove(sock)


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
        (readable, nothing, excetpional) = select.select(
            read_sockets, [], read_sockets)
        # Readable sockets
        for s in readable:
            if s == lsock:
                accept_wrapper(s)
            else:
                data = s.recv(1024).decode()

                if data.split(" ")[0] == "-SetName-":
                    set_socket_name(s, data.split(' ')[1])
                    print("{user_name} connected to server.".format(
                        user_name=data.split(' ')[1]))

                elif data.split(" ")[0] == "join":
                    user_name = sockets_data[s]['name']
                    group_name = data.split(' ')[1]
                    try:
                        join_group(data.split(' ')[1], s)
                        send_group_message(data.split(' ')[1],
                                           "{user_name} joined {group_name} group.".format(user_name=user_name, group_name=group_name))
                    except ValueError as err:
                        s.send(str(err).encode())

                elif data.split(" ")[0] == "leave":
                    user_name = sockets_data[s]['name']
                    group_name = data.split(' ')[1]
                    try:
                        leave_group(data.split(' ')[1], s)
                        send_group_message(data.split(' ')[1],
                                           "{user_name} left {group_name} group.".format(user_name=user_name, group_name=group_name))
                    except ValueError as err:
                        s.send(str(err).encode())

                elif data.split(' ')[0] == 'quit':
                    user_name = sockets_data[s]['name']
                    s.send("-quit-".encode())
                    time.sleep(0.01)
                    remove_from_groups(s)
                    read_sockets.remove(s)
                    write_sockets.remove(s)
                    s.close()
                    print("{user_name} left the server.".format(
                        user_name=user_name))

                elif data.split(' ')[0] == "send":
                    group_name = data.split(' ')[1]
                    user_name = sockets_data[s]['name']
                    try:
                        goup_name = data.split(' ')[1]
                        check_user_permission(group_name, s)

                        group_message = data.split(' ')[2:]
                        group_message_string = "[gp: {group_name}]-{user_name}: ".format(
                            group_name=group_name, user_name=user_name) + make_list_string(group_message)
                        send_group_message(group_name, group_message_string)

                    except ValueError as err:
                        s.send(str(err).encode())

                    message = sockets_data[s]["name"] + " says: " + data
                    group_message = message

        (nothing, writable, excetpional) = select.select(
            [], write_sockets, read_sockets)
        # Writable sockets
        if writable != []:
            unsend_groups = get_unsend_groups()
            for group in unsend_groups:
                members = group['members']
                for member in members:
                    if member in writable:
                        member.send(group['message'].encode())
                group['message'] = None


except KeyboardInterrupt:
    print("caught keyboard interrupt, exiting")
    sel.close()
