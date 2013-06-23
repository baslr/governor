// Generated by CoffeeScript 1.6.3
(function() {
  var cache, dir, file, files, fs, parts, qL, _i, _j, _len, _len1, _ref;

  fs = require('fs');

  _ref = fs.readdirSync('lfCache');
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    dir = _ref[_i];
    if (fs.statSync("lfCache/" + dir).isDirectory()) {
      files = fs.readdirSync("lfCache/" + dir);
      cache = {
        audio: {},
        video: {}
      };
      for (_j = 0, _len1 = files.length; _j < _len1; _j++) {
        file = files[_j];
        parts = file.split('-');
        if (parts[4] != null) {
          if (cache[parts[4]][parts[3]] != null) {
            qL = cache[parts[4]][parts[3]].qL;
            if (Number(qL) < Number(parts[5])) {
              console.log("" + qL + " < " + parts[5]);
              cache[parts[4]][parts[3]] = {
                file: file,
                qL: parts[5]
              };
              console.log("replace type " + parts[4] + " fragment " + parts[3] + " qL " + qL + " with qL " + parts[5]);
            } else {
              console.log("! " + qL + " < " + parts[5] + " delete the file");
              fs.unlinkSync("lfCache/" + dir + "/" + file);
            }
          } else {
            cache[parts[4]][parts[3]] = {
              file: file,
              qL: parts[5]
            };
          }
        }
      }
      fs.writeFileSync("lfCache/" + dir + "/cached.json", JSON.stringify(cache));
    }
  }

  /*
  
    0     1  2  3           4     5
  123456-de-SD-1234567890-audio-12345
  
  
  {audio:{fragment:{file:'file', quality:12345},fragment:{}},
   video:{fragment:{file:'file', quality:12345},fragment:{}}
  }
  */


}).call(this);
