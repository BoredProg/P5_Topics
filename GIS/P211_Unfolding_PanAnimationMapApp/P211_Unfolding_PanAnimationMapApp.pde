/**
 * Pans smoothly between three locations, in an endless loop.
 * 
 * Press SPACE to switch tweening off (and on again).
 */
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.*; 

UnfoldingMap map;

Location[] locations = new Location[] {
  new Location(45.9231, 6.8697), new Location(53.6f, 10), new Location(51.34, 12.37)
};
int currentLocation = 0;

void setup() {
  size(1600, 720, P2D);
  
//  AcetateProvider.All 
//AcetateProvider.Basemap 
//AcetateProvider.Foreground 
//AcetateProvider.GenericAcetateProvider 
//AcetateProvider.Hillshading 
//AcetateProvider.Labels 
//AcetateProvider.Roads 
//AcetateProvider.Terrain 
//CartoDBProvider 
//EsriProvider 
//EsriProvider.DeLorme 
//EsriProvider.GenericEsriProvider 
//EsriProvider.NatGeoWorldMap 
//EsriProvider.OceanBasemap 
//EsriProvider.WorldGrayCanvas 
//EsriProvider.WorldPhysical 
//EsriProvider.WorldShadedRelief 
//EsriProvider.WorldStreetMap 
//EsriProvider.WorldTerrain 
//EsriProvider.WorldTopoMap 
//GeoMapApp 
//GeoMapApp.GeoMapAppProvider 
//GeoMapApp.TopologicalGeoMapProvider 
//Google 
//Google.GoogleMapProvider 
//Google.GoogleProvider 
//Google.GoogleSimplified2Provider 
//Google.GoogleSimplifiedProvider 
//Google.GoogleTerrainProvider 
//ImmoScout 
//ImmoScout.HeatMapProvider 
//ImmoScout.ImmoScoutProvider 
//MapBox 
//MapBox.BlankProvider 
//MapBox.ControlRoomProvider 
//MapBox.LacquerProvider 
//MapBox.MapBoxProvider 
//MapBox.MuseDarkStyleProvider 
//MapBox.PlainUSAProvider 
//MapBox.WorldLightProvider 
//MapQuestProvider 
//MapQuestProvider.Aerial 
//MapQuestProvider.GenericMapQuestProvider 
//MapQuestProvider.OSM 
//MBTilesMapProvider 
//Microsoft 
//Microsoft.AerialProvider 
//Microsoft.HybridProvider 
//Microsoft.MicrosoftProvider 
//Microsoft.RoadProvider 
//OpenMapSurferProvider 
//OpenMapSurferProvider.GenericOpenMapSurferProvider 
//OpenMapSurferProvider.Grayscale 
//OpenMapSurferProvider.Roads 
//OpenStreetMap 
//OpenStreetMap.CloudmadeProvider 
//OpenStreetMap.GenericOpenStreetMapProvider 
//OpenStreetMap.OpenStreetMapProvider 
//OpenStreetMap.OSMGrayProvider 
//OpenWeatherProvider 
//OpenWeatherProvider.Clouds 
//OpenWeatherProvider.CloudsClassic 
//OpenWeatherProvider.GenericOpenWeatherMapProvider 
//OpenWeatherProvider.Precipitation 
//OpenWeatherProvider.PrecipitationClassic 
//OpenWeatherProvider.Pressure 
//OpenWeatherProvider.PressureContour 
//OpenWeatherProvider.Rain 
//OpenWeatherProvider.RainClassic 
//OpenWeatherProvider.Snow 
//OpenWeatherProvider.Temperature 
//OpenWeatherProvider.Wind 
//StamenMapProvider 
//StamenMapProvider.Toner 
//StamenMapProvider.TonerBackground 
//StamenMapProvider.TonerLite 
//StamenMapProvider.WaterColor 
//ThunderforestProvider 
//ThunderforestProvider.GenericThunderforestProvider 
//ThunderforestProvider.Landscape 
//ThunderforestProvider.OpenCycleMap 
//ThunderforestProvider.Outdoors 
//ThunderforestProvider.Transport 
//Yahoo 
//Yahoo.AerialProvider 
//Yahoo.HybridProvider 
//Yahoo.RoadProvider 
//Yahoo.YahooProvider
  
  
  // Cool :
  // Microsoft.HybridProvider ()
  map = new UnfoldingMap(this, 0, 0, 1600, 600, new Microsoft.HybridProvider () );
  map.setTweening(true);
  map.zoomAndPanTo(locations[currentLocation], 12);

  MapUtils.createDefaultEventDispatcher(this, map);
}

void draw() {
  background(0);
  map.draw();

  if (frameCount % 120 == 0) {
   // map.panTo(locations[currentLocation]);
    currentLocation++;
    if (currentLocation >= locations.length) {
      currentLocation = 0;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    map.switchTweening();
  }
}

