(function () {
  'use strict';

  this.TUT.directive("routeEditMap", [ 'tutRouteEditService', '$rootScope', function (routeEditService, $rootScope) {

    var directiveDefObj =  {
      restrict: "E",
      replace: true,
      transclude: true,
      scope: {
        center: "=center",
        zoom: "=zoom",
        stops: "=stops"
      },
      template: '<div class="map"></div>',
      link: function (scope, element, attrs) {

        var $el = element[0],
                map = new L.Map($el),
                markersHash = {};



        function setMarkerIconForStop(stop, iconType, iconColor) {
          if ( ! stop) {
            return false;
          }

          var marker = markersHash[stop.id];
          if ( ! marker) {
            return false;
          }

          // default icon type
          if ( ! iconType) {
            iconType = 'circle-blank';
          }

          // default color based on direction (and contrast)
          if ( ! iconColor) {
            iconColor = (stop.direction === 0 ? 'green' : 'blue');
          } else if (iconColor === 'contrast') {
            iconColor = (stop.direction === 0 ? 'darkgreen' : 'darkblue');
          }

          marker.setIcon(L.AwesomeMarkers.icon({ icon: iconType, color: iconColor }));
          return marker;
        }



        function setMarkerPopupForStop(stop, popupText) {
          if ( ! stop) {
            return false;
          }

          var marker = markersHash[stop.id];
          if ( ! marker) {
            return false;
          }

          if (popupText != null) {
            marker.bindPopup(popupText);
          } else { // default text for popup
            marker.bindPopup('<span class="font-bold">'+ stop.name +'</span><br/><span>'+ stop.ename +' (#'+ stop.eid +')</span>');
          }
          return marker;
        }


        function highlightMarker(marker, revertNormal) {
          if ( ! marker) {
            return false;
          }

          if (revertNormal) {
            marker.setZIndexOffset(0);
            marker.closePopup();
          } else {
            marker.setZIndexOffset(500);
            marker.openPopup();
          }
        }


        function enableDraggingMarker(marker, disable) {
          if ( ! marker) {
            return false;
          }

          if (disable === false) {
            marker.setZIndexOffset(0);
            marker.dragging.disable();
          } else {
            marker.setZIndexOffset(500);
            marker.dragging.enable();
          }
        }



        L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.jpg', {
          subdomains: '1234',
          attribution: '&copy; <a href="http://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a> contributors; Tiles courtesy of <a href="http://www.mapquest.com" target="_blank">MapQuest</a>',
          minZoom: 10,
          maxZoom: 18,
          detectRetina: true,
          reuseTiles: true
        }).addTo(map);


        // Default center of the map: Timisoara, RO
        var point = new L.LatLng(45.7555, 21.2269);
        map.setView(point, 12);
        map.setMaxBounds([[45.593, 21.044], [45.952, 21.423]]);


        scope.$watch("center", function (center) {
          if (center != null) {
            center = new L.LatLng(scope.center.lat, scope.center.lng);
            var zoom = scope.zoom || 12;
            map.setView(center, zoom);
          }
        });


        // Listen for map drags
        map.on("dragend", function (e) {
          scope.$apply(function (s) {
            s.center.lat = map.getCenter().lat;
            s.center.lng = map.getCenter().lng;
          });
        });


        scope.$watch("center.lng", function (newValue) {
          map.setView(new L.LatLng(map.getCenter().lat, newValue), map.getZoom());
        });

        scope.$watch("center.lat", function (newValue) {
          map.setView(new L.LatLng(newValue, map.getCenter().lng), map.getZoom());
        });



        // Listen for zoom
        map.on("zoomend", function (e) {
          scope.$apply(function (s) {
            s.zoom = map.getZoom();
          });
        });

        scope.$watch("zoom", function (zoomValue) {
          if (zoomValue != null) {
            map.setZoom(zoomValue);
          }
        });






        scope.$watch("stops", function (stops) {
          if ( ! stops) {
            return;
          }
          stops.forEach(function (stop) {
            // create or update exisitng marker
            var marker = markersHash[stop.id];
            if ( ! marker) {
              // only create marker if stop has latlng
              if (stop.latitude != null && stop.longitude != null) {
                marker = new L.marker([stop.latitude, stop.longitude], { autoBounce: false });
                markersHash[stop.id] = marker;
                setMarkerIconForStop(stop);
                setMarkerPopupForStop(stop);

                marker.addTo(map);

                if (stop === routeEditService.selectedStop) {
                  marker = setMarkerIconForStop(stop, 'move', 'contrast');
                  enableDraggingMarker(marker);
                }

//                if (stop.mapMarkerBounce) {
//                  marker.openPopup();
//                  stop.mapMarkerBounce = false;
//                }


                marker.on('mouseover', function (e) {
                  if ( ! routeEditService.selectedStop) {
                    marker.openPopup();
                  }
                });
                marker.on('mouseout', function (e) {
                  marker.closePopup();
                });

                marker.on('dragend', function (e) {
                  stop.latitude = marker.getLatLng().lat;
                  stop.longitude = marker.getLatLng().lng;
                });
              }

            } else {
              // update existing marker if not the one selected
              if (stop !== routeEditService.selectedStop) {
                marker.setLatLng([stop.latitude, stop.longitude]);
                setMarkerIconForStop(stop);
              }
              setMarkerPopupForStop(stop);
            }
          });
        }, true);



        $rootScope.$watch("hoveredStop", function (hoveredStop) {
          if (routeEditService.selectedStop) {
            return;
          }

          var marker;
          marker = setMarkerIconForStop(hoveredStop, 'asterisk');
          highlightMarker(marker);

          marker = setMarkerIconForStop(routeEditService.previouslyHoveredStop);
          highlightMarker(marker, true);
        });



        $rootScope.$watch("selectedStop", function (selectedStop) {
          var marker;
          marker = setMarkerIconForStop(selectedStop, 'move', 'contrast');
          enableDraggingMarker(marker);

          marker = setMarkerIconForStop(routeEditService.previouslySelectedStop);
          enableDraggingMarker(marker, true);
      });


  } // end of link function
};

return directiveDefObj;
}]);

}).call(window);
