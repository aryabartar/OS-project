import socket 
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    server = 'pythonprogramming.net'
    port = 80

    server_ip = socket.gethostbyname(server)

    request = "GET / HTTP/1.1\nHost: {}\n\n".format(server)
    
    s.connect((server,port))
    s.send(request.encode())
    result = s.recv(1024)
    
    while len(result) > 0 :
        print (result)
        result = s.recv(1024)