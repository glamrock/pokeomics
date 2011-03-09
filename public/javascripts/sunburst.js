var nativeCanvasSupport;

(function() {
	var typeOfCanvas = typeof HTMLCanvasElement;
	nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function');
})();

var Colors = {
	// Maps node name to fillStyle
	specific: {
	  'Normal': '#a6a677',
	  'Fire': '#f08030',
	  'Water': '#6294ff',
	  'Electric': '#ffdd28',
	  'Grass': '#76c84e',
	  'Ice': '#98d8d8',
	  'Fighting': '#c03028',
	  'Poison': '#a03fa0',
	  'Ground': '#e2c166',
	  'Flying': '#b398ff',
	  'Psychic': '#ff548f',
	  'Bug': '#a8b820',
	  'Rock': '#b8a038',
	  'Ghost': '#6a5584',
	  'Dragon': '#7137ff',
	  'Dark': '#705848',
	  'Steel': '#b8b8d0',

	  'Plant': 'Grass',
	  'Humanshape': 'Fighting',
	  'Mineral': 'Steel',
	  'Fairy': 'Psychic',
	  'No Eggs': '#4e4e58',
	  'Monster': '#bd1010',
	  'Indeterminate': '#7b7b58',

	  'HP': 'Normal',
	  'Attack': 'Fighting',
	  'Defense': 'Steel',
	  'Special Attack': 'Psychic',
	  'Special Defense': 'Grass',
	  'Speed': 'Electric'
	},

	generic: ["#416D9C", "#70A35E", "#EBB056", "#83548B", "#909291", "#557EAA"],
	genericIndex: -1,

	// Retrieve the next generic color in the sequence.
	nextGeneric: function() {
		if (this.genericIndex >= this.generics.length) this.genericIndex = 0;
		return this.generics[colindex];
	},

	// Retrieve a matching color if available; else the next generic one.
	find: function(name) {
		var color;

		if (this.specific[name]) { 
			def = this.specific[name];
		} else {
			var lname = name.toLowerCase();
			for (var key in this.specific) {
				var lkey = key.toLowerCase();
				if (lkey.indexOf(lname) !== -1 || lname.indexOf(lkey) !== -1) {
					def = this.specific[key];
				}
			}
		}

		if (def) {
			if (def.indexOf('#') === -1) { // Internal reference
				return this.find(def);
			} else {
				return def;
			}
		} else {
			return this.nextColor();
		}
	}
}

function error(err) {
	$('#infovis').hide();
	$('#credits').hide();

	var errorDiv = $("#error");
	errorDiv.text(err);
	errorDiv.css('top', (window.innerHeight/2)-errorDiv.height());
	errorDiv.fadeIn();
}

function getOuterNodePos(node, levelDistance) {
	var polar = node.pos.clone();
	polar.rho += levelDistance;
	return polar.getc();
}

function midway(theta1, theta2) {
}

$jit.Sunburst.Plot.EdgeTypes.implement({
	'hyperarrow_external': {
		'render': function(adj, canvas) {
			var ldist = this.config.levelDistance;
			var ctx = canvas.getCtx();

			// Hyperline
			var from = getOuterNodePos(adj.nodeFrom, ldist),
				to = getOuterNodePos(adj.nodeTo, ldist),
				dim = Math.max(from.norm(), to.norm());
			//this.edgeHelper.hyperline.render(from.$scale(1/dim), to.$scale(1/dim), dim, canvas);

			var control = adj.nodeTo.pos.clone();
			control.theta = midway(adj.nodeFrom.pos.theta, adj.nodeTo.pos.theta);
			control.rho += ldist + ldist;
			window.control = control;
			cont = control.getc();

			ctx.beginPath();
			ctx.moveTo(from.x, from.y);
			ctx.quadraticCurveTo(cont.x, cont.y, to.x, to.y);
			ctx.stroke();


			// Arrow
			var polar = adj.nodeTo.pos.clone();
			polar.rho += ldist*2;
			var from = polar.getc();
			

			
			var dim = adj.getData('dim'),
				direction = adj.data.$direction,
				swap = (direction && direction.length>1 && direction[0] != adj.nodeFrom.id);

			// invert edge direction
			if (swap) {
			  var tmp = from;
			  from = to;
			  to = tmp;
			}
			var vect = new $jit.Complex(to.x - from.x, to.y - from.y);
			vect.$scale(dim / vect.norm());
			var intermediatePoint = new $jit.Complex(to.x - vect.x, to.y - vect.y),
				normal = new $jit.Complex(-vect.y / 2, vect.x / 2),
				v1 = intermediatePoint.add(normal),
				v2 = intermediatePoint.$add(normal.$scale(-1));

			/*ctx.beginPath();
			ctx.moveTo(from.x, from.y);
			ctx.lineTo(to.x, to.y);
			ctx.stroke();*/
			ctx.beginPath();
			ctx.moveTo(v1.x, v1.y);
			ctx.lineTo(v2.x, v2.y);
			ctx.lineTo(to.x, to.y);
			ctx.closePath();
			ctx.fill();
		},
		'contains': $jit.util.lambda(false)
    },

	'hyperarrow_internal': {
		'render': function(adj, canvas) {
			var ctx = canvas.getCtx();

			// Hyperline
			var from = getOuterNodePos(adj.nodeFrom, this.config.levelDistance),
				to = getOuterNodePos(adj.nodeTo, this.config.levelDistance),
				dim = Math.max(from.norm(), to.norm());
			//this.edgeHelper.hyperline.render(from.$scale(1/dim), to.$scale(1/dim), dim, canvas);

			ctx.beginPath();
			ctx.moveTo(from.x, from.y);
			ctx.quadraticCurveTo(0, 0, to.x, to.y);
			ctx.stroke();




			// Arrow
			var from = { x: 0, y : 0}//adj.nodeFrom.pos.getc(true),
				to = adj.nodeTo.pos.getc(true),
				dim = adj.getData('dim'),
				direction = adj.data.$direction,
				swap = (direction && direction.length>1 && direction[0] != adj.nodeFrom.id);

			// invert edge direction
			if (swap) {
			  var tmp = from;
			  from = to;
			  to = tmp;
			}
			var vect = new $jit.Complex(to.x - from.x, to.y - from.y);
			vect.$scale(dim / vect.norm());
			var intermediatePoint = new $jit.Complex(to.x - vect.x, to.y - vect.y),
				normal = new $jit.Complex(-vect.y / 2, vect.x / 2),
				v1 = intermediatePoint.add(normal),
				v2 = intermediatePoint.$add(normal.$scale(-1));

			/*ctx.beginPath();
			ctx.moveTo(from.x, from.y);
			ctx.lineTo(to.x, to.y);
			ctx.stroke();*/
			ctx.beginPath();
			ctx.moveTo(v1.x, v1.y);
			ctx.lineTo(v2.x, v2.y);
			ctx.lineTo(to.x, to.y);
			ctx.closePath();
			ctx.fill();
		},
		'contains': $jit.util.lambda(false)
    }
});

