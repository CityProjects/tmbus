(function () {
  'use strict';

  this.TUT.service('tutRouteEditService', [ '$rootScope', '$http', '$timeout', '$q', function ($rootScope, $http, $timeout, $q) {

    var serviceObject,
            hoveredStop, previouslyHoveredStop, selectedStop, previouslySelectedStop,
            route, mapData, allStops,
            modelDirty = false, modelPreprocessed = false,
            autosaveDataPromise = null,
            deferredSaveData = null;


    mapData = {
      center: { lat: 45.75554707085215, lng: 21.226959228515625 },
      zoom: 12,
      stops: []
    };



    function saveData() {
      if( ! modelDirty) {
        deferredSaveData.resolve(false);
        return;
      }
      $http.put('/api/v1/routes', route).success(function (data) {
        modelDirty = false;
        console.log('route data saved');
        deferredSaveData.resolve(true);
      }).error(function (data, status) {
                modelDirty = true;
                deferredSaveData.reject({ status: status, data: data });
              });
    }




    //------------------------------------------------------------------------------------
    // service object
    //------------------------------------------------------------------------------------
    serviceObject = {

      get route() {
        return route;
      },

      get mapData() {
        return mapData;
      },

      get allStops() {
        return allStops;
      },

      get hoveredStop() {
        return hoveredStop;
      },

      set hoveredStop(value) {
        previouslyHoveredStop = hoveredStop;
        hoveredStop = value;
        $rootScope.hoveredStop = value;
      },

      get previouslyHoveredStop() {
        return previouslyHoveredStop;
      },

      get selectedStop() {
        return selectedStop;
      },

      set selectedStop(value) {
        previouslySelectedStop = selectedStop;
        selectedStop = value;
        $rootScope.selectedStop = value;
      },

      get previouslySelectedStop() {
        return previouslySelectedStop;
      },





      // called by controller - puts all things in motion
      init: function (route_id) {
        var deferred = $q.defer();
        $http.get('/api/v1/routes/' + route_id).success(function (data) {
          route = data;
          $rootScope.route = data;
          route.directions.forEach(function (direction) {
            direction.stops.forEach(function (stop) {
              if (stop.latitude != null && stop.longitude != null) {
                mapData.stops.push(stop);
              }
            });
          });
          $rootScope.mapData = mapData;
          window.route = data;// FOR DEBUG
          window.mapData = mapData;
          deferred.resolve();
        }).error(function(data, status, headers) {
                  deferred.reject({ data: data, status: status });
                });
        return deferred.promise;
      },




      modelChanged: function () {
        // preprocess model (sync with mapData, cleanup, etc...)
        $.each(route.directions, function (dirIdx, direction) {
          $.each(direction.stops, function (stopIdx, stop) {
            stop.direction = dirIdx;
            stop.order_idx = stopIdx;

            // check if not already exists in the stops in the map
            if ( mapData.stops.indexOf(stop) === -1 ) {
              if (stop.latitude != null && stop.longitude != null) {
                mapData.stops.push(stop);
              }
            }
          });

          var stopsCount = direction.stops.length;
          if (stopsCount > 0) {
            var s = direction.stops[stopsCount-1];
            direction.name = s.name || s.ename;
          } else {
            direction.name = "Dir#" + dirIdx;
          }

        });
        modelDirty = true;
        deferredSaveData = $q.defer();
        // schedule to auto-save the data
        autosaveDataPromise = $timeout(function () {
          saveData();
        }, 3000);
        return deferredSaveData.promise;
      },




      manualSaveData: function () {
        if (autosaveDataPromise !== null) {
          $timeout.cancel(autosaveDataPromise);
        }
        if ( ! deferredSaveData) {
          deferredSaveData = $q.defer();
        }
        saveData();
        return deferredSaveData.promise;
      },




      stopExists: function (checkStop) {
        return route.directions.some(function (direction) {
          return direction.stops.some(function (stop) {
            return stop.id == checkStop.id;
          });
        });
      },






      loadFullStationsList: function (force) {
        var deferred = $q.defer();
        // skip if allStops exist and not force
        if (allStops != null && ! force) {
          deferred.resolve(false);
          return;
        }
        $http.get('/api/v1/stops').success(function (data) {
          allStops = data;
          $rootScope.allStops = data;
          window.allStops = data; // FOR DEBUG
          deferred.resolve(true);
        }).error(function(data, status, headers) {
                  deferred.reject({ data: data, status: status });
                });
        return deferred.promise;
      }

    };

    return serviceObject;
  }]);

}).call(window);
