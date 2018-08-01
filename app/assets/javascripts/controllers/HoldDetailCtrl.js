'use strict';

app.controller('HoldDetailCtrl', [ '$scope', '$routeParams', '$http', '$location', 'Angularytics',
    function($scope, $routeParams, $http, $location, Angularytics) {
    $scope.hold_id = $routeParams.id;
    $scope.action_label = "Cancel My Order";
    $scope.formData = { original_path: $location.path() };  
    $scope.formData.hold = {};
    $scope.$location = $location;
    $scope.loaded = false;

    // Retrieve hold
    $http.get('/holds/'+$scope.hold_id+'.json?' + $.param($scope.formData)).success(function(data) {
      if ( data.redirect_to ) {
        window.location = data.redirect_to;
        return false;
      }
      
      $scope.hold = data.hold;
      $scope.ts = data.teacher_set;
      $scope.ts.teacher_set_notes = data.teacher_set_notes;

      // humanize dates to display
      $scope.hold.created_at_pretty = Date.create($scope.hold.created_at).format('{Weekday}, {Month} {dd}, {yyyy}');
      
      $scope.loaded = true;

    });

    // Update hold
    $scope.submitForm = function(){
      $http.put('/teacher_sets/'+$scope.ts.id+'/holds/'+$scope.hold.access_key+'.json', $scope.formData).success(function(hold) {        

        Angularytics.trackEvent('Teacher Sets', 'cancelled reservation', $scope.teacher_set_id)

        if ( hold.redirect_to ) {
          window.location = hold.redirect_to;
        } else {
          $location.path('/holds/'+hold.access_key).search({}); 
        }
      });
    };
    
    if ($routeParams.new_order) {
      $scope.tracking_url = _et.getTrackingUrl("Order Page", "<data amt=\"1\" unit=\"Orders\" accumulate=\"true\" />");
    }     
    
  }
]);
