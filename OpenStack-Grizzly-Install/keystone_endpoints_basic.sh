  


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>OpenStack-Grizzly-Install-Guide/KeystoneScripts/keystone_endpoints_basic.sh at OVS_MultiNode · mseknibilel/OpenStack-Grizzly-Install-Guide</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
    <link rel="logo" type="image/svg" href="http://github-media-downloads.s3.amazonaws.com/github-logo.svg" />
    <link rel="xhr-socket" href="/_sockets" />


    <meta name="msapplication-TileImage" content="/windows-tile.png" />
    <meta name="msapplication-TileColor" content="#ffffff" />
    <meta name="selected-link" value="repo_source" data-pjax-transient />
    <meta content="collector.githubapp.com" name="octolytics-host" /><meta content="github" name="octolytics-app-id" /><meta content="3462347" name="octolytics-actor-id" /><meta content="f7ad364a81c4894ab7820281a036e2856f6f67fdb274f61038e287e86b01dfcd" name="octolytics-actor-hash" />

    
    
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />

    <meta content="authenticity_token" name="csrf-param" />
<meta content="4/Qekouf8/FWuv1Zp8/77NRTzUcTYzR0XmWvDR7JZhU=" name="csrf-token" />

    <link href="https://a248.e.akamai.net/assets.github.com/assets/github-d63f89e307e2e357d3b7160b3cd4020463f9bbc1.css" media="all" rel="stylesheet" type="text/css" />
    <link href="https://a248.e.akamai.net/assets.github.com/assets/github2-883c2d036f95a0fb486a5d977a84cb0b91a58353.css" media="all" rel="stylesheet" type="text/css" />
    


      <script src="https://a248.e.akamai.net/assets.github.com/assets/frameworks-92d138f450f2960501e28397a2f63b0f100590f0.js" type="text/javascript"></script>
      <script src="https://a248.e.akamai.net/assets.github.com/assets/github-9514cee43c62b106e5ca1f5cf2107a0c1fad9381.js" type="text/javascript"></script>
      
      <meta http-equiv="x-pjax-version" content="69eecf449c3b66a1c0a67e6f1032684b">

        <link data-pjax-transient rel='permalink' href='/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/ded74ab73d08eedd170854080f7d2c52666197e8/KeystoneScripts/keystone_endpoints_basic.sh'>
    <meta property="og:title" content="OpenStack-Grizzly-Install-Guide"/>
    <meta property="og:type" content="githubog:gitrepository"/>
    <meta property="og:url" content="https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide"/>
    <meta property="og:image" content="https://secure.gravatar.com/avatar/19e87be1da8e792ec19f87e976d8b7e9?s=420&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"/>
    <meta property="og:site_name" content="GitHub"/>
    <meta property="og:description" content="OpenStack-Grizzly-Install-Guide - A full install guide for OpenStack Grizzly"/>
    <meta property="twitter:card" content="summary"/>
    <meta property="twitter:site" content="@GitHub">
    <meta property="twitter:title" content="mseknibilel/OpenStack-Grizzly-Install-Guide"/>

    <meta name="description" content="OpenStack-Grizzly-Install-Guide - A full install guide for OpenStack Grizzly" />


    <meta content="1716566" name="octolytics-dimension-user_id" /><meta content="9026453" name="octolytics-dimension-repository_id" />
  <link href="https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide/commits/OVS_MultiNode.atom" rel="alternate" title="Recent Commits to OpenStack-Grizzly-Install-Guide:OVS_MultiNode" type="application/atom+xml" />

  </head>


  <body class="logged_in page-blob linux vis-public env-production  ">
    <div id="wrapper">

      

      
      
      

      <div class="header header-logged-in true">
  <div class="container clearfix">

    <a class="header-logo-invertocat" href="https://github.com/">
  <span class="mega-octicon octicon-mark-github"></span>
</a>

    <div class="divider-vertical"></div>

      <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/notifications" class="notification-indicator tooltipped downwards contextually-unread" title="You have unread notifications in this repository">
    <span class="mail-status unread"></span>
  </a>
  <div class="divider-vertical"></div>


      <div class="command-bar js-command-bar  in-repository">
          <form accept-charset="UTF-8" action="/search" class="command-bar-form" id="top_search_form" method="get">
  <a href="/search/advanced" class="advanced-search-icon tooltipped downwards command-bar-search" id="advanced_search" title="Advanced search"><span class="octicon octicon-gear "></span></a>

  <input type="text" data-hotkey="/ s" name="q" id="js-command-bar-field" placeholder="Search or type a command" tabindex="1" autocapitalize="off"
    data-username="codeshredder"
      data-repo="mseknibilel/OpenStack-Grizzly-Install-Guide"
      data-branch="OVS_MultiNode"
      data-sha="8e4015731ba4632154b44df976146a18b80a42bd"
  >

    <input type="hidden" name="nwo" value="mseknibilel/OpenStack-Grizzly-Install-Guide" />

    <div class="select-menu js-menu-container js-select-menu search-context-select-menu">
      <span class="minibutton select-menu-button js-menu-target">
        <span class="js-select-button">This repository</span>
      </span>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">
        <div class="select-menu-modal">

          <div class="select-menu-item js-navigation-item selected">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" class="js-search-this-repository" name="search_target" value="repository" checked="checked" />
            <div class="select-menu-item-text js-select-button-text">This repository</div>
          </div> <!-- /.select-menu-item -->

          <div class="select-menu-item js-navigation-item">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" name="search_target" value="global" />
            <div class="select-menu-item-text js-select-button-text">All repositories</div>
          </div> <!-- /.select-menu-item -->

        </div>
      </div>
    </div>

  <span class="octicon help tooltipped downwards" title="Show command bar help">
    <span class="octicon octicon-question"></span>
  </span>


  <input type="hidden" name="ref" value="cmdform">

  <div class="divider-vertical"></div>

