
cat << EOF
 _________________________________________
/ pruning docker images by removing...    \
|  - all stopped containers               |
|  - all networks not used by at least    |
|    one container                        |
|  - all dangling images                  |
|  - all build cache                      |
\                                         /
 -----------------------------------------
    \
     \
      \
                       ##         .
                 ## ## ##        ==
              ## ## ## ## ##    ===
          /""""""""""""""""""\___/ ===
    ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
          \______ o           __/
            \    \         __/
             \____\_______/
EOF

docker system prune -f

docker-compose up --build

docker-compose push