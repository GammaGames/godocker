from ubuntu

WORKDIR .

ADD build app

# RUN apt-get update && apt-get install -y libx11-dev libxcursor-dev libxinerama-dev \
#     libgl1-mesa-dev libglu-dev libasound2-dev libpulse-dev libfreetype6-dev libssl-dev libudev-dev \
#     libxi-dev libxrandr-dev

EXPOSE 8910

CMD ["./app/server.x86_64"]