</form>
        <ul class="top-nav">
            <li class="explore"><a href="https://github.com/explore">Explore</a></li>
            <li><a href="https://gist.github.com">Gist</a></li>
            <li><a href="/blog">Blog</a></li>
          <li><a href="http://help.github.com">Help</a></li>
        </ul>
      </div>

    

  

    <ul id="user-links">
      <li>
        <a href="https://github.com/codeshredder" class="name">
          <img height="20" src="https://secure.gravatar.com/avatar/4974859a749d01e408af29b097113d99?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /> codeshredder
        </a>
      </li>

        <li>
          <a href="/new" id="new_repo" class="tooltipped downwards" title="Create a new repo">
            <span class="octicon octicon-repo-create"></span>
          </a>
        </li>

        <li>
          <a href="/settings/profile" id="account_settings"
            class="tooltipped downwards"
            title="Account settings ">
            <span class="octicon octicon-tools"></span>
          </a>
        </li>
        <li>
          <a class="tooltipped downwards" href="/logout" data-method="post" id="logout" title="Sign out">
            <span class="octicon octicon-log-out"></span>
          </a>
        </li>

    </ul>


<div class="js-new-dropdown-contents hidden">
  <ul class="dropdown-menu">
    <li>
      <a href="/new"><span class="octicon octicon-repo-create"></span> New repository</a>
    </li>
    <li>
        <a href="https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide/issues/new"><span class="octicon octicon-issue-opened"></span> New issue</a>
    </li>
    <li>
    </li>
    <li>
      <a href="/organizations/new"><span class="octicon octicon-list-unordered"></span> New organization</a>
    </li>
  </ul>
</div>


    
  </div>
</div>

      

      

      


            <div class="site hfeed" itemscope itemtype="http://schema.org/WebPage">
      <div class="hentry">
        
        <div class="pagehead repohead instapaper_ignore readability-menu ">
          <div class="container">
            <div class="title-actions-bar">
              

<ul class="pagehead-actions">


    <li class="subscription">
      <form accept-charset="UTF-8" action="/notifications/subscribe" data-autosubmit="true" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="4/Qekouf8/FWuv1Zp8/77NRTzUcTYzR0XmWvDR7JZhU=" /></div>  <input id="repository_id" name="repository_id" type="hidden" value="9026453" />

    <div class="select-menu js-menu-container js-select-menu">
      <span class="minibutton select-menu-button js-menu-target">
        <span class="js-select-button">
          <span class="octicon octicon-eye-unwatch"></span>
          Unwatch
        </span>
      </span>

      <div class="select-menu-modal-holder js-menu-content">
        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Notification status</span>
            <span class="octicon octicon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-list js-navigation-container">

            <div class="select-menu-item js-navigation-item ">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input id="do_included" name="do" type="radio" value="included" />
                <h4>Not watching</h4>
                <span class="description">You only receive notifications for discussions in which you participate or are @mentioned.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-eye-watch"></span>
                  Watch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item selected">
              <span class="select-menu-item-icon octicon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input checked="checked" id="do_subscribed" name="do" type="radio" value="subscribed" />
                <h4>Watching</h4>
                <span class="description">You receive notifications for all discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-eye-unwatch"></span>
                  Unwatch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item ">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input id="do_ignore" name="do" type="radio" value="ignore" />
                <h4>Ignoring</h4>
                <span class="description">You do not receive any notifications for discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-mute"></span>
                  Stop ignoring
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

</form>
    </li>

    <li class="js-toggler-container js-social-container starring-container ">
      <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/unstar" class="minibutton js-toggler-target star-button starred upwards" title="Unstar this repo" data-remote="true" data-method="post" rel="nofollow">
        <span class="octicon octicon-star-delete"></span>
        <span class="text">Unstar</span>
      </a>
      <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/star" class="minibutton js-toggler-target star-button unstarred upwards" title="Star this repo" data-remote="true" data-method="post" rel="nofollow">
        <span class="octicon octicon-star"></span>
        <span class="text">Star</span>
      </a>
      <a class="social-count js-social-count" href="/mseknibilel/OpenStack-Grizzly-Install-Guide/stargazers">101</a>
    </li>

        <li>
          <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/fork" class="minibutton js-toggler-target fork-button lighter upwards" title="Fork this repo" rel="nofollow" data-method="post">
            <span class="octicon octicon-git-branch-create"></span>
            <span class="text">Fork</span>
          </a>
          <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/network" class="social-count">63</a>
        </li>


