<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script> 
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=574483b67abb142c145a976ae833a965"></script>
<script type="text/javascript" src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=aac462049f4200011230fdedcfbd6c15"></script>

<script type="text/javascript">

var gmap;
var markers = [];
var geocoder;
var centericon = [];
var servletUrl = "MapServlet";

function initialize() {
	$.ajax({ //직접입력하였을떄
	     type : "POST",
	     url : servletUrl,
	     data : "mode=haengjoungdong",     
	     success : function(data) {
	      var jsonArray = JSON.parse(data);
	      document.form1.haengjoungdong.options[0] = new Option("-----------선택-----------","-1");
	      for(var i = 0; i<jsonArray.length;i++)
		  {
	            var haengjoungdong = jsonArray[i].haengjoungdong;
	      		document.form1.haengjoungdong.options[i+1] = new Option(haengjoungdong,haengjoungdong);
		  }
	     },    
	     error : function() {
	      
	     },
	     ajaxError : function() {
	      
	     }    
	    });  
}

function setTupyogu()
{
	var target = document.getElementById("haengjoungdong");
	var haengjoungdong = target.options[target.selectedIndex].value;
	document.form1.tupyogu.options.length = 0;
	
	$.ajax({ //직접입력하였을떄
	     type : "POST",
	     url : servletUrl,
	     data : "mode=tupyogu&haengjoungdong="+haengjoungdong,     
	     success : function(data) {
	      var jsonArray = JSON.parse(data);
	      document.form1.tupyogu.options[0] = new Option("-----------선택-----------","-1");
	      for(var i = 0; i<jsonArray.length;i++)
		  {
	    	// 디코딩하여 변수에 담는다.
	            var tupyogu = jsonArray[i].tupyogu;
	      		//console.log("tupyogu = "+tupyogu);
	      		document.form1.tupyogu.options[i+1] = new Option(tupyogu,tupyogu);
		  }
	     },      
	    });

}

function setTong()
{
	var target = document.getElementById("haengjoungdong");
	var haengjoungdong = target.options[target.selectedIndex].value;
	//console.log("haengjoungdong = "+haengjoungdong);
	document.form1.tong.options.length = 0;
	
	
	$.ajax({ //직접입력하였을떄
	     type : "POST",
	     url : servletUrl,
	     data : "mode=tong&haengjoungdong="+haengjoungdong,     
	     success : function(data) {
	      var jsonArray = JSON.parse(data);
	      document.form1.tong.options[0] = new Option("-----------선택-----------","-1");
	      for(var i = 0; i<jsonArray.length;i++)
		  {
	    	// 디코딩하여 변수에 담는다.
	            var tong = jsonArray[i].tong;
	      		//console.log("tong = "+tong);
	      		document.form1.tong.options[i+1] = new Option(tong,tong);
		  }
	     },      
	    });

}



function changeHaengjoung(value)
{
	if(value == -1)
	{
		return;
	}
	document.getElementById("tupyogu").disabled=false;
	document.getElementById("tong").disabled=false;
	setTupyogu();
	setTong();
}

function changeTupyogu(value)
{
	if(value == -1)
	{
		return;	
	}
	document.getElementById("tong").disabled=true;
}

function changeTong(value)
{
	if(value == -1)
	{
		return;	
	}
	document.getElementById("tupyogu").disabled=true;
}

