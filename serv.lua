local socket = require("socket")

local server = assert(socket.bind("*", 8080))
local ip, port = server:getsockname()

print("Serveur HTTP Countach lancé sur " .. ip .. ":" .. port)

local function handleRequest(client)
    client:settimeout(10)

    local request, err = client:receive('*l')
    if not request then
        print("Erreur lors de la réception de la requête : ", err)
        client:close()
        return
    end

    print("Requête reçue : " .. request)

    local response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nBienvenue sur le serveur Countach"
    client:send(response)

    client:close()
end

while true do
    local client = server:accept()
    handleRequest(client)
end