</ul>

              <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public">
                <span class="repo-label"><span>public</span></span>
                <span class="mega-octicon octicon-repo"></span>
                <span class="author vcard">
                  <a href="/mseknibilel" class="url fn" itemprop="url" rel="author">
                  <span itemprop="title">mseknibilel</span>
                  </a></span> /
                <strong><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide" class="js-current-repository">OpenStack-Grizzly-Install-Guide</a></strong>
              </h1>
            </div>

            
  <ul class="tabs">
    <li class="pulse-nav"><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/pulse" class="js-selected-navigation-item " data-selected-links="pulse /mseknibilel/OpenStack-Grizzly-Install-Guide/pulse" rel="nofollow"><span class="octicon octicon-pulse"></span></a></li>
    <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide" class="js-selected-navigation-item selected" data-selected-links="repo_source repo_downloads repo_commits repo_tags repo_branches /mseknibilel/OpenStack-Grizzly-Install-Guide">Code</a></li>
    <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/network" class="js-selected-navigation-item " data-selected-links="repo_network /mseknibilel/OpenStack-Grizzly-Install-Guide/network">Network</a></li>
    <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/pulls" class="js-selected-navigation-item " data-selected-links="repo_pulls /mseknibilel/OpenStack-Grizzly-Install-Guide/pulls">Pull Requests <span class='counter'>0</span></a></li>

      <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/issues" class="js-selected-navigation-item " data-selected-links="repo_issues /mseknibilel/OpenStack-Grizzly-Install-Guide/issues">Issues <span class='counter'>2</span></a></li>

      <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/wiki" class="js-selected-navigation-item " data-selected-links="repo_wiki /mseknibilel/OpenStack-Grizzly-Install-Guide/wiki">Wiki</a></li>


    <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/graphs" class="js-selected-navigation-item " data-selected-links="repo_graphs repo_contributors /mseknibilel/OpenStack-Grizzly-Install-Guide/graphs">Graphs</a></li>


  </ul>
  
<div class="tabnav">

  <span class="tabnav-right">
    <ul class="tabnav-tabs">
          <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/tags" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_tags /mseknibilel/OpenStack-Grizzly-Install-Guide/tags">Tags <span class="counter blank">0</span></a></li>
    </ul>
  </span>

  <div class="tabnav-widget scope">


    <div class="select-menu js-menu-container js-select-menu js-branch-menu">
      <a class="minibutton select-menu-button js-menu-target" data-hotkey="w" data-ref="OVS_MultiNode">
        <span class="octicon octicon-branch"></span>
        <i>branch:</i>
        <span class="js-select-button">OVS_MultiNode</span>
      </a>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">

        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Switch branches/tags</span>
            <span class="octicon octicon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-filters">
            <div class="select-menu-text-filter">
              <input type="text" id="commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Filter branches/tags">
            </div>
            <div class="select-menu-tabs">
              <ul>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="branches" class="js-select-menu-tab">Branches</a>
                </li>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="tags" class="js-select-menu-tab">Tags</a>
                </li>
              </ul>
            </div><!-- /.select-menu-tabs -->
          </div><!-- /.select-menu-filters -->

          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="branches">

            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/Nicira_SingleNode/KeystoneScripts/keystone_endpoints_basic.sh" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="Nicira_SingleNode" rel="nofollow" title="Nicira_SingleNode">Nicira_SingleNode</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item selected">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/OVS_MultiNode/KeystoneScripts/keystone_endpoints_basic.sh" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="OVS_MultiNode" rel="nofollow" title="OVS_MultiNode">OVS_MultiNode</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/OVS_SingleNode/KeystoneScripts/keystone_endpoints_basic.sh" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="OVS_SingleNode" rel="nofollow" title="OVS_SingleNode">OVS_SingleNode</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/master/KeystoneScripts/keystone_endpoints_basic.sh" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="master" rel="nofollow" title="master">master</a>
                </div> <!-- /.select-menu-item -->
            </div>

              <div class="select-menu-no-results">Nothing to show</div>
          </div> <!-- /.select-menu-list -->


          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="tags">
            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

            </div>

            <div class="select-menu-no-results">Nothing to show</div>

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

  </div> <!-- /.scope -->

  <ul class="tabnav-tabs">
    <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide" class="selected js-selected-navigation-item tabnav-tab" data-selected-links="repo_source /mseknibilel/OpenStack-Grizzly-Install-Guide">Files</a></li>
    <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/commits/OVS_MultiNode" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_commits /mseknibilel/OpenStack-Grizzly-Install-Guide/commits/OVS_MultiNode">Commits</a></li>
    <li><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/branches" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_branches /mseknibilel/OpenStack-Grizzly-Install-Guide/branches" rel="nofollow">Branches <span class="counter ">4</span></a></li>
  </ul>

</div>

  
  
  


            
          </div>
        </div><!-- /.repohead -->

        <div id="js-repo-pjax-container" class="container context-loader-container" data-pjax-container>
          


<!-- blob contrib key: blob_contributors:v21:4a03ff846a159ba051fc0a4e550793d5 -->
<!-- blob contrib frag key: views10/v8/blob_contributors:v21:4a03ff846a159ba051fc0a4e550793d5 -->


