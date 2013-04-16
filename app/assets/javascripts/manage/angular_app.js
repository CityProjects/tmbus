// TUT ~ Timisoara Urban Transport  (sau Transport Urban Timisoara)

(function () {
  'use strict';

  this.TUT = angular.module('TUT', ['ng-rails-csrf', 'ui']);


  this.TUT.service('tutRouteEditService', [ '$rootScope', function ($rootScope) {
    var serviceObject,
            hoveredStop, previouslyHoveredStop, selectedStop, previouslySelectedStop;


    //------------------------------------------------------------------------------------
    // service object
    //------------------------------------------------------------------------------------
    serviceObject = {

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
      }


    };

    return serviceObject;
  }]);






  this.TUT.controller('RouteEditCtrl', ['tutRouteEditService', '$scope', '$http', '$timeout', '$rootScope', function (tutRouteEditService, $scope, $http, $timeout, $rootScope) {

    var modelDirty = false;
    var saveDataPromise = null;



    $scope.saveBtnLabel = 'Loading data...';

    $scope.mapData = {
      center: { lat: 45.75554707085215, lng: 21.226959228515625 },
      zoom: 12,
      stops: []
    };


    $scope.sortableOptions = {
      connectWith: '.route-stops-list',
      stop: function (e, ui) {
        $.each($scope.route.directions, function (dirIdx, direction) {
          $.each(direction.stops, function (stopIdx, stop) {
            stop.direction = dirIdx;
            stop.order_idx = stopIdx;
          });
        });
        $scope.markModelDirty();
      }
    };




    $http.get('/api/v1/routes/' + gon.route.route.id).success(function (data) {
      $scope.route = data;
      $scope.saveBtnLabel = 'Saved';

      $scope.route.directions.forEach(function (direction) {
        direction.stops.forEach(function (stop) {
          if (stop.latitude != null && stop.longitude != null) {
            $scope.mapData.stops.push(stop);
          }
        });
      });



      // FOR DEBUG
      window.route = data;
    });





    var saveData = function () {
      if( ! modelDirty) {
        return;
      }
      $scope.saveBtnLabel = 'Saving ...';
      $http.put('/api/v1/routes', $scope.route).success(function (data) {
        $scope.markModelSaved();
        console.log('route data saved');
      }).error(function (data, status) {
                modelDirty = true;
              });
    };


    $scope.markModelDirty = function () {
      console.log('model changed');
      modelDirty = true;
      $scope.saveBtnLabel = 'Save';
      // schedule to auto-save the data
      saveDataPromise = $timeout(function () {
        saveData();
      }, 3000);
    };

    $scope.markModelSaved = function () {
      console.log('model saved');
      modelDirty = false;
      $scope.saveBtnLabel = 'Saved';
    };


    $scope.onClickSaveRouteData = function () {
//      console.log('manual save', saveDataPromise);
      if (saveDataPromise !== null) {
        $timeout.cancel(saveDataPromise);
      }
      saveData();
    };



  }]); // controller








  this.TUT.directive('tutRouteListItem', [ 'tutRouteEditService', '$rootScope', function (routeEditService, $rootScope) {
    var directiveDefObject = {
      restrict: 'E',
      replace: true,
      transclude: true,
      template: '<div class="route-stop-list-item-container" ng-mouseenter="onMouseEnterListItem()" ng-mouseleave="onMouseLeaveListItem()" ng-class="stopListItemClassName">' +
              '<div class="bullet"><i ng-class="bulletIconClassName"></i></div>' +
              '<input type="text" class="name" required="required" ng-model="stop.name" maxlength="26" ui-event="{ blur: \'onNameInputBlur()\' }" />' +
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

        scope.onNameInputBlur = function () {
          scope.markModelDirty();
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



}).call(window);
