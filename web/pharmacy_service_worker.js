const CACHE_NAME = 'pharmacy-offline-v1';
const PRECACHE_URLS = [
  './',
  'index.html',
  'favicon.png',
  'icons/Icon-192.png',
  'icons/Icon-maskable-192.png',
  'icons/Icon-512.png',
  'icons/Icon-maskable-512.png',
  'manifest.json',
  'flutter_bootstrap.js',
  'main.dart.js',
  'main.dart.wasm',
  'sql-wasm.js',
  'sql-wasm.wasm',
  'drift_worker.js',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(PRECACHE_URLS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;

  event.respondWith(
    caches.match(request).then((cached) => {
      const fetchPromise = fetch(request).then((response) => {
        if (response && response.status === 200) {
          const clone = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(request, clone));
        }
        return response;
      }).catch(() => cached);

      return cached || fetchPromise;
    })
  );
});
