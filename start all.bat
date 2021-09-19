start "" ngrok start -config ngrok.yml --all
start "" traefik -c traefik.toml
start "" /d "c:\ei8\avatars\prod\sample" docker-compose -f docker-compose.yml up