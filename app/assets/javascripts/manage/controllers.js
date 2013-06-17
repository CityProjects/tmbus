(function () {
  'use strict';


  this.TUT.controller('RouteEditCtrl', ['tutRouteEditService', '$scope', '$rootScope', '$dialog', function (tutRouteEditService, $scope, $rootScope, $dialog) {

    $scope.saveBtnLabel = 'Loading data...';

    $scope.mapData = tutRouteEditService.mapData;

    $scope.sortableOptions = {
      connectWith: '.route-stops-list',
      stop: function (e, ui) {
        $scope.markModelDirty();
      }
    };



    $scope.markModelDirty = function () {
      console.log('model changed');
      $scope.saveBtnLabel = 'Save';
      tutRouteEditService.modelChanged().then(function () {
        $scope.saveBtnLabel = 'Saved';
      }, function () {
        $scope.saveBtnLabel = 'Error saving! Try again.';
      });
    };


    $scope.onClickSaveRouteData = function () {
//      console.log('manual save', saveDataPromise);
      $scope.saveBtnLabel = 'Saving ...';
      tutRouteEditService.manualSaveData().then(function () {
        $scope.saveBtnLabel = 'Saved';
      }, function () {
        $scope.saveBtnLabel = 'Error saving! Try again.';
      });
    };



    $scope.onAddStopClicked = function (direction) {
      console.log('onAddStopClicked', direction);
      if ($scope.addStopToDirection === direction) {
        $scope.addStopToDirection = null; // close
      } else {
        $scope.addStopToDirection = direction;
      }
      tutRouteEditService.loadFullStationsList();
      $scope.selectedNewStop = '';
    };


    $scope.onSubmitAddStopForm = function (newStop) {
      console.log('newStop', newStop);


      if (tutRouteEditService.stopExists(newStop)) {
        alert("Statia exista deja in traseu.\nNu va fi adaugata.");
        return;
      }

      var stop = {
        route_id: $rootScope.route.id,
        order_idx: 0,
        stop_id: newStop.id
      };
      angular.extend(stop, newStop);
      $scope.addStopToDirection.stops.unshift(stop);
      $scope.addStopToDirection = null;
      $scope.markModelDirty();
    };







    // -----------------------------------
    // START - put things in motion
    tutRouteEditService.init(gon.route.route.id).then(function () {
      $scope.saveBtnLabel = 'Saved';
      $scope.markModelDirty(); // to force sync client data with server data
    });

  }]); // controller



}).call(window);
