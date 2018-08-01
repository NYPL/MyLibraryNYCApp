/* ng-slider-grades - v1.0.0 - 2014-01-22 */
var mod;

mod = angular.module('slider-grades', []);

/*
 The name of this directive is camelCase, which is correct
 However, when using the directive in your view, you must convert it to snake case
 Find out more here http://docs.angularjs.org/guide/directive
*/
mod.directive('sliderGrades', [
  function() {
    return {
      link: function(scope, elem, attrs) {
        $(elem).slider({
            range: true,
            min: scope.grades[0],
            max: scope.grades[scope.grades.length-1],
            values: scope.grade_values,
            slide: function( event, ui ) {
              scope.grade_values[0] = ui.values[0];
              scope.grade_values[1] = ui.values[1];
              scope.$apply();
            },
            stop: function( event, ui ) {
              scope.onGradeSliderStop && scope.onGradeSliderStop(ui.values[0], ui.values[1]);
            }
        });
      }
    }
  }
]);