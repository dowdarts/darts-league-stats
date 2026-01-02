// Service Worker for AADS Stats - Aggressive caching for performance
const CACHE_NAME = 'aads-stats-v1';
const CACHE_URLS = [
    '/darts-league-stats/',
    '/darts-league-stats/display.html',
    '/darts-league-stats/Logos/AADS OFFIAL LOGO - Copy.png',
    '/darts-league-stats/Logos/AADSDarts.com Logo.png',
    '/darts-league-stats/Logos/cgcdarts.com logo - Copy.png',
    '/darts-league-stats/Logos/CGCVENUE LOGO.png',
    '/darts-league-stats/Logos/CGC-TV Logo - Copy.png',
    '/darts-league-stats/Logos/LIVE STREAM CGC LOGO - Copy.png',
    '/darts-league-stats/Logos/MDSTUDIOS - Copy.png'
];

// Install event - cache static assets
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('Service Worker: Caching static assets');
            return cache.addAll(CACHE_URLS).catch(err => {
                console.warn('Service Worker: Some assets failed to cache', err);
            });
        })
    );
    self.skipWaiting();
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        console.log('Service Worker: Clearing old cache', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
    self.clients.claim();
});

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', (event) => {
    const url = new URL(event.request.url);
    
    // Cache strategy for different resource types
    if (url.pathname.endsWith('.png') || url.pathname.endsWith('.jpg') || url.pathname.endsWith('.jpeg')) {
        // Images: Cache first, network fallback (they rarely change)
        event.respondWith(
            caches.match(event.request).then((response) => {
                if (response) {
                    return response;
                }
                return fetch(event.request).then((response) => {
                    if (response.status === 200) {
                        const responseClone = response.clone();
                        caches.open(CACHE_NAME).then((cache) => {
                            cache.put(event.request, responseClone);
                        });
                    }
                    return response;
                });
            })
        );
    } else if (url.pathname.endsWith('.json')) {
        // JSON: Network first, cache fallback (data changes frequently)
        event.respondWith(
            fetch(event.request)
                .then((response) => {
                    if (response.status === 200) {
                        const responseClone = response.clone();
                        caches.open(CACHE_NAME).then((cache) => {
                            cache.put(event.request, responseClone);
                        });
                    }
                    return response;
                })
                .catch(() => {
                    return caches.match(event.request);
                })
        );
    } else {
        // Everything else: Cache first for speed
        event.respondWith(
            caches.match(event.request).then((response) => {
                return response || fetch(event.request);
            })
        );
    }
});
