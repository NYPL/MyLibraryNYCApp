'use strict';

app.controller('StaticIndexCtrl', ['$scope', '$routeParams', '$http', '$location',
  function($scope, $routeParams, $http, $location) {
    //$scope.book_id = $routeParams.id;
    $scope.$location = $location;
    $scope.loaded = false;

    //$scope.goToTeacherSet = function(){
    //  if ( $scope.teacher_sets && $scope.teacher_sets.length == 1 ) {
    //    $location.path('/teacher_sets/'+$scope.teacher_sets[0].id).search({});
    //  // there's ambiguity, so just go back to last page
    //  } else {
    //    window.history.go(-1);
    //  }
    //};

    //$http.get('/books/'+$scope.book_id+'.json').success(function(data) {
    //  // console.log(data);
    //  $scope.book = data.book;
    //  $scope.teacher_sets = data.teacher_sets;
    //  $scope.loaded = true;
    //});
    $scope.loaded = true;
  }
]);
