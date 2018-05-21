const rlite = require('rlite-router')

const circleStuff = require('./output/Projects.CircleStuff.Main')
const seaLike = require('./output/Projects.Sealike.Main')

const route = rlite(notFound, {
  '': function () {
    circleStuff.main()
  },
  '01': function () {
    document.body.className = 'theme01'
    circleStuff.main()
  },
  '02': function () {
    document.body.className = 'theme02'
    seaLike.main()
  },

});

function notFound() {
  document.body.className = 'theme01'
  circleStuff.main()
}

// Hash-based routing
function processHash() {
  const hash = location.hash || '#';
  route(hash.slice(2))
}

window.go = () => {
  window.location.reload(false);
}

window.addEventListener('hashchange', processHash);
processHash();