<div id="slider">
    <div class="frame-meta">

      <p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

        <div class="breadcrumb">
          <span class='bold'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide" class="js-slide-to" data-branch="OVS_MultiNode" data-direction="back" itemscope="url"><span itemprop="title">OpenStack-Grizzly-Install-Guide</span></a></span></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/tree/OVS_MultiNode/KeystoneScripts" class="js-slide-to" data-branch="OVS_MultiNode" data-direction="back" itemscope="url"><span itemprop="title">KeystoneScripts</span></a></span><span class="separator"> / </span><strong class="final-path">keystone_endpoints_basic.sh</strong> <span class="js-zeroclipboard zeroclipboard-button" data-clipboard-text="KeystoneScripts/keystone_endpoints_basic.sh" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
        </div>

      <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/find/OVS_MultiNode" class="js-slide-to" data-hotkey="t" style="display:none">Show File Finder</a>


        
  <div class="commit file-history-tease">
    <img class="main-avatar" height="24" src="https://secure.gravatar.com/avatar/19e87be1da8e792ec19f87e976d8b7e9?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
    <span class="author"><a href="/mseknibilel" rel="author">mseknibilel</a></span>
    <time class="js-relative-date" datetime="2013-04-12T01:33:01-07:00" title="2013-04-12 01:33:01">April 12, 2013</time>
    <div class="commit-title">
        <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/commit/b363f90e2a8e63ce223fe401db88fa38547acfaf" class="message">Update keystone_endpoints_basic.sh</a>
    </div>

    <div class="participation">
      <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>1</strong> contributor</a></p>
      
    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2>Users on GitHub who have contributed to this file</h2>
      <ul class="facebox-user-list">
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/19e87be1da8e792ec19f87e976d8b7e9?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/mseknibilel">mseknibilel</a>
        </li>
      </ul>
    </div>
  </div>


    </div><!-- ./.frame-meta -->

    <div class="frames">
      <div class="frame" data-permalink-url="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/ded74ab73d08eedd170854080f7d2c52666197e8/KeystoneScripts/keystone_endpoints_basic.sh" data-title="OpenStack-Grizzly-Install-Guide/KeystoneScripts/keystone_endpoints_basic.sh at OVS_MultiNode · mseknibilel/OpenStack-Grizzly-Install-Guide · GitHub" data-type="blob">

        <div id="files" class="bubble">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><b class="octicon octicon-file-text"></b></span>
                <span class="mode" title="File Mode">file</span>
                  <span>136 lines (120 sloc)</span>
                <span>4.489 kb</span>
              </div>
              <div class="actions">
                <div class="button-group">
                        <a class="minibutton tooltipped leftwards"
                           title="Clicking this button will automatically fork this project so you can edit the file"
                           href="/mseknibilel/OpenStack-Grizzly-Install-Guide/edit/OVS_MultiNode/KeystoneScripts/keystone_endpoints_basic.sh"
                           data-method="post" rel="nofollow">Edit</a>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/raw/OVS_MultiNode/KeystoneScripts/keystone_endpoints_basic.sh" class="button minibutton " id="raw-url">Raw</a>
                    <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blame/OVS_MultiNode/KeystoneScripts/keystone_endpoints_basic.sh" class="button minibutton ">Blame</a>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/commits/OVS_MultiNode/KeystoneScripts/keystone_endpoints_basic.sh" class="button minibutton " rel="nofollow">History</a>
                </div><!-- /.button-group -->
              </div><!-- /.actions -->

            </div>
                <div class="blob-wrapper data type-shell js-blob-data">
      <table class="file-code file-diff">
        <tr class="file-code-line">
          <td class="blob-line-nums">
            <span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