function mapSearch()
{
	var param = "";
	var target = document.getElementById("haengjoungdong");
	var haengjoungdong = target.options[target.selectedIndex].value;
	target = document.getElementById("tupyogu");
	var tupyogu = target.options[target.selectedIndex].value;
	target = document.getElementById("tong");
	var tong = target.options[target.selectedIndex].value;
	target = document.getElementById("mapKind");
	var mapKind = target.options[target.selectedIndex].value;
	
	param += "mode=search&haengjoungdong="+haengjoungdong;
	param += tupyogu == -1 ? "&param=tong&value="+tong : "&param=tupyogu&value="+tupyogu;
	param += "&mapKind="+mapKind;
	
	$.post(servletUrl, param,function(data){
		var result = JSON.parse(data);
		var jsonArray = result.array;
		var center_point = result.center;
		var count = jsonArray.length;
		var center;
		var cityCircle;
		var map;
				
		console.log("total count ="+count);
		
		document.getElementById('map_canvas').innerHTML = "";
		
		if(mapKind == 0) // google
		{
			center = new google.maps.LatLng(jsonArray[0].location.y,jsonArray[0].location.x);
			
			var myOptions = {
					zoom : 15,
					center: center,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				};
				
			map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
			
			
			console.log("center_point.x = "+center_point.x);
			console.log("center_point.y = "+center_point.y);
			
			for(var i = 0; i<jsonArray.length;i++)
			{
				var x = jsonArray[i].location.x;
				var y = jsonArray[i].location.y;
				
				var populationOptions = {
					      strokeColor: '#0000FF',
					      strokeOpacity: 0.8,
					      fillColor: '#0000FF',
					      fillOpacity: 0.1,
					      map: map,
					      center: new google.maps.LatLng(y,x),
					      radius: 5
					    };
				// Add the circle for this city to the map.
			    cityCircle = new google.maps.Circle(populationOptions);
	
				console.log("x = "+x);
				console.log("y = "+y);
			}
		}
		else if(mapKind == 1) // naver
		{
			center = new nhn.api.map.LatLng(jsonArray[0].location.y,jsonArray[0].location.x);
			nhn.api.map.setDefaultPoint('LatLng'); // - 지도에서 기본적으로 사용하는 좌표계를 설정합니다.
			
			map = new nhn.api.map.Map(document.getElementById('map_canvas') ,{
                point : center, // - 지도의 중심점을 나타냅니다.
                zoom :10, // - 지도의 초기 레벨을 나타냅니다.
                enableWheelZoom : true, // - 마우스 휠 줌으로 지도의 레벨을 조정할 수 있는지 없는지 설정합니다. 
                enableDragPan : true, // - 마우스 드래그를 통해 지도를 패닝할 수 있는지 없는지 설정합니다.
                enableDblClickZoom : false, // - 마우스 왼쪽 버튼 더블클릭을 통해, 
                mapMode : 0, // - 어떤 지도를 사용할 지 나타냅니다. 0은 일반, 1은 겹침지도, 2는 위성지도입니다.
                activateTrafficMap : false, // - 실시간 교통 지도를 사용할지 하지 않을 지의 여부를 나타냅니다.
                activateBicycleMap : false, // - 자전거 지도를 사용할 지 하지 않을 지의 여부를 나타냅니다.
                //minMaxLevel : [ 1, 14 ], // - 지도의 최대 최소 레벨을 설정합니다. 
                //size : new nhn.api.map.Size(800, 600), // - 지도의 크기를 설정합니다.
                detectCoveredMarker : true
        	});
			
			console.log("center_point.x = "+center_point.x);
			console.log("center_point.y = "+center_point.y);
			
			for(var i = 0; i<jsonArray.length;i++)
			{

				var oPoint = new nhn.api.map.LatLng(jsonArray[i].location.y, jsonArray[i].location.x);
				var circle = new nhn.api.map.Circle({
		            strokeColor : "red",
		            strokeOpacity : 1,
		            strokeWidth : 1,
		            fillColor : "blue",
		            fillOpacity : 0.5
			    });
			    var radius = 5; // - radius의 단위는 meter
			    circle.setCenterPoint(oPoint); // - circle 의 중심점을 지정한다.
			    //circle.setCenterPoint(oPoint1); // - circle 의 중심점을 지정한다.
			    circle.setRadius(radius); // - circle 의 반지름을 지정하며 단위는 meter이다.
			    circle.setStyle("strokeColor", "blue"); // - 선의 색깔을 지정함.
			    circle.setStyle("strokeWidth", 5); // - 선의 두께를 지정함.
			    circle.setStyle("strokeOpacity", 1); // - 선의 투명도를 지정함.
			    circle.setStyle("fillColor", "none"); // - 채우기 색상. none 이면 투명하게 된다.
			    
			    map.addOverlay(circle);
			}
		}
		else if(mapKind == 2) // daum
		{
			center = new daum.maps.LatLng(jsonArray[0].location.y,jsonArray[0].location.x); // 지도의 중심좌표
			
			mapOption = {
					center: center,
					level : 4 // 지도의 확대 레벨
			};
			
			map = new daum.maps.Map(document.getElementById("map_canvas"), mapOption); // 지도를 생성합니다.
			
			// 지도에 표시할 원을 생성합니다.
			var circle = new Array(jsonArray.length);
			
			for(var i = 0; i<jsonArray.length;i++)
			{
				circle[i] = new daum.maps.Circle({
				    center : new daum.maps.LatLng(jsonArray[i].location.y, jsonArray[i].location.x),  // 원의 중심좌표 입니다 
				    radius: 5, // 미터 단위의 원의 반지름입니다 
				    strokeWeight: 10, // 선의 두께입니다 
				    strokeColor: '#0000FF', // 선의 색깔입니다
				    strokeOpacity: 0, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
				    strokeStyle: 'solid', // 선의 스타일 입니다
				    fillColor: '#0000FF', // 채우기 색깔입니다
				    fillOpacity: 0.7  // 채우기 불투명도 입니다   
				});
				 
				circle[i].setMap(map); 
			}
		}
    });

}

