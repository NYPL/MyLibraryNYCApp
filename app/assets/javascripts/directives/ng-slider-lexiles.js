/* ng-slider-lexiles - v1.0.0 - 2014-01-22 */
var mod;

mod = angular.module('slider-lexiles', []);

/*
 The name of this directive is camelCase, which is correct
 However, when using the directive in your view, you must convert it to snake case
 Find out more here http://docs.angularjs.org/guide/directive
*/
mod.directive('sliderLexiles', [
  function() {
    return {
      link: function(scope, elem, attrs) {
        // console.log(scope.lexiles);
        $(elem).slider({
            range: true,
            min: scope.min_lexile,
            max: scope.max_lexile,
            step: 10,
            values: scope.lexile_values,
            slide: function( event, ui ) {
              scope.lexile_values[0]= ui.values[0];
              scope.lexile_values[1] = ui.values[1];
              scope.$apply();
              // console.log(ui.values[0], ui.values[1], ui);
            },
            stop: function( event, ui ) {
              scope.onLexileSliderStop && scope.onLexileSliderStop(ui.values[0], ui.values[1]);
            }
        });
      }
    }
  }
]);