<span id="L105" rel="#L105">105</span>
<span id="L106" rel="#L106">106</span>
<span id="L107" rel="#L107">107</span>
<span id="L108" rel="#L108">108</span>
<span id="L109" rel="#L109">109</span>
<span id="L110" rel="#L110">110</span>
<span id="L111" rel="#L111">111</span>
<span id="L112" rel="#L112">112</span>
<span id="L113" rel="#L113">113</span>
<span id="L114" rel="#L114">114</span>
<span id="L115" rel="#L115">115</span>
<span id="L116" rel="#L116">116</span>
<span id="L117" rel="#L117">117</span>
<span id="L118" rel="#L118">118</span>
<span id="L119" rel="#L119">119</span>
<span id="L120" rel="#L120">120</span>
<span id="L121" rel="#L121">121</span>
<span id="L122" rel="#L122">122</span>
<span id="L123" rel="#L123">123</span>
<span id="L124" rel="#L124">124</span>
<span id="L125" rel="#L125">125</span>
<span id="L126" rel="#L126">126</span>
<span id="L127" rel="#L127">127</span>
<span id="L128" rel="#L128">128</span>
<span id="L129" rel="#L129">129</span>
<span id="L130" rel="#L130">130</span>
<span id="L131" rel="#L131">131</span>
<span id="L132" rel="#L132">132</span>
<span id="L133" rel="#L133">133</span>
<span id="L134" rel="#L134">134</span>
<span id="L135" rel="#L135">135</span>

          </td>
          <td class="blob-line-code">
                  <div class="highlight"><pre><div class='line' id='LC1'><span class="c">#!/bin/sh</span></div><div class='line' id='LC2'><span class="c">#</span></div><div class='line' id='LC3'><span class="c"># Keystone basic Endpoints</span></div><div class='line' id='LC4'><br/></div><div class='line' id='LC5'><span class="c"># Mainly inspired by https://github.com/openstack/keystone/blob/master/tools/sample_data.sh</span></div><div class='line' id='LC6'><br/></div><div class='line' id='LC7'><span class="c"># Modified by Bilel Msekni / Institut Telecom</span></div><div class='line' id='LC8'><span class="c">#</span></div><div class='line' id='LC9'><span class="c"># Support: openstack@lists.launchpad.net</span></div><div class='line' id='LC10'><span class="c"># License: Apache Software License (ASL) 2.0</span></div><div class='line' id='LC11'><span class="c">#</span></div><div class='line' id='LC12'><br/></div><div class='line' id='LC13'><span class="c"># Host address</span></div><div class='line' id='LC14'><span class="nv">HOST_IP</span><span class="o">=</span>10.10.10.51</div><div class='line' id='LC15'><span class="nv">EXT_HOST_IP</span><span class="o">=</span>192.168.100.51</div><div class='line' id='LC16'><br/></div><div class='line' id='LC17'><span class="c"># MySQL definitions</span></div><div class='line' id='LC18'><span class="nv">MYSQL_USER</span><span class="o">=</span>keystoneUser</div><div class='line' id='LC19'><span class="nv">MYSQL_DATABASE</span><span class="o">=</span>keystone</div><div class='line' id='LC20'><span class="nv">MYSQL_HOST</span><span class="o">=</span><span class="nv">$HOST_IP</span></div><div class='line' id='LC21'><span class="nv">MYSQL_PASSWORD</span><span class="o">=</span>keystonePass</div><div class='line' id='LC22'><br/></div><div class='line' id='LC23'><span class="c"># Keystone definitions</span></div><div class='line' id='LC24'><span class="nv">KEYSTONE_REGION</span><span class="o">=</span>RegionOne</div><div class='line' id='LC25'><span class="nb">export </span><span class="nv">SERVICE_TOKEN</span><span class="o">=</span>ADMIN</div><div class='line' id='LC26'><span class="nb">export </span><span class="nv">SERVICE_ENDPOINT</span><span class="o">=</span><span class="s2">&quot;http://${HOST_IP}:35357/v2.0&quot;</span></div><div class='line' id='LC27'><br/></div><div class='line' id='LC28'><span class="k">while </span><span class="nb">getopts</span> <span class="s2">&quot;u:D:p:m:K:R:E:T:vh&quot;</span> opt; <span class="k">do</span></div><div class='line' id='LC29'><span class="k">  case</span> <span class="nv">$opt</span> in</div><div class='line' id='LC30'>&nbsp;&nbsp;&nbsp;&nbsp;u<span class="o">)</span></div><div class='line' id='LC31'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">MYSQL_USER</span><span class="o">=</span><span class="nv">$OPTARG</span></div><div class='line' id='LC32'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC33'>&nbsp;&nbsp;&nbsp;&nbsp;D<span class="o">)</span></div><div class='line' id='LC34'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">MYSQL_DATABASE</span><span class="o">=</span><span class="nv">$OPTARG</span></div><div class='line' id='LC35'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC36'>&nbsp;&nbsp;&nbsp;&nbsp;p<span class="o">)</span></div><div class='line' id='LC37'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">MYSQL_PASSWORD</span><span class="o">=</span><span class="nv">$OPTARG</span></div><div class='line' id='LC38'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC39'>&nbsp;&nbsp;&nbsp;&nbsp;m<span class="o">)</span></div><div class='line' id='LC40'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">MYSQL_HOST</span><span class="o">=</span><span class="nv">$OPTARG</span></div><div class='line' id='LC41'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC42'>&nbsp;&nbsp;&nbsp;&nbsp;K<span class="o">)</span></div><div class='line' id='LC43'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">MASTER</span><span class="o">=</span><span class="nv">$OPTARG</span></div><div class='line' id='LC44'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC45'>&nbsp;&nbsp;&nbsp;&nbsp;R<span class="o">)</span></div><div class='line' id='LC46'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">KEYSTONE_REGION</span><span class="o">=</span><span class="nv">$OPTARG</span></div><div class='line' id='LC47'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC48'>&nbsp;&nbsp;&nbsp;&nbsp;E<span class="o">)</span></div><div class='line' id='LC49'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">export </span><span class="nv">SERVICE_ENDPOINT</span><span class="o">=</span><span class="nv">$OPTARG</span></div><div class='line' id='LC50'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC51'>&nbsp;&nbsp;&nbsp;&nbsp;T<span class="o">)</span></div><div class='line' id='LC52'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">export </span><span class="nv">SERVICE_TOKEN</span><span class="o">=</span><span class="nv">$OPTARG</span></div><div class='line' id='LC53'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC54'>&nbsp;&nbsp;&nbsp;&nbsp;v<span class="o">)</span></div><div class='line' id='LC55'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">set</span> -x</div><div class='line' id='LC56'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC57'>&nbsp;&nbsp;&nbsp;&nbsp;h<span class="o">)</span></div><div class='line' id='LC58'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cat <span class="s">&lt;&lt;EOF</span></div><div class='line' id='LC59'><span class="s">Usage: $0 [-m mysql_hostname] [-u mysql_username] [-D mysql_database] [-p mysql_password]</span></div><div class='line' id='LC60'><span class="s">       [-K keystone_master ] [ -R keystone_region ] [ -E keystone_endpoint_url ] </span></div><div class='line' id='LC61'><span class="s">       [ -T keystone_token ]</span></div><div class='line' id='LC62'><span class="s">          </span></div><div class='line' id='LC63'><span class="s">Add -v for verbose mode, -h to display this message.</span></div><div class='line' id='LC64'><span class="s">EOF</span></div><div class='line' id='LC65'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">exit </span>0</div><div class='line' id='LC66'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC67'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="se">\?</span><span class="o">)</span></div><div class='line' id='LC68'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">echo</span> <span class="s2">&quot;Unknown option -$OPTARG&quot;</span> &gt;&amp;2</div><div class='line' id='LC69'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">exit </span>1</div><div class='line' id='LC70'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC71'>&nbsp;&nbsp;&nbsp;&nbsp;:<span class="o">)</span></div><div class='line' id='LC72'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">echo</span> <span class="s2">&quot;Option -$OPTARG requires an argument&quot;</span> &gt;&amp;2</div><div class='line' id='LC73'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">exit </span>1</div><div class='line' id='LC74'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC75'>&nbsp;&nbsp;<span class="k">esac</span></div><div class='line' id='LC76'><span class="k">done  </span></div><div class='line' id='LC77'><br/></div><div class='line' id='LC78'><span class="k">if</span> <span class="o">[</span> -z <span class="s2">&quot;$KEYSTONE_REGION&quot;</span> <span class="o">]</span>; <span class="k">then</span></div><div class='line' id='LC79'><span class="k">  </span><span class="nb">echo</span> <span class="s2">&quot;Keystone region not set. Please set with -R option or set KEYSTONE_REGION variable.&quot;</span> &gt;&amp;2</div><div class='line' id='LC80'>&nbsp;&nbsp;<span class="nv">missing_args</span><span class="o">=</span><span class="s2">&quot;true&quot;</span></div><div class='line' id='LC81'><span class="k">fi</span></div><div class='line' id='LC82'><br/></div><div class='line' id='LC83'><span class="k">if</span> <span class="o">[</span> -z <span class="s2">&quot;$SERVICE_TOKEN&quot;</span> <span class="o">]</span>; <span class="k">then</span></div><div class='line' id='LC84'><span class="k">  </span><span class="nb">echo</span> <span class="s2">&quot;Keystone service token not set. Please set with -T option or set SERVICE_TOKEN variable.&quot;</span> &gt;&amp;2</div><div class='line' id='LC85'>&nbsp;&nbsp;<span class="nv">missing_args</span><span class="o">=</span><span class="s2">&quot;true&quot;</span></div><div class='line' id='LC86'><span class="k">fi</span></div><div class='line' id='LC87'><br/></div><div class='line' id='LC88'><span class="k">if</span> <span class="o">[</span> -z <span class="s2">&quot;$SERVICE_ENDPOINT&quot;</span> <span class="o">]</span>; <span class="k">then</span></div><div class='line' id='LC89'><span class="k">  </span><span class="nb">echo</span> <span class="s2">&quot;Keystone service endpoint not set. Please set with -E option or set SERVICE_ENDPOINT variable.&quot;</span> &gt;&amp;2</div><div class='line' id='LC90'>&nbsp;&nbsp;<span class="nv">missing_args</span><span class="o">=</span><span class="s2">&quot;true&quot;</span></div><div class='line' id='LC91'><span class="k">fi</span></div><div class='line' id='LC92'><br/></div><div class='line' id='LC93'><span class="k">if</span> <span class="o">[</span> -z <span class="s2">&quot;$MYSQL_PASSWORD&quot;</span> <span class="o">]</span>; <span class="k">then</span></div><div class='line' id='LC94'><span class="k">  </span><span class="nb">echo</span> <span class="s2">&quot;MySQL password not set. Please set with -p option or set MYSQL_PASSWORD variable.&quot;</span> &gt;&amp;2</div><div class='line' id='LC95'>&nbsp;&nbsp;<span class="nv">missing_args</span><span class="o">=</span><span class="s2">&quot;true&quot;</span></div><div class='line' id='LC96'><span class="k">fi</span></div><div class='line' id='LC97'><br/></div><div class='line' id='LC98'><span class="k">if</span> <span class="o">[</span> -n <span class="s2">&quot;$missing_args&quot;</span> <span class="o">]</span>; <span class="k">then</span></div><div class='line' id='LC99'><span class="k">  </span><span class="nb">exit </span>1</div><div class='line' id='LC100'><span class="k">fi</span></div><div class='line' id='LC101'><span class="k"> </span></div><div class='line' id='LC102'>keystone service-create --name nova --type compute --description <span class="s1">&#39;OpenStack Compute Service&#39;</span></div><div class='line' id='LC103'>keystone service-create --name cinder --type volume --description <span class="s1">&#39;OpenStack Volume Service&#39;</span></div><div class='line' id='LC104'>keystone service-create --name glance --type image --description <span class="s1">&#39;OpenStack Image Service&#39;</span></div><div class='line' id='LC105'>keystone service-create --name keystone --type identity --description <span class="s1">&#39;OpenStack Identity&#39;</span></div><div class='line' id='LC106'>keystone service-create --name ec2 --type ec2 --description <span class="s1">&#39;OpenStack EC2 service&#39;</span></div><div class='line' id='LC107'>keystone service-create --name quantum --type network --description <span class="s1">&#39;OpenStack Networking service&#39;</span></div><div class='line' id='LC108'><br/></div><div class='line' id='LC109'>create_endpoint <span class="o">()</span> <span class="o">{</span></div><div class='line' id='LC110'>&nbsp;&nbsp;<span class="k">case</span> <span class="nv">$1</span> in</div><div class='line' id='LC111'>&nbsp;&nbsp;&nbsp;&nbsp;compute<span class="o">)</span></div><div class='line' id='LC112'>&nbsp;&nbsp;&nbsp;&nbsp;keystone endpoint-create --region <span class="nv">$KEYSTONE_REGION</span> --service-id <span class="nv">$2</span> --publicurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$EXT_HOST_IP&quot;</span><span class="s1">&#39;:8774/v2/$(tenant_id)s&#39;</span> --adminurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:8774/v2/$(tenant_id)s&#39;</span> --internalurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:8774/v2/$(tenant_id)s&#39;</span></div><div class='line' id='LC113'>&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC114'>&nbsp;&nbsp;&nbsp;&nbsp;volume<span class="o">)</span></div><div class='line' id='LC115'>&nbsp;&nbsp;&nbsp;&nbsp;keystone endpoint-create --region <span class="nv">$KEYSTONE_REGION</span> --service-id <span class="nv">$2</span> --publicurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$EXT_HOST_IP&quot;</span><span class="s1">&#39;:8776/v1/$(tenant_id)s&#39;</span> --adminurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:8776/v1/$(tenant_id)s&#39;</span> --internalurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:8776/v1/$(tenant_id)s&#39;</span></div><div class='line' id='LC116'>&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC117'>&nbsp;&nbsp;&nbsp;&nbsp;image<span class="o">)</span></div><div class='line' id='LC118'>&nbsp;&nbsp;&nbsp;&nbsp;keystone endpoint-create --region <span class="nv">$KEYSTONE_REGION</span> --service-id <span class="nv">$2</span> --publicurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$EXT_HOST_IP&quot;</span><span class="s1">&#39;:9292/v2&#39;</span> --adminurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:9292/v2&#39;</span> --internalurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:9292/v2&#39;</span></div><div class='line' id='LC119'>&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC120'>&nbsp;&nbsp;&nbsp;&nbsp;identity<span class="o">)</span></div><div class='line' id='LC121'>&nbsp;&nbsp;&nbsp;&nbsp;keystone endpoint-create --region <span class="nv">$KEYSTONE_REGION</span> --service-id <span class="nv">$2</span> --publicurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$EXT_HOST_IP&quot;</span><span class="s1">&#39;:5000/v2.0&#39;</span> --adminurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:35357/v2.0&#39;</span> --internalurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:5000/v2.0&#39;</span></div><div class='line' id='LC122'>&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC123'>&nbsp;&nbsp;&nbsp;&nbsp;ec2<span class="o">)</span></div><div class='line' id='LC124'>&nbsp;&nbsp;&nbsp;&nbsp;keystone endpoint-create --region <span class="nv">$KEYSTONE_REGION</span> --service-id <span class="nv">$2</span> --publicurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$EXT_HOST_IP&quot;</span><span class="s1">&#39;:8773/services/Cloud&#39;</span> --adminurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:8773/services/Admin&#39;</span> --internalurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:8773/services/Cloud&#39;</span></div><div class='line' id='LC125'>&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC126'>&nbsp;&nbsp;&nbsp;&nbsp;network<span class="o">)</span></div><div class='line' id='LC127'>&nbsp;&nbsp;&nbsp;&nbsp;keystone endpoint-create --region <span class="nv">$KEYSTONE_REGION</span> --service-id <span class="nv">$2</span> --publicurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$EXT_HOST_IP&quot;</span><span class="s1">&#39;:9696/&#39;</span> --adminurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:9696/&#39;</span> --internalurl <span class="s1">&#39;http://&#39;</span><span class="s2">&quot;$HOST_IP&quot;</span><span class="s1">&#39;:9696/&#39;</span></div><div class='line' id='LC128'>&nbsp;&nbsp;&nbsp;&nbsp;;;</div><div class='line' id='LC129'>&nbsp;&nbsp;<span class="k">esac</span></div><div class='line' id='LC130'><span class="o">}</span></div><div class='line' id='LC131'><br/></div><div class='line' id='LC132'><span class="k">for </span>i in compute volume image object-store identity ec2 network; <span class="k">do</span></div><div class='line' id='LC133'><span class="k">  </span><span class="nv">id</span><span class="o">=</span><span class="sb">`</span>mysql -h <span class="s2">&quot;$MYSQL_HOST&quot;</span> -u <span class="s2">&quot;$MYSQL_USER&quot;</span> -p<span class="s2">&quot;$MYSQL_PASSWORD&quot;</span> <span class="s2">&quot;$MYSQL_DATABASE&quot;</span> -ss -e <span class="s2">&quot;SELECT id FROM service WHERE type=&#39;&quot;</span><span class="nv">$i</span><span class="s2">&quot;&#39;;&quot;</span><span class="sb">`</span> <span class="o">||</span> <span class="nb">exit </span>1</div><div class='line' id='LC134'>&nbsp;&nbsp;create_endpoint <span class="nv">$i</span> <span class="nv">$id</span></div><div class='line' id='LC135'><span class="k">done</span></div></pre></div>
          </td>
        </tr>
      </table>
  </div>

          </div>
        </div>

        <a href="#jump-to-line" rel="facebox" data-hotkey="l" class="js-jump-to-line" style="display:none">Jump to Line</a>
        <div id="jump-to-line" style="display:none">
          <h2>Jump to Line</h2>
          <form accept-charset="UTF-8" class="js-jump-to-line-form">
            <input class="textfield js-jump-to-line-field" type="text">
            <div class="full-button">
              <button type="submit" class="button">Go</button>
            </div>
          </form>
        </div>

      </div>
    </div>
