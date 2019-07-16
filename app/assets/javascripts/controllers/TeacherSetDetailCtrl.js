'use strict';

app.controller('TeacherSetDetailCtrl', ['$scope', '$routeParams', '$http', '$location',
  function($scope, $routeParams, $http, $location) {
    $scope.teacher_set_id = $routeParams.id;
    $scope.moreList = false;
    $scope.$location = $location;
    $scope.errorMessage = '';
    $scope.busy = false;
    $scope.loaded = false;

    $http.get('/teacher_sets/'+$scope.teacher_set_id+'.json').success(function(data) {
      $scope.ts = data.teacher_set;
      $scope.ts.available_copies =  Number(data.teacher_set.available_copies);
      $scope.ts.total_copies = Number(data.teacher_set.total_copies)
      $scope.is_available = data.teacher_set.availability == 'available';
      $scope.ts.availability_string = data.teacher_set.availability;
      $scope.active_hold = data.teacher_set.active_hold;
      $scope.ts.teacher_set_notes = data.teacher_set.teacher_set_notes
      $scope.allowed_quantities = data.teacher_set.allowed_quantities;
      $scope.user_has_ordered_max =  data.teacher_set.allowed_quantities.length <= 0
      $scope.ts.books = data.teacher_set.books
      $scope.user = data.teacher_set.user
      $scope.quantity = data.teacher_set.allowed_quantities.length > 0 ? data.teacher_set.allowed_quantities[0] : 0 
      $scope.loaded = true;
    });

    $scope.autoReserve = function() {
      if ($scope.busy) return;
      $scope.busy = true;

      $scope.formData = { original_path: $location.path() + '?' + $.param($routeParams), query_params: {quantity: $scope.quantity } };

      $http.post('/teacher_sets/'+$scope.teacher_set_id+'/holds.json', $scope.formData).success(function(resp) {
        if ( resp.redirect_to ) {
          window.location = resp.redirect_to;
        } else {
          $location.path('/holds/'+resp.hold.access_key).search({new_order: 1});
        }
          $scope.busy = false;
      }).error(function(resp) {
        $scope.errorMessage = resp.error
      })
    };

    $scope.doReserve = function(){
      // automatically place reservation if user has alt email and school id set
      if ( $scope.user && $scope.user.alt_email && $scope.user.school_id ) {
        $scope.autoReserve();

      // otherwise, go to reservation form as normal
      } else {
        $location.path("/holds/new").search({teacher_set_id: $scope.teacher_set_id});
      }
    };
  }
]);
