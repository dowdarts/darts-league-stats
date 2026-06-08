const http = require('http');
const fs = require('fs');
const path = require('path');

const root = __dirname;
const port = Number(process.env.PORT || 8000);
const host = '127.0.0.1';
const contentTypes = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml'
};

http.createServer((request, response) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Cache-Control': 'no-store'
  };

  if (request.method === 'OPTIONS') {
    response.writeHead(204, headers);
    response.end();
    return;
  }

  const requestPath = decodeURIComponent(request.url.split('?')[0]);
  const relativePath = requestPath === '/' ? '/display.html' : requestPath;
  const filePath = path.normalize(path.join(root, relativePath));

  if (!filePath.startsWith(root)) {
    response.writeHead(403, headers);
    response.end('Forbidden');
    return;
  }

  fs.readFile(filePath, (error, data) => {
    if (error) {
      response.writeHead(404, headers);
      response.end('Not found');
      return;
    }

    const contentType = contentTypes[path.extname(filePath).toLowerCase()] || 'application/octet-stream';
    response.writeHead(200, { ...headers, 'Content-Type': contentType });
    response.end(data);
  });
}).listen(port, host, () => {
  console.log(`Serving ${root} at http://${host}:${port}/display.html`);
});
