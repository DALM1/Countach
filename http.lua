local socket = require("socket")

local server = assert(socket.bind("*", 8080))
local ip, port = server:getsockname()

print("Serveur HTTP Countach lancé sur " .. ip .. ":" .. port)

local function readFile(filename)
    local file = io.open(filename, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

local function handleRequest(client)
    client:settimeout(10)

    local request, err = client:receive('*l')
    if not request then
        print("Erreur lors de la réception de la requête : ", err)
        client:close()
        return
    end

    print("Requête reçue : " .. request)

    local method, path = request:match("([A-Z]+) (.+) HTTP")

    if path == "/" then
        path = "/index.html"
    end

    local fileContent = readFile("." .. path)

    local response
    if fileContent then
        response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n" .. fileContent
    else
        response = "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\nFichier non trouvé"
    end

    client:send(response)
    client:close()
end

while true do
    local client = server:accept()
    handleRequest(client)
end
