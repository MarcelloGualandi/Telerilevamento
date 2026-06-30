great green wall 2007
/ ==============================================
// Landsat 5 TM Surface Reflectance - Cloud Masking and Visualization
// ==============================================

// ==============================================
// Function to mask clouds using the pixel_qa band
// ==============================================
  // ==============================================
// AOI Great Green Wall - Senegal (Louga / Linguère)
// ==============================================
var aoi = ee.Geometry.Rectangle([
  -14.70, 15.30,   // Ovest, Sud
  -14.10, 15.60    // Est, Nord
]);

function maskL5clouds(image) {
  var qa = image.select('QA_PIXEL');

  // Bitmask per cloud e cloud shadow (Collection 2)
  var cloud = qa.bitwiseAnd(1 << 5).eq(0);       // Cloud
  var shadow = qa.bitwiseAnd(1 << 3).eq(0);      // Cloud shadow

  var mask = cloud.and(shadow);

  return image.updateMask(mask).divide(10000);
}


// ==============================================
// Load and Prepare the Image Collection (2007)
// ==============================================
var collection = ee.ImageCollection('LANDSAT/LT05/C02/T1_L2')
                   .filterBounds(aoi)
                   .filterDate('2007-01-01', '2007-12-31')
                   .map(maskL5clouds);

print('Number of images in collection (2007):', collection.size());

// ==============================================
// Create a median composite
// ==============================================
var composite = collection.median().clip(aoi);

// ==============================================
// Visualization on the Map
// Landsat 5 RGB = B3 (Red), B2 (Green), B1 (Blue)
// ==============================================
Map.centerObject(aoi, 7);

Map.addLayer(collection, {
  bands: ['SR_B3', 'SR_B2', 'SR_B1'],
  min: 0,
  max: 0.3
}, 'First image of collection (L5 TM)');

Map.addLayer(composite, {
  bands: ['SR_B3', 'SR_B2', 'SR_B1'],
  min: 0,
  max: 0.3
}, 'Median composite 2007');

// ==============================================
// Export to Google Drive
// ==============================================
Export.image.toDrive({
  image: composite.select(['SR_B1','SR_B2','SR_B3','SR_B4','SR_B7']),
  description: 'Landsat5_Median_Composite_2007',
  folder: 'GEE_exports',
  fileNamePrefix: 'GGW_Senegal_2007',
  region: aoi,
  scale: 30,               // Landsat resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});





great green wall 2025
// ==============================================
// AOI Great Green Wall - Senegal (Louga / Linguère)
// ==============================================
var aoi = ee.Geometry.Rectangle([
  -14.70, 15.30,   // Ovest, Sud
  -14.10, 15.60    // Est, Nord
]);

// ==============================================
// Funzione di mascheramento nuvole 
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Collezione Sentinel-2 SR Harmonized (solo bande)
// ==============================================
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(aoi)
                   .filterDate('2025-01-01', '2025-12-31')
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);

print('Numero immagini nella collezione:', collection.size());

// ==============================================
// Composito median 
// ==============================================
var composite = collection.median().clip(aoi);

// ==============================================
// Visualizzazione RGB
// ==============================================
Map.centerObject(aoi, 10);

Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],   // RGB
  min: 0,
  max: 0.3
}, 'Composite RGB 2025');

// ==============================================
// Export delle bande spettrali (per analisi in R)
// ==============================================
Export.image.toDrive({
  image: composite.select(['B2','B3','B4','B8','B11','B12']),
  description: 'Sentinel2_GGW_Senegal_2025_bande_spettrali',
  folder: 'GEE_exports',
  fileNamePrefix: 'GGW_Senegal_2025',
  region: aoi,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});
