Landsat 	Burkina Faso 2007

// ==============================================
// Function to mask clouds using QA_PIXEL (Landsat 5 TM C2)
// Bits:
// 3 = cloud shadow
// 5 = cloud
// 7 = dilated cloud
// ==============================================
function maskL5clouds(image) {
  var qa = image.select('QA_PIXEL');

  var cloud   = qa.bitwiseAnd(1 << 5).eq(0);
  var shadow  = qa.bitwiseAnd(1 << 3).eq(0);
  var dilated = qa.bitwiseAnd(1 << 7).eq(0);

  var mask = cloud.and(shadow).and(dilated);

  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load Landsat 5 TM Surface Reflectance collection (2007)
// ==============================================
var collection = ee.ImageCollection('LANDSAT/LT05/C02/T1_L2')
                   .filterBounds(aoi)
                   .filterDate('2007-01-01', '2007-12-31')
                   .map(maskL5clouds);

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// ==============================================
var composite = collection.median().clip(aoi);

// ==============================================
// Visualization on the Map
// ==============================================
Map.centerObject(aoi, 10);

// Display the first image of the collection
Map.addLayer(collection, {
  bands: ['SR_B3', 'SR_B2', 'SR_B1'],  
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  bands: ['SR_B3', 'SR_B2', 'SR_B1',],
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================
Export.image.toDrive({
  image: composite.select(['SR_B3', 'SR_B2', 'SR_B1', 'SR_B4', 'SR_B7']),
  description: 'Landsat5_Median_Composite_2007',
  folder: 'GEE_exports',
  fileNamePrefix: 'BURKINA_2007',
  region: aoi,
  scale: 30,               // Landsat 5 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});


Sentinel-2 Burkina Faso 2025

var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(aoi)
                   .filterDate('2025-01-01', '2025-12-31')              // Filter by date                                   // Filter by AOI
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the AOI overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(aoi);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(aoi, 10); // Zoom to the AOI

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  bands: ['B4', 'B3', 'B2', 'B8', 'B12'],  // True color: Red, Green, Blue
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2', 'B8', 'B12'],
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2', 'B8', 'B12']),  // Select RGB bands
  description: 'Sentinel2_Median_Composite',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'BURKINA_2025',
  region: aoi,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
})


Sampelga 2025
// ==============================================
// Sentinel-2 Surface Reflectance - Cloud Masking and Visualization
// https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
// ==============================================

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Keep only pixels where both cloud and cirrus bits are 0
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  // Apply the cloud mask and scale reflectance values (0–10000 ➝ 0–1)
  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load and Prepare the Image Collection
// ==============================================

// Load Sentinel-2 SR Harmonized collection (atmospherical correction already done)
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(aoi)
                   .filterDate('2025-06-01', '2025-09-30')              // Filter by date                                   // Filter by AOI
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the AOI overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(aoi);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(aoi, 10); // Zoom to the AOI

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  bands: ['B4', 'B3', 'B2'],  // True color: Red, Green, Blue
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2', 'B8', 'B12']),  // Select RGB bands
  description: 'Sentinel2_Median_Composite',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'Sampelga_2025',
  region: aoi,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

Sahel NDVI 2023
// Area del Sahel
var sahel = ee.Geometry.Rectangle([-20, 10, 40, 18]);

// NDVI MODIS per il 2023 (valori scalati 0–10000)
var modis2023 = ee.ImageCollection('MODIS/006/MOD13A2')
  .filterBounds(sahel)
  .filterDate('2023-01-01', '2023-12-31')
  .select('NDVI');

// NDVI annuale (media)
var ndvi2023 = modis2023.mean();

// Conversione a NDVI reale (-1 → +1)
var ndvi2023_real = ndvi2023.divide(10000).rename('NDVI_real');

// Palette NDVI Earth Engine
var palette = ['blue', 'white', 'yellow', 'green'];

// Visualizzazione
Map.centerObject(sahel, 4);
Map.addLayer(ndvi2023_real, {min:-1, max:1, palette: palette}, 'NDVI reale 2023');

// Esportazione GeoTIFF NDVI reale
Export.image.toDrive({
  image: ndvi2023_real,
  description: 'NDVI_Sahel_2023_reale',
  scale: 1000,        // MODIS 1 km
  region: sahel,
  maxPixels: 1e9,     // sicurezza
  fileFormat: 'GeoTIFF'
});

Sahel NDVI 2007
// Area del Sahel
var sahel = ee.Geometry.Rectangle([-20, 10, 40, 18]);

// NDVI MODIS per il 2007 (valori scalati 0–10000)
var modis2007 = ee.ImageCollection('MODIS/006/MOD13A2')
  .filterBounds(sahel)
  .filterDate('2007-01-01', '2007-12-31')
  .select('NDVI');

// NDVI annuale (media)
var ndvi2007 = modis2007.mean();

// Conversione a NDVI reale (-1 → +1)
var ndvi2007_real = ndvi2007.divide(10000).rename('NDVI_real');

// Palette NDVI Earth Engine
var palette = ['blue', 'white', 'yellow', 'green'];

// Visualizzazione
Map.centerObject(sahel, 4);
Map.addLayer(ndvi2007_real, {min:-1, max:1, palette: palette}, 'NDVI reale 2007');

// Esportazione GeoTIFF NDVI reale
Export.image.toDrive({
  image: ndvi2007_real,
  description: 'NDVI_Sahel_2007_reale',
  scale: 1000,
  region: sahel,
  fileFormat: 'GeoTIFF'
});


