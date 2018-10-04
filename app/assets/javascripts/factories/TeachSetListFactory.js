'use strict';

app.factory('TeachSetListFactory', [ '$http', '$routeParams', '$location',
  function($http, $routeParams, $location) {
    var TeachSetListFactory = function() {
      localStorage.clear();
      this.items = [];
      this.facets = [];
      this.busy = false; // whether service is *actually* busy
      this.showBusy = false; // whether or not to show that we are busy
      this.busyTimer = null;
      this.busyTimerSeconds = 1000; // show busy messaging after x milliseconds
      this.page = 0;
      this.queryParams = $routeParams || {};

      this.active_keyword = this.queryParams.keyword;

      this.queryString = this.parameterize(this.queryParams);
      this.facetString = this.getFacetString(this.queryParams);
    };

    TeachSetListFactory.prototype.cancelBusyMessage = function(){
      if (this.busyTimer) clearTimeout(this.busyTimer);
      this.showBusy = false;
    };

    TeachSetListFactory.prototype.doFilter = function(params) {
      if (this.busy) return;
      this.resetPages();
      this.doRequest(params);
    };

    TeachSetListFactory.prototype.doGrades = function(grade_begin, grade_end){
      if (this.busy) return;
      this.resetPages();
      this.queryParams.grade_begin = grade_begin;
      this.queryParams.grade_end = grade_end;
      $location.path('/teacher_sets').search(this.queryParams);
      this.doRequest(this.queryParams);
    };

    TeachSetListFactory.prototype.doLexiles = function(lexile_begin, lexile_end){
      if (this.busy) return;
      this.resetPages();
      this.queryParams.lexile_begin = lexile_begin;
      this.queryParams.lexile_end = lexile_end;
      $location.path('/teacher_sets').search(this.queryParams);
      this.doRequest(this.queryParams);
    };

    TeachSetListFactory.prototype.doRequest = function(params){
      if (this.busy) return;
      if (this.lastTeacherSetCount == 0) return;
      params = params || this.queryParams;
      var that = this;
      this.busy = true;
      this.queueBusyMessage();
      this.queryParams = params;
      this.queryString = this.parameterize(params);
      this.facetString = this.getFacetString(params);
      $http.get('/teacher_sets.json?'+this.queryString).success(function(data) {
        // append results to current results
        $.merge(that.items, data.teacher_sets);
        // only load facets once
        if (!that.facets.length) {
          that.facets = data.facets;
        // only refresh facets on first page
        } else if (that.page <= 1) {
          that.repaintFacets(data.facets);
        }
        that.busy = false;
        that.cancelBusyMessage();
        that.lastTeacherSetCount = data.teacher_sets.length

      });
    };

    TeachSetListFactory.prototype.doSearch = function() {
      if (this.busy) return;

      this.resetPages();
      this.active_keyword = this.queryParams.keyword;

      if ( !this.queryParams.keyword.length ) {
        delete this.queryParams.keyword;
      }

      $location.path('/teacher_sets').search(this.queryParams);
      this.doRequest(this.queryParams);
    };

    TeachSetListFactory.prototype.getFacetString = function(params) {
      if ( params.page ) {
        delete params.page;
      }
      return this.parameterize(params);
    };

    TeachSetListFactory.prototype.nextPage = function() {
      if (this.busy) return;
      this.page++;
      this.queryParams.page = this.page;
      this.doRequest(this.queryParams);
    };

    TeachSetListFactory.prototype.parameterize = function(obj){
      return $.param(obj).replace(/%2B/g,'+');
    };

    TeachSetListFactory.prototype.queueBusyMessage = function(){
      var that = this;
      if ( this.queryParams.page > 1 ) {
        this.showBusy = true;
      // delay loading message on first page to avoid "flicker"
      } else {
        this.busyTimer = setTimeout(function(){
            that.showBusy = true;
        }, this.busyTimerSeconds );
      }

    };

    TeachSetListFactory.prototype.removeKeyword = function(){
      this.queryParams.keyword = '';
      this.doSearch();
    };

    TeachSetListFactory.prototype.repaintFacets = function(newFacets) {
      var that = this;

      $.each( this.facets, function( i, f ) {
        that.facets[i].items = newFacets[i].items;
      });

    };

    TeachSetListFactory.prototype.resetPages = function() {
      this.page = 1;
      this.items = [];
      if ( this.queryParams.page ) {
        delete this.queryParams.page;
      }
    };

    return TeachSetListFactory;
  }
]);
