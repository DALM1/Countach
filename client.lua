local socket = require("socket")

local server_ip = "127.0.0.1"
local server_port = 3630

local client = socket.connect(server_ip, server_port)

local function receive_messages()
    while true do
        local message, err = client:receive()
        if not err then
            print(message)
        else
            break
        end
    end
end

local function send_message()
    while true do
        local input = io.read()
        client:send(input .. "\n")
    end
end

local co_receive = coroutine.create(receive_messages)
local co_send = coroutine.create(send_message)

coroutine.resume(co_receive)
coroutine.resume(co_send)
