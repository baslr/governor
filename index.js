// Generated by CoffeeScript 1.6.3
(function() {
  var check, cookies, http, i, ipAddresses, j, m, n, os, server, url, zlib, _i, _len, _ref;

  cookies = {
    'www.heise.de': 0
  };

  http = require('http');

  url = require('url');

  zlib = require('zlib');

  check = require('./check');

  os = require('os');

  ipAddresses = [];

  _ref = os.networkInterfaces();
  for (i in _ref) {
    n = _ref[i];
    for (j = _i = 0, _len = n.length; _i < _len; j = ++_i) {
      m = n[j];
      if (m.family === 'IPv4' && m.internal === false && m.address !== '127.0.0.1') {
        ipAddresses.push(m.address);
      }
    }
  }

  console.log(ipAddresses);

  server = http.createServer();

  server.listen(12100, '0.0.0.0');

  server.on('error', function(e) {
    console.error("http:server:e");
    return console.dir(e);
  });

  server.on('request', function(req, res) {
    var urlObj;
    req.on('error', function(e) {
      console.error('http:server:request:req:e');
      return console.dir(e);
    });
    res.on('error', function(e) {
      console.error('http:server:request:res:e');
      return console.dir(e);
    });
    urlObj = url.parse(req.url);
    delete req.headers['cookie'];
    delete req.headers['proxy-connection'];
    console.dir(req.headers);
    console.dir(req.url);
    if ('post' === req.method.toLowerCase()) {
      console.log("\x1b[31mPOST: " + urlObj.hostname + " " + urlObj.path + "\x1b[0m");
      res.end();
      return;
    }
    if (!check(urlObj)) {
      console.log("\x1b[31mBLOCKED -> " + urlObj.href + "\x1b[0m");
      res.statusCode = 500;
      res.end();
      return;
    }
    console.dir('- - - - - - - - - - - - - - - - - - - - - - - - - - -');
    req.on('readable', function() {
      return this.read();
    });
    return req.on('end', function() {
      var reqReq;
      reqReq = http.request({
        localAddress: ipAddresses[0],
        hostname: urlObj.hostname,
        path: urlObj.path,
        headers: req.headers
      }, function(reqRes) {
        var data, _ref1;
        console.log("req for: " + req.url);
        res.statusCode = reqRes.statusCode;
        console.dir(reqRes.headers);
        _ref1 = reqRes.headers;
        for (i in _ref1) {
          n = _ref1[i];
          res.setHeader(i, n);
        }
        if (urlObj.hostname === 'mobil.zeit.de' && (reqRes.headers['content-encoding'] != null) && reqRes.headers['content-encoding'] === 'gzip') {
          data = new Buffer(0);
          reqRes.on('readable', function() {
            return data = Buffer.concat([data, this.read()]);
          });
        } else {
          reqRes.pipe(res);
        }
        return reqRes.on('end', function() {
          console.log("RESPONSE FULL DONE FOR " + urlObj.hostname + " " + urlObj.path);
          if (urlObj.hostname === 'mobil.zeit.de' && (reqRes.headers['content-encoding'] != null) && reqRes.headers['content-encoding'] === 'gzip') {
            return zlib.unzip(data, function(e, result) {
              data = result.toString().replace("return (document.cookie.indexOf('facdone')!=-1)? true : false;", 'return false;');
              return zlib.gzip(data, function(e, result) {
                return res.end(result);
              });
            });
          }
        });
      });
      reqReq.end();
      return reqReq.on('error', function(e) {
        console.error('http.request:e');
        return console.dir(e);
      });
    });
  });

}).call(this);
