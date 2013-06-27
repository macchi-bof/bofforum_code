{config_load file=$language_file section="general"}{if $subnav_location && $subnav_location_var}{assign var="subnav_location" value=$smarty.config.$subnav_location|replace:"[var]":$subnav_location_var}{elseif $subnav_location}{assign var='subnav_location' value=$smarty.config.$subnav_location}{/if}<!DOCTYPE html>
<html lang="{#language#}" dir="{#dir#}" xml:lang="en"
prefix="og: http://ogp.me/ns#
fb: http://ogp.me/ns/fb#
foaf: http://xmlns.com/foaf/0.1/
dc: http://purl.org/dc/terms/
v: http://rdf.data-vocabulary.org/#
owl: http://www.w3.org/2002/07/owl#" class="no-js no-touch">
<head>
    <meta charset="UTF-8">
    <title>{if $page_title}{$page_title} - {elseif $subnav_location}{$subnav_location} - {/if}{$settings.forum_name|escape:"html"}</title>
    <meta name="description" content="{$settings.forum_description|escape:"html"}" />
    {if $keywords}<meta name="keywords" content="{$keywords}" />{/if}
    {*
    {if $mode=='posting'}<meta name="robots" content="noindex" />{/if}
    *}  
    <meta name="robots" content="INDEX, FOLLOW" />
    <meta name="generator" content="my little forum {$settings.version}" />
{* browser-specific tags *}
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
{* JS *}
    <script src="js/lib/modernizr.2.6.2.custom.min.js" type="text/javascript"></script>
    <script src="js/lib/jquery-2.0.2.min.js" type="text/javascript"></script>
    <script src="{$THEMES_DIR}/{$theme}/js/plugin.js" type="text/javascript"></script>
{* CSS *}
    <link rel="stylesheet" type="text/css" href="{$THEMES_DIR}/{$theme}/fonts.css" media="all" />
    <link rel="stylesheet" type="text/css" href="{$THEMES_DIR}/{$theme}/style.css" media="all" />
{if $settings.rss_feed==1}<link rel="alternate" type="application/rss+xml" title="RSS" href="index.php?mode=rss" />{/if}
{if !$top}
<link rel="top" href="./" />
{/if}
{if $link_rel_first}
<link rel="first" href="{$link_rel_first}" />
{/if}
{if $link_rel_prev}
<link rel="prev" href="{$link_rel_prev}" />
{/if}
{if $link_rel_next}
<link rel="next" href="{$link_rel_next}" />
{/if}
{if $link_rel_last}
<link rel="last" href="{$link_rel_last}" />
{/if}
<link rel="search" href="index.php?mode=search" />
<link rel="shortcut icon" href="{$THEMES_DIR}/{$theme}/images/favicon.ico" />
{if $mode=='entry'}<link rel="canonical" href="{$settings.forum_address}index.php?mode=thread&amp;id={$tid}" />{/if}
<script src="index.php?mode=js_defaults&amp;t={$settings.last_changes}{if $user}&amp;user_type={$user_type}{/if}" type="text/javascript" charset="utf-8"></script>
<script src="js/main.js" type="text/javascript" charset="utf-8"></script>
{if $mode=='posting'}
<script src="js/posting.min.js" type="text/javascript" charset="utf-8"></script>
{/if}
{if $mode=='admin'}
<script src="js/admin.min.js" type="text/javascript" charset="utf-8"></script>
{/if}
</head>

<body>

<header role="banner">
    {*
    {if $settings.home_linkname}<p class="home"><a href="{$settings.home_linkaddress}">{$settings.home_linkname}</a></p>{/if}
    *}
    <h1><a href="./" title="{#forum_index_link_title#}">{$settings.forum_name|escape:"html"}</a></h1>

    <div id="nav" class="{if $admin}nav_with_admin{else}nav_no_admin{/if} {if $user}nav_with_user{else}nav_unregistered{/if}">
        <ul id="usermenu">
            {if $user}
                <li><a href="index.php?mode=login" title="{#log_out_link_title#}">{#log_out_link#}</a></li>
                {if $admin}
                    <li><a href="index.php?mode=admin" title="{#admin_area_link_title#}">{#admin_area_link#}</a></li>
                {/if}
                <li><a href="index.php?mode=user" title="{#user_area_link_title#}">{#user_area_link#}</a></li>
                <li><a href="index.php?mode=user&amp;action=edit_profile" title="{#profile_link_title#}"><strong>{$user}</strong></a></li>
            {else}
                {if $settings.user_area_public}
                    <li><a href="index.php?mode=user" title="{#user_area_link_title#}">{#user_area_link#}</a></li>
                {/if}
                {if $settings.register_mode!=2}
                    <li><a href="index.php?mode=register" title="{#register_link_title#}">{#register_link#}</a></li>
                {/if}
                <li><a href="index.php?mode=login" title="{#log_in_link_title#}">{#log_in_link#}</a></li>
            {/if}
            {if $menu}
                {foreach $menu as $item}
                    <li><a href="index.php?mode=page&amp;id={$item.id}">{$item.linkname}</a></li>
                {/foreach}
            {/if}
        </ul>
        <form id="topsearch" action="index.php" method="get" title="{#search_title#}" accept-charset="{#charset#}">
            <div class="loop_bord">
                <input type="hidden" name="mode" value="search" />
                <label for="search-input">{#search_marking#}</label>
                <input id="search-input" type="text" name="search" value="{#search_default_value#}" />
                <button type="submit" />Search</button>
            </div>
        </form>
    </div>

    <div id="subnav">
        <!-- <div id="subnav-1">{include file="$theme/subtemplates/subnavigation_1.inc.tpl"}</div> -->
        {include file="$theme/subtemplates/subnavigation_2.inc.tpl"}
    </div>

</header>

<div id="content">
{if $subtemplate}
{include file="$theme/subtemplates/$subtemplate"}
{else}
{$content|default:""}
{/if}
</div>

<div id="footer">
<div id="footer-1">{if $total_users_online}{#counter_users_online#|replace:"[total_postings]":$total_postings|replace:"[total_threads]":$total_threads|replace:"[registered_users]":$registered_users|replace:"[total_users_online]":$total_users_online|replace:"[registered_users_online]":$registered_users_online|replace:"[unregistered_users_online]":$unregistered_users_online}{else}{#counter#|replace:"[total_postings]":$total_postings|replace:"[total_threads]":$total_threads|replace:"[registered_users]":$registered_users}{/if}<br />
{if $forum_time_zone}{#forum_time_with_time_zone#|replace:'[time]':$forum_time|replace:'[time_zone]':$forum_time_zone}{else}{#forum_time#|replace:'[time]':$forum_time}{/if}</div>
<div id="footer-2">
<ul id="footermenu">
{if $settings.rss_feed==1}<li><a class="rss" href="index.php?mode=rss" title="{#rss_feed_postings_title#}">{#rss_feed_postings#}</a> &nbsp;<a class="rss" href="index.php?mode=rss&amp;items=thread_starts" title="{#rss_feed_new_threads_title#}">{#rss_feed_new_threads#}</a></li>{/if}<li><a href="index.php?mode=contact" title="{#contact_linktitle#}" rel="nofollow">{#contact_link#}</a></li>
</ul></div>
</div>

{*
Please donate if you want to remove this link:
https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=1922497
*}
<div id="pbmlf"><a href="http://mylittleforum.net/">powered by my little forum</a></div>

<script>
$('body').pluginName();
</script>
</body>
</html>
