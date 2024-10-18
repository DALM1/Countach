package.path = package.path .. ";/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua"
package.cpath = package.cpath .. ";/opt/homebrew/lib/lua/5.4/?.so"

local status, copas = pcall(require, "copas")
if not status then
    error("Erreur lors du chargement de copas: " .. tostring(copas))
end

local status_ws, ws_server = pcall(require, "websocket.server.copas")
if not status_ws then
    error("Erreur lors du chargement de websocket: " .. tostring(ws_server))
end

local server = ws_server.listen({
    port = 8080,
    protocols = {
        chat = function(ws)
            print("Client connecté via WebSocket")

            while true do
                local message = ws:receive()
                if message then
                    print("Message reçu " .. message)
                    ws:send("Serveur " .. message)
                else
                    break
                end
            end

            print("Client déconnecté")
        end
    }
})

copas.loop()
