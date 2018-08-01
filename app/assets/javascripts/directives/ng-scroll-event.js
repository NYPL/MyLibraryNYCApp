/* ng-scroll-event - v1.0.0 - 2014-01-15 */
var mod;

mod = angular.module('scroll-event', []);

mod.directive("scrollEvent", [ '$window',
  function ($window) {
    return function(scope, element, attrs) {
      angular.element($window).bind("scroll", function() {
        scope.boolPadLeft = false;
        if (window.innerWidth < 800) {
          if (this.pageYOffset >= 1) {
            scope.boolMakeFloat = true;
          } else {
            scope.boolMakeFloat = false;
          }
        }
        /* if (window.innerWidth < 800 && scope.boolMakeFloat) {
          // mobile and floating
          $("#main").css("padding-top", $("#facets").height());
        } else if (window.innerWidth > 800 && scope.boolMakeFloat) {
          // desktop and floating
          scope.boolPadLeft = true;
        } else {
          $("#main").css("padding-top", 0);
        } */
        // console.log("scrolled: ", scope, scope.boolMakeFloat);
        scope.$apply();
      });
    };
  }
]);