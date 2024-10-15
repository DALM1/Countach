local ChatRoom = {}
ChatRoom.__index = ChatRoom

function ChatRoom.new(name, password, creator)
  local self = setmetatable({}, ChatRoom)
  self.name = name
  self.password = password
  self.clients = {}
  self.creator = creator
  self.history = {}
  return self
end

function ChatRoom:add_client(client, username)
  self.clients[username] = client
  self:broadcast_message(username .. " has joined the chat.", "Server")
end

function ChatRoom:remove_client(client, username)
  self.clients[username] = nil
  self:broadcast_message(username .. " has left the chat.", "Server")
end

function ChatRoom:broadcast_message(message, sender)
  local timestamp = os.date('%Y-%m-%d %H:%M:%S')
  local formatted_message = timestamp .. " " .. sender .. ": " .. message
  table.insert(self.history, formatted_message)

  for _, client in pairs(self.clients) do
    client:send(formatted_message .. "\n")
  end
end

function ChatRoom:list_users()
  local usernames = {}
  for username, _ in pairs(self.clients) do
    table.insert(usernames, username)
  end
  return table.concat(usernames, ", ")
end

return ChatRoom