</div>

<div id="js-frame-loading-template" class="frame frame-loading large-loading-area" style="display:none;">
  <img class="js-frame-loading-spinner" src="https://a248.e.akamai.net/assets.github.com/images/spinners/octocat-spinner-128.gif?1347543525" height="64" width="64">
</div>


        </div>
      </div>
      <div class="modal-backdrop"></div>
    </div>

      <div id="footer-push"></div><!-- hack for sticky footer -->
    </div><!-- end of wrapper - hack for sticky footer -->

      <!-- footer -->
      <div id="footer">
  <div class="container clearfix">

      <dl class="footer_nav">
        <dt>GitHub</dt>
        <dd><a href="https://github.com/about">About us</a></dd>
        <dd><a href="https://github.com/blog">Blog</a></dd>
        <dd><a href="https://github.com/contact">Contact &amp; support</a></dd>
        <dd><a href="http://enterprise.github.com/">GitHub Enterprise</a></dd>
        <dd><a href="http://status.github.com/">Site status</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Applications</dt>
        <dd><a href="http://mac.github.com/">GitHub for Mac</a></dd>
        <dd><a href="http://windows.github.com/">GitHub for Windows</a></dd>
        <dd><a href="http://eclipse.github.com/">GitHub for Eclipse</a></dd>
        <dd><a href="http://mobile.github.com/">GitHub mobile apps</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Services</dt>
        <dd><a href="http://get.gaug.es/">Gauges: Web analytics</a></dd>
        <dd><a href="http://speakerdeck.com">Speaker Deck: Presentations</a></dd>
        <dd><a href="https://gist.github.com">Gist: Code snippets</a></dd>
        <dd><a href="http://jobs.github.com/">Job board</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Documentation</dt>
        <dd><a href="http://help.github.com/">GitHub Help</a></dd>
        <dd><a href="http://developer.github.com/">Developer API</a></dd>
        <dd><a href="http://github.github.com/github-flavored-markdown/">GitHub Flavored Markdown</a></dd>
        <dd><a href="http://pages.github.com/">GitHub Pages</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>More</dt>
        <dd><a href="http://training.github.com/">Training</a></dd>
        <dd><a href="https://github.com/edu">Students &amp; teachers</a></dd>
        <dd><a href="http://shop.github.com">The Shop</a></dd>
        <dd><a href="/plans">Plans &amp; pricing</a></dd>
        <dd><a href="http://octodex.github.com/">The Octodex</a></dd>
      </dl>

      <hr class="footer-divider">


    <p class="right">&copy; 2013 <span title="0.06529s from fe17.rs.github.com">GitHub</span>, Inc. All rights reserved.</p>
    <a class="left" href="https://github.com/">
      <span class="mega-octicon octicon-mark-github"></span>
    </a>
    <ul id="legal">
        <li><a href="https://github.com/site/terms">Terms of Service</a></li>
        <li><a href="https://github.com/site/privacy">Privacy</a></li>
        <li><a href="https://github.com/security">Security</a></li>
    </ul>

  </div><!-- /.container -->

</div><!-- /.#footer -->


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
          <div class="suggester-container">
              <div class="suggester fullscreen-suggester js-navigation-container" id="fullscreen_suggester"
                 data-url="/mseknibilel/OpenStack-Grizzly-Install-Guide/suggestions/commit">
              </div>
          </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped leftwards" title="Exit Zen Mode">
      <span class="mega-octicon octicon-screen-normal"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped leftwards"
      title="Switch themes">
      <span class="octicon octicon-color-mode"></span>
    </a>
  </div>
</div>



    <div id="ajax-error-message" class="flash flash-error">
      <span class="octicon octicon-alert"></span>
      Something went wrong with that request. Please try again.
      <a href="#" class="octicon octicon-remove-close ajax-error-dismiss"></a>
    </div>

    
    
    <span id='server_response_time' data-time='0.06579' data-host='fe17'></span>
    
  </body>
</html>

