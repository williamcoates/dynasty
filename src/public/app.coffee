routesConfigFn = ($routeProvider)->

  $routeProvider.when '/',
  	templateUrl: 'support/support.html'
  	controller: 'supportCtrl'
  	controllerAs: 'vm'

  $routeProvider.otherwise({redirectTo: '/'})

m = angular.module('app', [ 'ngRoute' ])

m.config ['$routeProvider', routesConfigFn]