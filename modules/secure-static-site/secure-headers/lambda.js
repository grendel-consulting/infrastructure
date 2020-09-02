'use strict';

exports.handler = (event, context, callback) => {
  const response = event.Records[0].cf.response;
  const headers = response.headers;
  const nonce = Math.random();

  headers['strict-transport-security'] = [{key:'Strict-Transport-Security',value:'max-age=63072000; includeSubdomains; preload'}];
  headers['content-security-policy'] = [{key:'Content-Security-Policy',value:"default-src 'none'; frame-ancestors 'none'; img-src 'self'; script-src 'strict-dynamic' 'nonce-" + nonce + "' 'unsafe-inline http: https:;  style-src 'self'; object-src 'none'; base-uri 'none'; form-action 'self'"}];
  headers['feature-policy'] = [{key:'Feature-Policy',value:"geolocation 'none';midi 'none';notifications 'none';push 'none';sync-xhr 'none';microphone 'none';camera 'none';magnetometer 'none';gyroscope 'none';speaker 'none';vibrate 'none';fullscreen 'none';payment 'none';"}];
  headers['expect-ct'] = [{key:'Expect-CT',value:"max-age=86400"}];
  headers['x-content-type-options'] = [{key:'X-Content-Type-Options',value:'nosniff'}];
  headers['x-frame-options'] = [{key:'X-Frame-Options',value:'DENY'}];
  headers['x-xss-protection'] = [{key:'X-XSS-Protection',value:'1; mode=block'}];
  headers['referrer-policy'] = [{key:'Referrer-Policy',value:'same-origin'}];
  headers['server'] = [{key:'Server',value:'Generic Web Server'}];

  callback(null, response);
};