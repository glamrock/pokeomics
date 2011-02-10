/**
 * Image preloader. PokeImg.spriteForms must be set elsewhere for this to work.
 */
var PokeImg = new function() {
  var me = {};

  me.cache = {};
  me.loaded = 0;

  me.getFramePathCustom = function(opts) {
    defaultOpts = {
      orientation: 'down',
      frameState: 0,
      form: 1,
      shiny: false
    }

    for (var opt in defaultOpts) {
      if (opts[opt] === undefined) {
        opts[opt] = defaultOpts[opt];
      }
    }
    
    return "/images/overworld/" + (opts.shiny ? 'shiny/' : '') + opts.orientation + "/" + (opts.frameState == 0 ? '' : 'frame2/') + opts.form + ".png"
  }

  me.getFrameCustom = function(opts) {
    var path = me.getFramePathCustom(opts);

    if (me.cache[path]) {
      return me.cache[path];
    } else {
      var img = new Image();
      img.onload = function() {
        me.loaded += 1;
        if (me.loaded == me.spriteForms.length) {
          $('body').trigger('imagesLoaded');
        }
      }
      img.src = path;
      me.cache[path] = img;
    }

  }

  return me;
}
