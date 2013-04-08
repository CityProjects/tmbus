var TUT = angular.module('TUT', ['ng-rails-csrf', 'ui'])


TUT.controller('RouteEditCtrl', ['$scope', '$http', '$timeout', function($scope, $http, $timeout) {

  $scope.saveBtnLabel = 'Loading data...'


  $http.get('/api/v1/routes/' + gon.route.route.id).success(function(data) {
    $scope.route = data;
    $scope.saveBtnLabel = 'Save'
  });

  $scope.onListReordered = function() {
    console.log('reordered')
  }


  var saveDataPromise = null;

  var saveData = function() {
    $scope.saveBtnLabel = 'Saving ...'
    $http.put('/api/v1/routes', $scope.route).success(function(data) {
      console.log('route data saved')
      $scope.saveBtnLabel = 'Saved'
      $timeout(function() {
        $scope.saveBtnLabel = 'Save'
      }, 1000);

      saveDataPromise = $timeout(function() {
        saveData();
      }, 10000)
    });
  }


  saveData();



  $scope.saveRouteData = function() {
    console.log('manual save', saveDataPromise)
    if (saveDataPromise !== null) {
      $timeout.cancel(saveDataPromise);
    }
    saveData();
  }

}]);
