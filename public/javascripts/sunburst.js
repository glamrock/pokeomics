var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

function drawSunburst(totals) {
	var json = { 
		children: [],
		data: { "$type": "none" },
		id: "Source",
		name: Input.graphTitle.replace("Pokemon", "Pokémon")
	};

	//var colors = ["#416D9C", "#70A35E", "#EBB056", "#83548B", "#909291", "#557EAA"];
	//var colors = ["CE0F0F", "CE660F", "097C7C", "0CA50C", "9B2F2F", "9B602F", "1C5D5D", "267C26"];

    if (Input.total) {
        var total = Input.total;
    } else {
        var total = 0;

        for (var client in totals) {
            total += parseInt(totals[client]);
        }
    }

    var colors = ["#416D9C", "#70A35E", "#EBB056", "#83548B", "#909291", "#557EAA"];
    //var colors = ["CE0F0F", "CE660F", "097C7C", "0CA50C", "9B2F2F", "9B602F", "1C5D5D", "267C26"];
    var colindex = -1;

    function nextColor() {
        colindex += 1;
        if (colindex >= colors.length) colindex = 0;
        return colors[colindex];
    }

    var colormap = {
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
      'Indeterminate': '#7b7b58'
    };

    function findColor(name) {
        var lname = name.toLowerCase();
        for (var key in colormap) {
            var lkey = key.toLowerCase();
            if (lkey.indexOf(lname) !== -1 || lname.indexOf(lkey) !== -1) {
                if (colormap[key].indexOf('#') === -1) { // Internal reference
                    return findColor(colormap[key]);
                } else {
                    return colormap[key];
                }
            }
        }

        return nextColor();
    }

	for (var name in totals) {
		var percent = ((totals[name]/total)*100).toFixed();
	
		json.children.push({ 
			children: [], 
			data: {
				"$angularWidth": percent,
				coverage: percent,
                total: totals[name],
				"$color": findColor(name)
			},
			name: name,
			id: name
		});
	}

	window.sb = new $jit.Sunburst({
		//id container for the visualization
		injectInto: 'infovis',
		//Distance between levels
		levelDistance: 150,
		flatLabels: true,
		labelOffset: 8,
        hoveredColor: '#fff',
		//Change node and edge styles such as
		//color, width and dimensions.
		Node: {
		  overridable: true,
		  type: useGradients ? 'gradient-multipie' : 'multipie',
		  alpha: 0
		},
		//Select canvas labels
		//'HTML', 'SVG' and 'Native' are possible options
		Label: {
		  type: labelType,
		  
		},
		//Change styles when hovering and clicking nodes
		NodeStyles: {
		  enable: true,
		  type: 'Native',
		  /*stylesClick: {
			'color': '#860505'
		  },
		  stylesHover: {
            CanvasStyles: {
              'strokeStyle': '#5DBDBD'
            },
		  }*/
		},
		//Add tooltips
		Tips: {
		  enable: true,
		  onShow: function(tip, node) {
			var html = "<div class=\"tip-title\">" + node.name + "</div>"; 
			var data = node.data;
            if ("total" in data) {
				html += "<strong>Total:</strong> " + data.total + "<br/>";
            }
			if ("coverage" in data) {
				html += "<strong>Proportion:</strong> " + data.coverage + "%";
			}
			tip.innerHTML = html;
		  }
		},
		//implement event handlers
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
                sb.rotate(node, animate? 'animate' : 'replot', {
                  duration: 1000,
                  transition: $jit.Trans.Quart.easeInOut
                });
            }
		  },
		},
	});

	//load JSON data.
	sb.loadJSON(json);
	//compute positions and plot.
	sb.refresh();

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

$(function() {
    function redraw() {
        var width = window.innerWidth, height = window.innerHeight-$('#credits').height();
        $('#infovis *').remove();
		$('#infovis').css('width', window.innerWidth);
		$('#infovis').css('height', window.innerHeight-$('#credits').height());
        drawSunburst(Input.totals);
    }

    var timeout;
    $(window).resize(function() {
        clearTimeout(timeout);
        timeout = setTimeout(redraw, 100);
    });
    redraw();

});
