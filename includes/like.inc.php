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
  if ($like == 1) {
    $result=mysql_query("INSERT INTO ".$db_settings['like_table']." SET thread_id = ".$id.", user_id = ".$posting_user_id);
  }
  else {
    $result=mysql_query("DELETE FROM ".$db_settings['like_table']." WHERE thread_id = ".$id." AND user_id = ".$posting_user_id);
  }
}
die();
?>
