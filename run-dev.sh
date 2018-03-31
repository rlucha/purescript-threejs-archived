npm run start:dev:js &
P1=$!
npm run start:dev:ps &
P2=$!
wait $P1 $P2
