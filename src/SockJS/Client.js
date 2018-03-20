"use strict";

const SockJS = require('sockjs-client');

exports.connect_ = function (url) {
  // TODO: support options
  return new SockJS(url);
}

// Event handlers
exports.onOpen_ = function(sock, handler) {
  sock.onopen = handler;
}
exports.onMessage_ = function(sock, handler) {
  sock.onmessage = function(e) {
    handler(e.data);
  };
}
exports.onClose_ = function(sock, handler) {
  sock.onclose = handler;
}

// Connection methods
exports.send_ = function(sock, message) {
  sock.send(message);
}
exports.close_ = function(sock) {
  sock.close();
}
