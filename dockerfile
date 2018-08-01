from ubuntu

WORKDIR .

add build app
add Godot_v3.0.6-stable_linux_server.64 godot

WORKDIR app
EXPOSE 8910

CMD ["./../godot", "--main-pack", "simple_server.pck", "-s"]

# docker build -t simpleserver .
# docker ps -q | xargs docker inspect --format '{{ .Id }} - {{ .Name }} - {{ .NetworkSettings.IPAddress }}'
