<?
/*  Time Based Text - web application
 *
 *  (C) Copyright 2006 - 2007  Angelo Failla <pallotron@freaknet.org>
 *
 * This source code is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Public License as published 
 * by the Free Software Foundation; either version 2 of the License,
 * or (at your option) any later version.
 *
 * This source code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * Please refer to the GNU Public License for more details.
 *
 * You should have received a copy of the GNU Public License along with
 * this source code; if not, write to:
 * Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>

	<title>TBT</title>
	<style type="text/css" media="all">
		@import "styles/default.css";
	</style>
	<script language="JavaScript" src="include/tbt-typewriter.js"></script>
	<script type="text/javascript" src="include/third_part/wz_dragdrop.js"></script>
	<script type="text/javascript" src="include/ajax-functions.js"></script>
	<script language="JavaScript" src="include/js-functions.js"></script>
	<script type="text/JavaScript">

		function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
		}
		var bgcolorlist=new Array("#000000","#333333","#666666","#003333",
				"#660000","#660033","#663333","#333300","#000033");

	</script>
	<script language="JavaScript" src="include/site_texts.inc.js"></script>
	 <!--[if lt IE 7.]>
	<script defer type="text/javascript" src="include/third_part/pngfix.js"></script>
	<![endif]-->
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>

<body class="mainbody">

<div id="menu">

	<table width="1010px" border="0" cellpadding="0" cellspacing="0" class="andalemono">
	<tr>
		<td align="left" valign="top" class="andalemono">
			--<u>F</u>ILE /
			<a href="http://tbt.dyne.org/?info=download">Download TBT software</a> / 
			<span onClick="MM_openBrWindow('upload.php','Upload','width=350,height=400')"><a href="#">Upload your TBT</a></span> / 
			<u>S</u>EARCH : <form style="display: inline;" name="search" method="post" action="<?=$_SERVER['PHP_SELF'];?>?action=search">
			<input type="text" name="search_pattern" value="<? if($_GET['action']!="") echo $_POST['search_pattern']; ?>"/></form> / 
			<u>H</u>ELP / 
			<span onClick="printMsg(about_tbt_text)"><a href="#">About TBT</a></span> / 
			<span onClick="printMsg(info_tbt_text)"><a href="#">Info </a></span> /
			<a href="<?=$_SERVER['PHP_SELF'];?>">Show last 5 tbts</a></span> /
		</td>
	</tr>
	<tr>
		<td height="104" align="left" valign="top">&nbsp;</td>
	</tr>
	</table>

	<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
	<tr class="andalemono">
		<td align="left" valign="top">--<a href="http://tbt.dyne.org/"><u>TIME BASED TEXT</u></a>--</td>
	</tr>
	</table>

</div>

<div style="position: absolute; width: 320px; top: 150px; left: 300px;">
<img src="images/tbt-wheel.png" />
</div>

<div id="res">
</div>

<script language="JavaScript">

	var max_result = 5
	var min_x = 40
	var max_x = 650

	var min_y = 40
	var max_y = 85

	var ran_y = new Array()
	var ran_x = new Array()
	var width  = new Array()
	var height = new Array()
	var i = 0

	var total_counter = 0
	var row_counter = 0
	var tbt_related_array = null

	// the array of tbt's generated by php
	<?php
		include_once("include/db.inc.php");
		include_once("include/tbt-php.php");

		$TBT = new TBT_DB;

		$action=$_GET['action'];
		// in case of no action take the last 5 tbt files
		switch($action) {
			case "search":
				$search_pattern = $_POST['search_pattern'];
				$row = $TBT->search($search_pattern,10);
				break;
			default:
				$row = $TBT->get_n(5);
				break;
		}

		if($row!=false) {

			echo "tbt_array = MultiDimensionalArray(".((sizeof($row)-1)).",".(sizeof($row[0])).")\n";
			
			$i=0;
			foreach($row as $r) {
				if($r["file"]!="") {
					echo "tbt_array['$i']['id']=\"".$r["id"]."\"\n";
					echo "tbt_array['$i']['title']=\"".$r["title"]."\"\n";
					echo "tbt_array['$i']['author']=\"".$r["author"]."\"\n";
					echo "tbt_array['$i']['city']=\"".$r["city"]."\"\n";
					$TBT_JSRender = new TBT_JSRender($upload_dir."/".$r["file"]);
					echo "tbt_array['$i']['tbt']=".$TBT_JSRender->get_jsstr()."\n";
					echo "tbt_array['$i']['email']=\"".$r["email"]."\"\n";
					echo "tbt_array['$i']['datetime']=\"".$r["datetime"]."\"\n";
					$i++;
				}
			}
		}
	?>
	
	print_divs()

	<?
		$str = "SET_DHTML(";
		for($j=0; $j<$i; $j++) {
			$str .= "\"div_$j\",";
		}
		$str .= ")\n";
		$str = str_replace(",)",")",$str);
		echo $str;
	?>

</script>

<div style="position: absolute; width: 320px; top: 150px; left: 10px;"  id="tbt_0"></div>
<div style="position: absolute; width: 320px; top: 150px; left: 340px;" id="tbt_1"></div>
<div style="position: absolute; width: 320px; top: 150px; left: 670px;" id="tbt_2"></div>

</body>
</html>
