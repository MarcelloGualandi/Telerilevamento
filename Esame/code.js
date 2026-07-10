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
