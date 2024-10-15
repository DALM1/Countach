local ChatView = {}
ChatView.__index = ChatView

function ChatView.new()
  local self = setmetatable({}, ChatView)
  return self
end

function ChatView:welcome_message()
  print("Welcome to the Countach Chat Server!")
end

return ChatView
