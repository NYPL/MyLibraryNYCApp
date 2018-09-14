'use strict';

app.controller('TeacherSetListCtrl', [ '$scope', '$timeout', '$cookieStore', '$location', 'TeachSetListFactory',
  function ($scope, $timeout, $cookieStore, $location, TeachSetListFactory) {

    $scope.$location = $location;
    $scope.teacher_sets = new TeachSetListFactory();
    $scope.grades = [0,1,2,3,4,5,6,7,8,9,10,11,12];
    $scope.min_grade = $scope.grades[0];
    $scope.max_grade = $scope.grades[$scope.grades.length-1];
    $scope.grade_values = [];
    $scope.grade_values[0] = $scope.teacher_sets.queryParams.grade_begin || $scope.min_grade;
    $scope.grade_values[1] = $scope.teacher_sets.queryParams.grade_end || $scope.max_grade;
    $scope.onGradeSliderStop = function(grade_begin, grade_end){
      $scope.teacher_sets.doGrades(grade_begin, grade_end);
    };
    $scope.teacher_sets.nextPage();

    $scope.showFacets = function(){
      $scope.facetsVisible = true;
      //$('#keyword').focus();
    };

    $scope.hideFacets = function(){
      $scope.facetsVisible = false;
      //$('#keyword').blur();
    };

    // show the facets initially, then hide
    var sawFacetTab = $cookieStore.get('sawFacetTab');
    if (!sawFacetTab) {
      $scope.showFacets();
      $cookieStore.put('sawFacetTab',true);
      $timeout(function(){
        $scope.hideFacets();
      }, 1000);
    } else {
      $scope.hideFacets();
    }
  }
]);
