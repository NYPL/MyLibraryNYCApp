'use strict';

app.controller('TeacherSetDetailCtrl', ['$scope', '$routeParams', '$http', '$location', 'Angularytics',
  function($scope, $routeParams, $http, $location, Angularytics) {
    $scope.teacher_set_id = $routeParams.id;
    $scope.moreList = false;
    $scope.formData = { original_path: $location.path() + '?' + $.param($routeParams) };
    $scope.$location = $location;
    $scope.errorMessage = '';

    $scope.busy = false;
    $scope.loaded = false;

    $http.get('/teacher_sets/'+$scope.teacher_set_id+'.json').success(function(data) {
      $scope.ts = data.teacher_set;
      $scope.is_available = (data.teacher_set.availability=="available");
      $scope.active_hold = data.teacher_set.active_hold;
      $scope.ts.teacher_set_notes = data.teacher_set.teacher_set_notes
      $scope.ts.books = data.teacher_set.books
      $scope.user = data.teacher_set.user
      $scope.loaded = true;

    });
    
    $scope.autoReserve = function() {
      if ($scope.busy) return;
      $scope.busy = true;
      Angularytics.trackEvent('Teacher Sets', 'clicked reserve', $scope.teacher_set_id);
      $http.post('/teacher_sets/'+$scope.teacher_set_id+'/holds.json', $scope.formData).success(function(resp) {
        if ( resp.redirect_to ) {
          window.location = resp.redirect_to;
        } else {
          Angularytics.trackEvent('Teacher Sets', 'placed reservation', $scope.teacher_set_id);
          $location.path('/holds/'+resp.hold.access_key).search({new_order: 1});
        }
        $scope.busy = false;       

        Angularytics.trackEvent('Teacher Sets', 'placed reservation', $scope.teacher_set_id)
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
    
    // Angularytics.trackEvent([category], [action], [label], [val])
    Angularytics.trackEvent('Teacher Sets', 'view', $scope.teacher_set_id);
    
    // Exacttarget: Track Page
    $scope.tracking_url = _et.getTrackingUrl("Teacher Set Page", "<data amt=\"1\" unit=\"Views\" accumulate=\"true\" />");
  }
]);