function insertExcel()
{
	var path = document.getElementById("attachFile").value;
	
	if(!path) {
		alert("파일경로를 입력하시오.");
		return;
	}
	
	var formData = new FormData();
	formData.append("attachFile",$("input[name=attachFile]")[0].files[0]);
	
	allButtonDisable();
	var url = servletUrl+"?mode=insertExcel";
	
	$.ajax({ //직접입력하였을떄
	     type : "POST",
	     url : url,
         dataType: "text",
         data: formData,
         // cache: false,
         processData: false,
         contentType: false,     
	     success : function(data) {
	 		allButtonEnable();
			var result = JSON.parse(data);
			if(result.status=="OK") {
				alert("엑셀 업로드 성공");
			} else if(result.status=="INVALID") {
				alert("파일이 없거나 지원하지 않는 확장자입니다. ");
			} else if(result.status=='ERROR') {
				alert("에러 발생 ");
			}
	     },      
	    });
}

function convertToGoogleCoord()
{
	var param = "mode=convert&target=google";
	allButtonDisable();
	
	$.post(servletUrl, param,function(data){
		allButtonEnable();
		var result = JSON.parse(data);
		if(result.status=="OK") {
			alert("구글좌표변환 성공");
		} else if(result.status=="OVER_QUERY_LIMIT") {
			alert("일일 사용량 초과 ");
		}
	});
}

function convertToNaverCoord()
{
	var param = "mode=convert&target=naver";
	allButtonDisable();
	
	$.post(servletUrl, param,function(data){
		allButtonEnable();
		var result = JSON.parse(data);
		if(result.status=="OK") {
			alert("네이버좌표변환 성공");
		} 
	});
}

function convertToDaumCoord()
{
	var param = "mode=convert&target=daum";
	allButtonDisable();
	
	$.post(servletUrl, param,function(data){
		allButtonEnable();
		var result = JSON.parse(data);
		if(result.status=="OK") {
			alert("다음좌표변환 성공");
		} 
	});
}

function allButtonEnable()
{
	document.getElementById("insertExcelData").disabled=false;
	document.getElementById("mapKind").disabled=false;
	document.getElementById("haengjoungdong").disabled=false;
	document.getElementById("tupyogu").disabled=false;
	document.getElementById("tong").disabled=false;
	document.getElementById("search").disabled=false;
	document.getElementById("googleCoord").disabled=false;
	document.getElementById("naverCoord").disabled=false;
	document.getElementById("daumCoord").disabled=false;
}

function allButtonDisable()
{
	document.getElementById("insertExcelData").disabled=true;
	document.getElementById("mapKind").disabled=true;
	document.getElementById("haengjoungdong").disabled=true;
	document.getElementById("tupyogu").disabled=true;
	document.getElementById("tong").disabled=true;
	document.getElementById("search").disabled=true;
	document.getElementById("googleCoord").disabled=true;
	document.getElementById("naverCoord").disabled=true;
	document.getElementById("daumCoord").disabled=true;
}

</script>


<body onload="initialize()">
<form name="form1" method="post">

<div style="text-align:center;">
<input type="file" name="attachFile" id="attachFile">
<input type="button" id="insertExcelData" onclick="insertExcel();" value="엑셀정보추가" >
&nbsp;&nbsp;

<select id="mapKind" name="mapKind">
	<option value="0">구글</option>
	<option value="1">네이버</option>
	<option value="2">다음</option>
</select>

<select id="haengjoungdong" name="haengjoungdong"  onchange="changeHaengjoung(this.value)">
</select>
<select id="tupyogu" name="tupyogu" onchange="changeTupyogu(this.value)" >
</select>
<select id="tong" name="tong" onchange="changeTong(this.value)">
</select>

<input type="button" id="search" onclick="mapSearch();" style="width:20%" value="검색" >

<input type="button" id="googleCoord" onclick="convertToGoogleCoord();" value="구글좌표변환" >
<input type="button" id="naverCoord" onclick="convertToNaverCoord();" value="네이버좌표변환" >
<input type="button" id="daumCoord" onclick="convertToDaumCoord();" value="다음좌표변환" >

</div>
<div id="map_canvas" style="width: 100%; height: 100%"></div>

</form>
</body>