function drawSunburst(realOpts) {
	if (!nativeCanvasSupport) {
		return error("This software requires native support for the HTML5 canvas. Please use a modern browser :)");
	}

	var opts = $.extend({
		title: '',
		total: null,
		totals: {},
		connections: {}
	}, realOpts);

	for (var key in realOpts) {
		opts[key] = realOpts[key];
	}

	var json = [{ 
		data: { "$type": "none" },
		id: "Source",
		name: opts.title,
		adjacencies: []
	}];

	if (!opts.total) {
		var total = 0;

		for (var client in opts.totals) {
			total += parseInt(opts.totals[client]);
		}

		opts.total = total;
	}

	for (var name in opts.totals) {
		var percent = ((opts.totals[name]/opts.total)*100).toFixed();

		var node = { 
			"children": [], 
			"data": {
				"$angularWidth": percent,
				"coverage": percent,
				"total": opts.totals[name],
				"$color": Colors.find(name),
				//"$type": "none"
			},
			"name": name,
			"id": name,
			"adjacencies": opts.connections[name]
		}

		json.push(node);
		json[0].adjacencies.push(name);
	}

	var sb = new $jit.Sunburst({
		injectInto: 'infovis',
		levelDistance: 150,
		flatLabels: true,
		labelOffset: 8,
		hoveredColor: '#fff',
		Node: {
		  overridable: true,
		  type: 'gradient-multipie',
		  alpha: 0
		},
		Edge: {
		  overridable: true,
		  type: 'none',
		},
		Label: {
		  type: 'Native',
		},
		Tips: {
		  enable: true,
		  onShow: function(tip, node) {
			var html = "<div class=\"tip-title\">" + node.name + "</div>"; 
			var data = node.data;
			if ("total" in data) {
				html += "<div><strong>Total:</strong> " + data.total + "</div>";
			}
			if ("coverage" in data) {
				html += "<div><strong>Proportion:</strong> " + data.coverage + "%</div>";
			}
			tip.innerHTML = html;
		  }
		},
		Events: {
		  enable: true,
		  onMouseEnter: function(node) {
			node.setData('border', { strokeStyle: '#ffffff', lineWidth: 2 });
			sb.plot();
		  },
		  onMouseLeave: function(node) {
			node.setData('border', false);
			sb.plot();
		  },
		  onClick: function(node) {
			sb.tips.hide();
			if (node) {
				sb.rotate(node, 'animate', {
				  duration: 1000,
				  transition: $jit.Trans.Quart.easeInOut
				});
			}
		  },
		},
	});

	sb.loadJSON(json);
	sb.refresh();

	// Animated rotate-y fade in!

	sb.graph.eachNode(function(node) {
		node.setData('alpha', 1, 'end');
		if (node.pos.theta > Math.PI) {
			node.pos.theta += Math.PI*1.5;
		} else {
			node.pos.theta -= Math.PI*1.5;
		}
	});

	sb.fx.animate({
		modes: ['node-property:alpha', 'polar'],
		duration: 1000,
		transition: $jit.Trans.Circ.easeOut
	});
}

