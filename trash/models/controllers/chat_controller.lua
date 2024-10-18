local ChatRoom = require "models.chat_room"
local ChatController = {}
ChatController.__index = ChatController

function ChatController.new()
  local self = setmetatable({}, ChatController)
  self.chat_rooms = {}
  return self
end

function ChatController:create_room(name, password, creator)
  local room = ChatRoom.new(name, password, creator)
  self.chat_rooms[name] = room
end

function ChatController:chat_loop(client, chat_room, username)
  client:send("Welcome, " .. username .. "!\n")
  while true do
    local message, err = client:receive()
    if not message or err then
      print("Error receiving message: ", err)
      break
    end

    if message == "/quit" then
      break
    elseif message == "/list" then
      self:list_users(chat_room, client)
    elseif message == "/history" then
      self:show_history(chat_room, client)
    else
      print("Message from " .. username .. ": " .. message)
      chat_room:broadcast_message(message, username)
    end
  end
  chat_room:remove_client(client, username)
end

function ChatController:list_users(chat_room, client)
  client:send("Users in this room: " .. chat_room:list_users() .. "\n")
end

function ChatController:show_history(chat_room, client)
  client:send("Chat history:\n")
  for _, msg in ipairs(chat_room.history) do
    client:send(msg .. "\n")
  end
end

return ChatController
