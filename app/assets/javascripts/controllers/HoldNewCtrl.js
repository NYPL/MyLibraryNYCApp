'use strict';

app.controller('HoldNewCtrl', [ '$scope', '$routeParams', '$http', '$location', 'Angularytics',
  function($scope, $routeParams, $http, $location, Angularytics) {
    $scope.teacher_set_id = $routeParams.teacher_set_id;
    $scope.action_label = "Order This Set"; 
    $scope.formData = { original_path: $location.path() + '?' + $.param($routeParams) };
    $scope.busy = false;
    $scope.$location = $location;
    $scope.loaded = false;
    $scope.errorMessage = '';
    
    // Retrieve new hold / teacher set   
    $http.get('/holds/new.json?teacher_set_id='+$scope.teacher_set_id).success(function(data) {
      if ( data.redirect_to ) {
        window.location = data.redirect_to;
        return false;
      }
      $scope.ts = data.teacher_set;
      if ($scope.ts.availability == 'available') {
        $scope.action_label = "Order This Set"; 
      }
      $scope.loaded = true;
    });  

    // Retrieve current_user settings
    $scope.formData.settings = {};
    $http.get('/settings.json').success(function(settings) {      
      $scope.confirm_contact_info = !settings.alt_email || !settings.school;
      // Should we confirm contact info first?    
      if($scope.confirm_contact_info) {
        // Retrieve list of schools
        $http.get('/schools.json').success(function(data) {
          var schools = data.schools;
          $scope.schools = [{name:'Select One'}].concat(schools);
          if (settings.school) $scope.formData.settings.school_id = settings.school.id;
          $scope.formData.settings.alt_email = settings.contact_email;
        });
      // Otherwise, just submit the form
      } else {
        window.location = '/teacher_sets/' + $scope.teacher_set_id
        $scope.submitForm();
      }
    });

    // Submit new hold
    $scope.submitForm = function() {
      $scope.busy = true;
      $http.post('/teacher_sets/'+$scope.teacher_set_id+'/holds.json', $scope.formData).success(function(resp) {
        if ( resp.redirect_to ) {
          window.location = resp.redirect_to;
        } else {
          Angularytics.trackEvent('Teacher Sets', 'placed reservation', $scope.teacher_set_id);          
          $location.path('/holds/'+resp.hold.access_key).search({new_order: 1}); 
        }
        $scope.busy = false;       
      }).error(function(resp){
         $scope.errorMessage = resp.error
      });      
    }
  }
]);
