'use strict';

app.controller('HoldCancelCtrl', [ '$scope', '$routeParams', '$http', '$location',
  function($scope, $routeParams, $http, $location) {
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
      if (data.hold.status == "cancelled"){
        if (data.teacher_set.title == null){
           $('#cancel-text').html("This order is already cancelled.")
        } else {
           $('#cancel-text').html("This current order of <strong>" + data.teacher_set.title + "</strong> has already beeen cancelled!")
        }
        $('#cancel-button').prop("disabled",true);
        $('#cancel-button').css('background-color', 'grey')
      }

      $scope.hold = data.hold;
      $scope.ts = data.teacher_set;
      $scope.ts.teacher_set_notes = data.teacher_set_notes;

      // humanize dates to display
      $scope.hold.created_at_pretty = Date.create($scope.hold.created_at).format('{Weekday}, {Month} {dd}, {yyyy}');

      // Init form data to target date
      $scope.formData.hold_change = {};
      $scope.formData.hold_change.comment = '';
      $scope.formData.hold_change.status = 'cancelled';

      $scope.loaded = true;
    });

    // Update hold
    $scope.submitForm = function(){
      $http.put('/teacher_sets/'+$scope.ts.id+'/holds/'+$scope.hold.access_key+'.json', $scope.formData).success(function(data) {
        var hold = data.hold;
        if ( hold.redirect_to ) {
          window.location = hold.redirect_to;
        } else {
          $location.path('/holds/'+hold.access_key).search({});
        }
      });
    };

  }
]);
