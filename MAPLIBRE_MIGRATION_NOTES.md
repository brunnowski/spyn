# 🗺️ Migração Leaflet → Maplibre GL - SPYN

## Status: Bibliotecas atualizadas ✅

As bibliotecas CDN já foram trocadas:
- ✅ Maplibre GL CSS carregado
- ✅ Maplibre GL JS carregado

## Diferenças Principais da API

### 1. Coordenadas
```javascript
// Leaflet: [lat, lng]
L.marker([40.7128, -74.0060])

// Maplibre: [lng, lat] ⚠️ INVERTIDO
new maplibregl.Marker().setLngLat([-74.0060, 40.7128])
```

### 2. Inicialização do Mapa
```javascript
// Leaflet
map = L.map('map').setView([lat, lng], zoom);
L.tileLayer('url').addTo(map);

// Maplibre ✅ JÁ IMPLEMENTADO
map = new maplibregl.Map({
  container: 'map',
  style: 'https://demotiles.maplibre.org/style.json',
  center: [lng, lat],
  zoom: zoom
});
```

### 3. Marcadores
```javascript
// Leaflet
const marker = L.marker([lat, lng]).addTo(map);
marker.bindPopup('content');

// Maplibre - PRECISA IMPLEMENTAR
const el = document.createElement('div');
el.className = 'custom-marker';
el.innerHTML = iconHtml;
const marker = new maplibregl.Marker(el)
  .setLngLat([lng, lat])
  .setPopup(new maplibregl.Popup().setHTML('content'))
  .addTo(map);
map.markers.push(marker); // Para remoção posterior
```

### 4. Linhas/Rotas
```javascript
// Leaflet
const polyline = L.polyline(latlngs, {color: 'blue'}).addTo(map);
map.fitBounds(polyline.getBounds());

// Maplibre - PRECISA IMPLEMENTAR
map.addSource('route', {
  type: 'geojson',
  data: {
    type: 'Feature',
    geometry: {
      type: 'LineString',
      coordinates: lnglats // [lng, lat][]
    }
  }
});

map.addLayer({
  id: 'route',
  type: 'line',
  source: 'route',
  paint: {
    'line-color': '#0000FF',
    'line-width': 5,
    'line-opacity': 0.8
  }
});

// Fit bounds
const bounds = new maplibregl.LngLatBounds();
lnglats.forEach(coord => bounds.extend(coord));
map.fitBounds(bounds, {padding: 50});
```

### 5. Mini Mapas
```javascript
// Leaflet
const miniMap = L.map(element, {
  dragging: false,
  scrollWheelZoom: false
}).setView([lat, lng], 12);

// Maplibre - PRECISA IMPLEMENTAR
const miniMap = new maplibregl.Map({
  container: element,
  style: 'https://demotiles.maplibre.org/style.json',
  center: [lng, lat],
  zoom: 12,
  interactive: false // Desabilita interação
});
```

### 6. Limpar Camadas
```javascript
// Leaflet
map.eachLayer(layer => {
  if (layer instanceof L.Marker) map.removeLayer(layer);
});

// Maplibre - ✅ JÁ IMPLEMENTADO
map.markers.forEach(marker => marker.remove());
map.markers = [];
if (map.getLayer('route')) map.removeLayer('route');
if (map.getSource('route')) map.removeSource('route');
```

### 7. Resize
```javascript
// Leaflet
map.invalidateSize();

// Maplibre - ✅ JÁ IMPLEMENTADO
map.resize();
```

### 8. Eventos
```javascript
// Leaflet
map.on('click', function(e) {
  console.log(e.latlng);
});

// Maplibre
map.on('click', function(e) {
  console.log(e.lngLat); // { lng, lat }
});
```

## Funções que Precisam Conversão

### 🔴 Alta Prioridade
1. `displayRoute()` - linhas 2139+
   - Converter markers de Leaflet para Maplibre
   - Converter polylines para GeoJSON layers
   - Inverter coordenadas [lat,lng] → [lng,lat]

2. `createMiniMap()` - linhas 2398+
   - Converter mini mapas
   - Desabilitar interação corretamente

3. `closeRouteView()` - linhas 2494+
   - Atualizar limpeza de camadas
   - Usar `map.setCenter()` e `map.setZoom()`

### 🟡 Média Prioridade
4. `getOSRMRoute()` - linhas 2228+
   - Já retorna GeoJSON, só precisa inverter coords

### 🟢 Baixa Prioridade
5. Estilos CSS - Markers customizados funcionam igual

## Estilo Customizado (Opcional)

Para tema brutalist preto/branco/amarelo:

```javascript
const brutalStyle = {
  version: 8,
  sources: {
    osm: {
      type: 'raster',
      tiles: ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
      tileSize: 256
    }
  },
  layers: [{
    id: 'osm',
    type: 'raster',
    source: 'osm'
  }]
};

map = new maplibregl.Map({
  style: brutalStyle,
  // ... resto
});
```

## Próximos Passos

1. ✅ Trocar CDN links
2. ✅ Atualizar initMap()
3. ✅ Atualizar showPage() resize
4. ✅ Atualizar closeRouteView() clear
5. 🔴 **FAZER AGORA**: Converter displayRoute()
6. 🔴 **FAZER AGORA**: Converter createMiniMap()
7. 🟡 Testar rotas OSRM
8. 🟢 Customizar estilo (opcional)

## Vantagens do Maplibre

✅ Zoom vetorial suave (sem "jumps")
✅ Rotação e inclinação 3D
✅ Performance GPU
✅ Animações fluidas
✅ 100% gratuito
✅ Tipografia melhor
✅ Estilo JSON customizável

## Teste Rápido

Abra o console e teste:
```javascript
console.log(map); // Deve ser maplibregl.Map
console.log(maplibregl.version); // ~4.0.0
```
