Array.prototype.sample = function() {
  return this[Math.round(Math.random()*(this.length-1))];
}

Array.prototype.clone = function() {
  return this.slice();
}

// Cache of path: Image
var imgCache = {};

var PokePet = function(id, space) {
  var me = {};

  me.space = space; // Space associated with this sprite
  me.id = id; // National Pokédex ID number
  me.form = null; // For multiform Pokémon only.

  me.x = 0; // X pos on canvas
  me.y = 0; // Y pos on canvas

  var orientations = ['up', 'down', 'left', 'right'];

  me.bobbleState = 0; // Frame index for repeated animation
  me.orientation = 'down'; // Which way the sprite is facing
  me.speed = 3; // How many pixels to move per update

  me.walking = true; // Are we in motion?
  me.redirectChance = 0.02; // Chance of changing orientations
  me.stopChance = 0.01; // Chance of stopping to look at player
  me.startChance = 0.05; // Chance of resuming motion

  // Change orientation to a random direction
  function faceRandom() {
    var otherOris = orientations.clone();
    otherOris.splice(otherOris.indexOf(me.orientation), 1);
    me.orientation = otherOris.sample();
  }

  function walkStep() {
    var inc = me.speed;
    var canvas = me.space.canvas;
    var rand = Math.random();

    if (rand < me.redirectChance) {
      faceRandom();
    }

    if (me.y + getFrame().height >= canvas.height)
      me.orientation = 'up';
    else if (me.y <= 0)
      me.orientation = 'down';
    else if (me.x + getFrame().width >= canvas.width)
      me.orientation = 'left';
    else if (me.x < 0)
      me.orientation = 'right';

    if (me.orientation == 'up')
      me.y -= inc;
    else if (me.orientation == 'down') 
      me.y += inc;
    else if (me.orientation == 'left')
      me.x -= inc;
    else if (me.orientation == 'right')
      me.x += inc;
  }

  function bobble() {
    me.bobbleState = (me.bobbleState == 1 ? 0 : 1);
  }

  function update() {
    if (me.walking) {
      bobble();
      walkStep();    
    }

    if (me.walking && Math.random() < me.stopChance) {
      me.walking = false;
      me.orientation = 'down';
    } else if (!me.walking && Math.random() < me.startChance) {
      me.walking = true;
      faceRandom();
    }

  }

  // Generates the URL for the current frame
  function getFramePath() {
    return "/images/overworld/"
            + (me.shiny ? 'shiny/' : '')
            + me.orientation + '/'
            + (me.bobbleState == 0 ? '' : 'frame2/')
            + me.id
            + (me.form ? '-' + me.form : '')
            + ".png";
  }

  // Retrieves an Image object for the current frame (download or from cache)
  function getFrame() {
    var path = getFramePath();

    if (!imgCache[path]) {
      var img = new Image();
      img.src = path;
      imgCache[path] = img;
    }

    return imgCache[path];
  }

  // Draw the sprite onto a canvas context
  function draw(ctx) {
    var frame = getFrame();
    ctx.drawImage(frame, me.x, me.y, frame.width, frame.height);
  }

  return $.extend(me, {
    update: update,
    draw: draw,
  });

}
  

var Space = function(canvas) {
  var me = {};

  me.canvas = canvas;
  me.context = canvas.getContext('2d');
  me.redrawDelay = 50; // Milliseconds between redraws
  me.redrawCount = 0; // How many times we've redrawn
  me.sprites = []; // Our itty-bitty sprites!

  me.sprites.push(new PokePet(493, me));
  me.sprites.push(new PokePet(46, me));

  // Update and redraw all space contents
  function redraw() {
    var ctx = me.context;
    
    ctx.globalCompositeOperation = 'destination-over';
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    me.sprites.forEach(function(sprite) {
      sprite.update();
      sprite.draw(ctx);
    }); 

    me.redrawCount++;
  }

  function init() {
    //canvas.width = $(document).width();
    //canvas.height = $(document).height();

    setInterval(redraw, me.redrawDelay);
  }

  return $.extend(me, {
    init: init,
  });
}
