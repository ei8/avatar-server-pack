start "" ngrok start -config ngrok.yml neurul idp-neurul d23-neurul
start "" traefik -c traefik.toml
start "" /d "c:\ei8\idp" docker-compose -f docker-compose.yml up
start "" /d "c:\ei8\avatars\prod\sample" docker-compose -f docker-compose.yml up
start "" /d "c:\ei8\d23" docker-compose -f docker-compose.yml up