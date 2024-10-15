FROM alpine:3.13

RUN apk add --no-cache lua5.3 luarocks build-base git

RUN luarocks install copas && luarocks install lua-websockets

CMD [ "lua" ]
