npm run start:dev:js &
P1=$!
npm run start:dev:ps &
P2=$!
http-server -c1 &
P3=$!
wait $P1 $P2 $P3
