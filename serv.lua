
package.path = package.path .. ";/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua"
package.cpath = package.cpath .. ";/opt/homebrew/lib/lua/5.4/?.so"
local socket = require "socket"
local ChatController = require "controllers.chat_controller"

local server_ip = "0.0.0.0"
local server_port = 3630
local server = assert(socket.bind(server_ip, server_port))

local chat_controller = ChatController.new()

print(string.rep("-", 50))
print("Welcome to Countach Chat Server")
print("Server listening on port " .. server_port)
print(string.rep("-", 50))

function handle_room_selection(client)
  client:send("Enter the room name you want to join or create (or /quit to exit):\n")
  local room_name = client:receive()
  if room_name == "/quit" then return end

  client:send("Enter a password for the room (or press enter to skip):\n")
  local password = client:receive()

  client:send("Enter your username:\n")
  local username = client:receive()

  if chat_controller.chat_rooms[room_name] then
    local room = chat_controller.chat_rooms[room_name]
    if room.password == password then
      room:add_client(client, username)
      chat_controller:chat_loop(client, room, username)
    else
      client:send("Incorrect password. Try again.\n")
    end
  else
    chat_controller:create_room(room_name, password, username)
    chat_controller.chat_rooms[room_name]:add_client(client, username)
    chat_controller:chat_loop(client, chat_controller.chat_rooms[room_name], username)
  end
end

-- Boucle principale du serveur
while true do
  local client = server:accept()
  client:settimeout(0)

  -- Thread pour gérer chaque client
  local co = coroutine.create(function()
    handle_room_selection(client)
    client:close()
  end)
  coroutine.resume(co)
end
