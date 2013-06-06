<?php
$posting_user_id = $_SESSION[$settings['session_prefix'].'user_id'];
if ($posting_user_id == "") {
  $posting_user_id = "anon";
}
if ($_POST[id] == "all") {
  echo '<?xml version="1.0"?><records><self>'.$posting_user_id.'</self>';
  $result=mysql_query("SELECT DISTINCT * FROM ".$db_settings['like_table']) or die("</threads>");
  while ($row = mysql_fetch_array($result)) {
    echo "<like><thread>".$row[thread_id]."</thread><userid>".$row[user_id]."</userid></like>";
  }
  echo "</records>";
}
else {
  $id = $_POST[id];
  $like = $_POST[like];

  if ($like == "ajax") {
    $querystr="SELECT DISTINCT user_name,user_real_name FROM "
	.$db_settings['like_table'].",".$db_settings['userdata_table']
	." WHERE ".$db_settings['userdata_table'].".user_id = "
		 .$db_settings['like_table'].".user_id"
		." AND ".$db_settings['like_table'].".thread_id = ".$id;
    /*
    die('<?xml version="1.0"?><records><locked>1</locked><content><![CDATA[<p>'.$querystr.'</p>]]></content></records>');
    */
    $result=mysql_query($querystr);
    echo '<?xml version="1.0"?><records><locked>1</locked><content><![CDATA[<p>';
    $comma = "";
    while ($row = mysql_fetch_array($result)) {
      echo $comma;
      if ($row[user_real_name] == "") {
        echo $row[user_name];
      }
      else {
        echo $row[user_real_name];
      }
      $comma = ", ";
    }
    echo '</p>]]></content></records>';
  }
  else if ($like == 1) {
    $result=mysql_query("INSERT INTO ".$db_settings['like_table']." SET thread_id = ".$id.", user_id = ".$posting_user_id);
  }
  else {
    $result=mysql_query("DELETE FROM ".$db_settings['like_table']." WHERE thread_id = ".$id." AND user_id = ".$posting_user_id);
  }
}
die();
?>
