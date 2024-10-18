local socket = require("socket")
local client = assert(socket.connect("127.0.0.1", 3630))

function send_data(prompt)
    io.write(prompt)
    local input = io.read()
    client:send(input .. "\n")
end

send_data("Enter the room name you want to join or create (or /quit to exit) ")
send_data("Enter a password for the room (or press enter to skip) ")
send_data("Enter your username ")

while true do
    send_data("Message > ")
end

client:close()
