const form = document.getElementById("chat-form");
const messagesContainer = document.getElementById("messages");
const usernameInput = document.getElementById("username");
const roomInput = document.getElementById("room");

let socket;

form.addEventListener("submit", function (event) {
    event.preventDefault();

    const username = usernameInput.value;
    const room = roomInput.value;

    if (!socket || socket.readyState !== WebSocket.OPEN) {
        socket = new WebSocket("ws://localhost:8080/chat");

        socket.onopen = function () {
            console.log("Connexion WebSocket établie");
            socket.send(username + " a rejoint la room " + room);
        };

        socket.onmessage = function (event) {
            const messageElement = document.createElement("p");
            messageElement.textContent = event.data;
            messagesContainer.appendChild(messageElement);
        };

        socket.onerror = function (error) {
            console.error("Erreur WebSocket : ", error);
        };

        socket.onclose = function () {
            console.log("Connexion WebSocket fermée.");
        };
    } else {
        const message = document.getElementById("message").value;
        socket.send(username + ": " + message);
    }

    document.getElementById("message").value = "";
});
