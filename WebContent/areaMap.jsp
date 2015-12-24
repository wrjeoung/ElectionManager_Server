<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
<script type="text/javascript" src="https://sgisapi.kostat.go.kr/OpenAPI3/auth/javascriptAuth?consumer_key=f59544edd2be4a4f91dd"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js" charset="utf-8"></script>

<script type="text/javascript">
var map = "";
var geolayers = "";
var geoObjs = "";

function drawMap(data)
{
    console.log("data = "+data);

	var res = JSON.parse(data);
	
	if(map != "")
		map.remove();
	
    map = sop.map("map", {
        scale: false, // 축적 컨트롤
        panControl: false, // 지도이동 컨트롤
        zoomSliderControl: true, //줌 컨트롤
        measureControl: false, // 측정 컨트롤 (면적, 길이)
        attributionControl: false // 지도속성 컨트롤
       });
	    
    var center_point = res.CENTER;
   
	console.log("center_point.x = "+center_point.x);
	console.log("center_point.y = "+center_point.y);
 
    var jsonArray = res.GEODATA;
    var obj_count = jsonArray.length;
    var zoomLevel = res.ZOOMLEVEL;
    
    geolayers = new Array(obj_count);
    geoObjs = new Array(obj_count);
    
    map.setView(sop.utmk(center_point.x, center_point.y), zoomLevel); // 지도 중심좌표로 뷰 설정

    for(var i = 0; i<obj_count;i++) {
    	var geoData = jsonArray[i];
    	var selected = geoData.selected;
    	var fillcolor = selected == true ? "#565656" : "#ffffff";
        //geoJson 객체 생성 및 옵션 설정
        geoObjs[i] = sop.geoJson(geoData, {
            style: function () {
                return {
                    weight: 2,
                    opacity: 1,
                    color: "black",
                    fillColor : fillcolor,
                    dashArray: "3",
                    fillOpacity: 0.5
                };
            },
            onEachFeature: function (feature, layer) {
                layer.bindInfoWindow(feature.properties.Description);
            }
        });
        
        geolayers[i] = geoObjs[i].addTo(map);
		
        geoObjs[i].on('click', function (e) {
        	var layer = e.layer;
	    	var target = e.layer._path;
	    	var code = layer.feature.properties.Name;
	    	var des = layer.feature.properties.Description;
	    	
	    	console.log("code = "+code +" ,des = "+des);

	    	for(var i = 0; i<geolayers.length;i++) {
	    		if(layer._sop_id != geolayers[i]._sop_id-1) {
	    			geoObjs[i].setStyle(function () {
		                return {
		                    weight: 2,
		                    opacity: 1,
		                    color: "black",
		                    fillColor : "#ffffff",
		                    dashArray: "3",
		                    fillOpacity: 0.5
		                };
		            });
		    		map.removeLayer(geolayers[i]);
		    		map.addLayer(geolayers[i]);
	    		}
	    	}		    	
	    	d3.select(target).style("fill", "#565656");
	    	
	    	window.ElectionManager.funcCallSearchByJSParam(code);
		});
    }
    
    var point = res.POINT;
    if(point.x != 0.0 && point.y != 0.0) {
    	var options = {
                stroke: false,
                color: "red",
                weight : 3,
                opacity: 1,
                fillColor:"red",
                fillOpacity: 0.8
    		};
    	var circleMaker = sop.circleMarker(sop.utmk(point.x,point.y),options);
    	circleMaker.setRadius(5);
    	circleMaker.addTo(map);
    }
	
    map.on('zoomend', function (e) {
		
	});
    
    map.on('click', function (e) {
    	//alert("click");
		return;
	});
    
    map.on('dblclick', function (e) {
	  e.stopPropagation()
	});
	


}
</script>
    
    
<body>
<form name="form1" method="post" >

<div id="map" style="width: 100%; height: 100%"></div>

</form>
</body>
