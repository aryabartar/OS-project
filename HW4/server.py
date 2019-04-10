import socket
import sys

def create_socket():
    try:
        global host
        global port
        global s
        host = ''
        port = 9996
        s = socket.socket()
    except socket.error as msg:
        print("Error while creating server socket! | ", msg )

def socket_bind():
    try:
        global host
        global port 
        global s
        s.bind((host , port))
        s.listen(5)
    except socket.error as msg:
        print ("Socket binding error | " , msg)
        socket_bind()

def socket_accept():
    global s
    conn, address = s.accept()
    print("Connected to a client | " , " IP: " , address[0] , " Port:" , address[1])
    send_commands(conn)
    conn.close()

def send_commands(conn):
    while True:
        cmd = input()
        if cmd == 'quit':
            conn.close()
            s.close()
            sys.exit()
            
        if len(str.encode(cmd)) > 0:
            print("Server sending.")
            conn.send(str.encode(cmd))
            print("Server recieveing.")
            print(str(conn.recv(1024)))

def main():
    try:
        create_socket()
        socket_bind()
        socket_accept()
    except:
        global s
        s.close()

main()