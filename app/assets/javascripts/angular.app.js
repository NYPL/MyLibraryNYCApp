'use strict';

// The main app module
var app = angular.module('MyLibraryNYCApp',['ngRoute','ngCookies','infinite-scroll','scroll-event','slider-grades','angularytics']);

// URL parsing for breadcrumb
app.filter('regex', function() {
  return function(text, regex) {
    var patt = new RegExp(regex);
    if(text == undefined || text == "")
      return false;
    if(patt.test(text))
        return true;
    return false;
  };
});

// Define routes here
app.config([ '$locationProvider', '$routeProvider', '$httpProvider', 'AngularyticsProvider',
  function($locationProvider, $routeProvider, $httpProvider, AngularyticsProvider) {
    // $locationProvider.html5Mode(true);
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    $routeProvider.
      when('/teacher_sets', {
        templateUrl: '/templates/teacher_sets/list.html',
        controller: 'TeacherSetListCtrl',
        reloadOnSearch: false // don't repaint everything for faceting
      }).
      when('/teacher_sets/:id', {
        templateUrl: '/templates/teacher_sets/detail.html',
        controller: 'TeacherSetDetailCtrl'
      }).
      when('/holds/new', {
        templateUrl: '/templates/holds/new.html',
        controller: 'HoldNewCtrl'
      }).
      when('/holds/:id', {
        templateUrl: '/templates/holds/detail.html',
        controller: 'HoldDetailCtrl'
      }).
      when('/holds/:id/cancel', {
        templateUrl: '/templates/holds/cancel.html',
        controller: 'HoldCancelCtrl'
      }).
      when('/books/:id', {
        templateUrl: '/templates/books/detail.html',
        controller: 'BookDetailCtrl'
      }).
      otherwise({
        redirectTo: '/teacher_sets'
      });
    AngularyticsProvider.setEventHandlers(['Console', 'GoogleUniversal']);
  }
]);

app.run(['Angularytics', '$http', function(Angularytics, $http) {
  Angularytics.init();

  // First load, set analytics custom dimensions: user_id and school
  $http.get('/settings.json').success(function(settings) {      
    
    // Analytics maintinas these internal names for these custom dimensions:
    var dimensionKeyMap = {
      user_id: 'dimension1',
      school: 'dimension2',
    }
    
    var props = {}
    props[dimensionKeyMap.user_id] = 'anon';
    props[dimensionKeyMap.school] = 'none';

    if(settings) {
      props[dimensionKeyMap.user_id] = settings.id;
      if(settings.school)
        props[dimensionKeyMap.school] = settings.school.name;
    }

    // console.log('set analytics vals: ', props);
    window.ga('set', props);


  });
}]);
