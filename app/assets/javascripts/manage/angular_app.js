var TUT = angular.module('TUT', ['ui'])

TUT.controller('RouteEditCtrl', ['$scope', function($scope) {

  $scope.route = gon.route.route;


}]);
