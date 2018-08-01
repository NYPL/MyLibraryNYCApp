(function() {
  var Helpers;

  Helpers = (function() {
    function Helpers(options) {
      this.options = options;
      this.init();
    }

    Helpers.prototype.init = function(){
      this.initCollapsibles();
    };

    Helpers.prototype.initCollapsibles = function(){
      $('.collapsible-link').on('click',function(e){
        var href = $(this).attr('href'),
            $target = $(href);
        $target.toggleClass('on');
      });
    };

    return Helpers;

  })();

  $(function() {
    return new Helpers({});
  });

}).call(this);
