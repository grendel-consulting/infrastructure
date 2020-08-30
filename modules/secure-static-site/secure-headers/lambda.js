'use strict';

exports.handler = (event, context, callback) => {
  const response = event.Records[0].cf.response;
  const headers = response.headers;
  const nonce = Math.random();

  headers['strict-transport-security'] = [{key:'Strict-Transport-Security',value:'max-age=63072000; includeSubdomains; preload'}];
  headers['content-security-policy'] = [{key:'Content-Security-Policy',value:"default-src 'none'; frame-ancestors 'none'; img-src 'self'; script-src 'strict-dynamic' 'nonce-" + nonce + "' 'unsafe-inline http: https:;  style-src 'self'; object-src 'none'; base-uri 'none'; form-action 'self'"}];
  headers['x-content-type-options'] = [{key:'X-Content-Type-Options',value:'nosniff'}];
  headers['x-frame-options'] = [{key:'X-Frame-Options',value:'DENY'}];
  headers['x-xss-protection'] = [{key:'X-XSS-Protection',value:'1; mode=block'}];
  headers['referrer-policy'] = [{key:'Referrer-Policy',value:'same-origin'}];

  callback(null, response);
};