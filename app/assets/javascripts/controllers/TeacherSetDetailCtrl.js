'use strict';

app.controller('TeacherSetDetailCtrl', ['$scope', '$routeParams', '$http', '$location',
  function($scope, $routeParams, $http, $location) {
    $scope.teacher_set_id = $routeParams.id;
    $scope.moreList = false;
    $scope.formData = { original_path: $location.path() + '?' + $.param($routeParams) };
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
      $scope.ts.books = data.teacher_set.books
      $scope.user = data.teacher_set.user
      $scope.quantity = Number(data.teacher_set.allowed_quantities[0]);
      $scope.loaded = true;
    });

    $scope.autoReserve = function() {
      if ($scope.busy) return;
      $scope.busy = true;
      $http.post('/teacher_sets/'+$scope.teacher_set_id+'/holds.json', $scope.formData).success(function(resp) {
        if ( resp.redirect_to ) {
          window.location = resp.redirect_to;
        }
        $scope.holdsUrl = {original_path: "/holds/"+resp.hold.access_key, 
                     query_params: {id: resp.hold.access_key, quantity: $scope.quantity }};

        $http.put('/teacher_sets/'+$scope.teacher_set_id+'/holds/'+resp.hold.access_key+'.json', $scope.holdsUrl).success(function(hold) {
          if ( hold.redirect_to ) {
            window.location = hold.redirect_to;
          } else {
            $location.path('/holds/'+resp.hold.access_key).search({});
          }
        });
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
