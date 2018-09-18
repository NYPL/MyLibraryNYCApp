'use strict';

// The main app module
var app = angular.module('MyLibraryNYCApp',['ngRoute','ngCookies','infinite-scroll','scroll-event','slider-grades']);

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
app.config([ '$locationProvider', '$routeProvider', '$httpProvider',
  function($locationProvider, $routeProvider, $httpProvider) {
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
  }
]);
