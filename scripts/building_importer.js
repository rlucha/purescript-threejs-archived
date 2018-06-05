var fs = require('fs');
var buildings = require("./se228np_1km.json")
var results = JSON.stringify(buildings.map (b=> ({coordinates: JSON.parse(b.points).map(p => ({x: p[0], y: 0.0, z: p[1]}))})))

fs.writeFile("./buildings_se228np_1km.json", results , function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("The file was saved!");
}); 
