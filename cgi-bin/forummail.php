#!/usr/bin/php -q
<?php
$fd = fopen("php://stdin", "r");
$email = "";
while (!feof($fd))
{
    $email .= fread($fd, 1024);
}
fclose($fd);

$matches = array();

if (preg_match('#From: .*@.*\..*#i', $email, $matches) == 1) {
  $fromheader = $matches[0];
  $a = explode(":", $fromheader, 2);
  $from = trim($a[1]);
}
if (preg_match('#Subject: .*#i', $email, $matches) == 1) {
  $subjheader = $matches[0];
  $a = explode(":", $subjheader, 2);
  $subj = trim($a[1]);
}
$tid = "";
if (preg_match('#In-Reply-To: .*#i', $email, $matches) == 1) {
  $tidheader = $matches[0];
  $a = explode("In-Reply-To: <BOFID-", $tidheader, 2);
  $aa = explode("-", $a[1], 2);
  $tid = trim($aa[0]);
}

#if (preg_match('#Content-Type: multipart\/[^;]+;\s*boundary=.*([^"]+)#i', $email, $matches) == 1) {
if (preg_match('#Content-Type: multipart.*boundary=.*#i', $email, $matches) == 1) {
  $a = explode("=", $matches[0], 2);
  $boundary = $a[1];
}

$a = explode("\n\n", $email, 2);
$text = $a[1];

if (isset($boundary) && !empty($boundary)) // did we find a boundary?
{
  $email_segments = explode('--' . $boundary, $email);

  foreach ($email_segments as $segment)
  {
    if (stristr($segment, "Content-Type: text/plain") !== false)
    {
      #$text = trim(preg_replace('/Content-(Type|ID|Disposition|Transfer-Encoding):.*?\r\n/is', "", $segment));
      $a = preg_split('#Content-Type:.*text/plain.*#i', $segment);
      $text = trim($a[1]);
      break;
    }
  }
}

// At this point, $text will either contain your plain text body,
// or be an empty string if a plain text body couldn't be found.

$forum_dir = "/home/macchi/www/barrel-of-fun.org/forum";
include $forum_dir."/config/db_settings.php";
define('IN_INDEX', true);
include $forum_dir."/includes/functions.inc.php";

$connid = connect_db($db_settings['host'], $db_settings['user'], $db_settings['password'], $db_settings['database']);
if ($tid == "") {
  # If there's no X-BOF-ID then we have to guess if this is a reply or not.  If we find the same exact subject somewhere,
  # then we assume we're replying to that thread, under the main entry.
  $query = "SELECT id FROM ".$db_settings['forum_table']." WHERE subject = '".$subj."' ORDER BY time LIMIT 1";
  $result = mysql_query($query);
  if (mysql_num_rows($result) == 1) {
    $row = mysql_fetch_array($result);
    $tid = $row['id'];
  }
}

# Let's find out who this message is from!
$uid = -1;
$a = explode(" ", $from);
foreach ($a as $i) {
  if (($e = filter_var(filter_var($i, FILTER_SANITIZE_EMAIL), FILTER_VALIDATE_EMAIL)) !== false) {
    $query = "SELECT user_id FROM ".$db_settings['userdata_table']." WHERE user_emailalias = '".$e."' OR user_email = '".$e."'";
    $result = mysql_query($query) or die($query);
    if (mysql_num_rows($result) == 1) {
      $row = mysql_fetch_array($result);
      $uid = $row[user_id];
      break;
    }
  }
}

if ($uid == -1) {
  die("Could not find user with email contained in '$from'\n");
}

# Okay, it's time to post!
# If there's still no tid, then this is a new post.
if ($tid == "") {
  $tid = 0;
  $thread_id = 0;
}
else {
  # Get the thread id
  $query = "SELECT tid FROM ".$db_settings['forum_table']." WHERE id = ".$tid;
  $result = mysql_query($query) or die($query);
  $row = mysql_fetch_array($result);
  $thread_id = $row[tid];
}

$query = "INSERT INTO ".$db_settings['forum_table']." SET pid = ".$tid.", user_id = ".$uid.", tid = ".$thread_id.", subject = '".$subj."', text = '".$text."', email_notification = 1";
mysql_query($query);

if ($thread_id == 0) {
  @mysql_query("UPDATE ".$db_settings['forum_table']." SET tid=id, time=time WHERE id = LAST_INSERT_ID()");
}
?>
