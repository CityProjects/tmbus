(function () {
  'use strict';

  this.TUT.directive('tutRouteListItem', [ 'tutRouteEditService', '$rootScope', function (routeEditService, $rootScope) {
    var directiveDefObject = {
      restrict: 'E',
      replace: true,
      transclude: true,
      template: '<div class="route-stop-list-item-container" ng-mouseenter="onMouseEnterListItem()" ng-mouseleave="onMouseLeaveListItem()" ng-class="stopListItemClassName">' +
              '<div class="bullet"><i ng-class="bulletIconClassName"></i></div>' +
              '<input type="text" class="name" required="required" ng-model="stop.name" maxlength="26" ui-event="{ blur: \'onNameInputBlur()\', focus: \'onNameInputFocus()\' }" />' +
              '<div class="eid">{{stop.ename}} &nbsp; (#{{stop.id}})</div>' +
              '<i class="remove visible-on-hover icon-remove"></i>' +
              '<i class="map-marker visible-on-hover icon-map-marker" ng-class="mapMarkerExtraClassName" ng-click="onMapMarkerClick()"></i>' +
              '</div>',
      link: function (scope, element, attrs) {
        var defaultBulletIcon = 'icon-circle-blank',
                stop = scope.stop;

        element.find('input.name').on('keypress', function (event) {
          if (event.keyCode === 13) {
            event.preventDefault();
            $(event.target).blur();
          }
        });

        scope.bulletIconClassName = defaultBulletIcon;

        scope.onMouseEnterListItem = function () {
//          console.log('mouse enter');
          scope.stopListItemClassName = 'mouseover';
          scope.bulletIconClassName = 'icon-move';
          routeEditService.hoveredStop = stop;
        };

        scope.onMouseLeaveListItem = function () {
//          console.log('mouse leave');
          scope.stopListItemClassName = '';
          scope.bulletIconClassName = defaultBulletIcon;
          routeEditService.hoveredStop = null;
        };


        var textName = null;
        scope.onNameInputFocus = function () {
          textName = stop.name;
        };

        scope.onNameInputBlur = function () {
          stop.name = stop.name.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
          if (textName !== stop.name) {
            scope.markModelDirty();
          }
        };



        scope.$watch('stop.latitude', function (stopLat) {
          if (stopLat != null) {
            if (routeEditService.selectedStop === stop) {
              scope.mapMarkerExtraClassName = 'selected';
            } else {
              scope.mapMarkerExtraClassName = '';
            }
          } else {
            scope.mapMarkerExtraClassName = 'missing';
          }
        });


        $rootScope.$watch('selectedStop', function (selectedStop) {
          if (selectedStop === stop) {
            scope.mapMarkerExtraClassName = 'selected';
          } else if (stop.latitude != null) {
            scope.mapMarkerExtraClassName = '';
          } else {
            scope.mapMarkerExtraClassName = 'missing';
          }
        });


        scope.onMapMarkerClick = function () {
          if (stop.latitude && stop.longitude) {
            if (routeEditService.selectedStop === stop) {
              routeEditService.selectedStop = null;
            } else {
              routeEditService.selectedStop = stop;
            }
          } else {
            stop.latitude = scope.mapData.center.lat;
            stop.longitude = scope.mapData.center.lng;
            stop.mapMarkerBounce = true;
            scope.mapData.stops.push(stop);
            routeEditService.selectedStop = stop;
          }
        };

      }
    };
    return directiveDefObject;
  }]);






  this.TUT.directive("tutRouteEditMap", [ 'tutRouteEditService', '$rootScope', function (routeEditService, $rootScope) {

    var directiveDefObj =  {
      restrict: "E",
      replace: true,
      transclude: true,
      scope: {
        center: "=center",
        zoom: "=zoom"
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






        $rootScope.$watch('mapData.stops', function (stops) {
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








  this.TUT.directive("rcHasFocus", [ function () {

    var directiveDefObj =  {
      restrict: "A",
      link: function (scope, element, attrs) {
        var $el = element[0];
        scope.$watch(attrs.rcHasFocus, function (hasFocus) {
          if (hasFocus) {
            $el.focus();
          } else if (hasFocus === false) {
            $el.blur();
          }
        });
      }
    };

    return directiveDefObj;
  }]);




}).call(window);
