  


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>OpenStack-Grizzly-Install-Guide/KeystoneScripts/keystone_basic.sh at OVS_MultiNode · mseknibilel/OpenStack-Grizzly-Install-Guide</title>
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

        <link data-pjax-transient rel='permalink' href='/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/ded74ab73d08eedd170854080f7d2c52666197e8/KeystoneScripts/keystone_basic.sh'>
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
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/Nicira_SingleNode/KeystoneScripts/keystone_basic.sh" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="Nicira_SingleNode" rel="nofollow" title="Nicira_SingleNode">Nicira_SingleNode</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item selected">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/OVS_MultiNode/KeystoneScripts/keystone_basic.sh" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="OVS_MultiNode" rel="nofollow" title="OVS_MultiNode">OVS_MultiNode</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/OVS_SingleNode/KeystoneScripts/keystone_basic.sh" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="OVS_SingleNode" rel="nofollow" title="OVS_SingleNode">OVS_SingleNode</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/master/KeystoneScripts/keystone_basic.sh" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="master" rel="nofollow" title="master">master</a>
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
          


<!-- blob contrib key: blob_contributors:v21:4915c7926373798f58e302266333b6c3 -->
<!-- blob contrib frag key: views10/v8/blob_contributors:v21:4915c7926373798f58e302266333b6c3 -->


<div id="slider">
    <div class="frame-meta">

      <p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

        <div class="breadcrumb">
          <span class='bold'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide" class="js-slide-to" data-branch="OVS_MultiNode" data-direction="back" itemscope="url"><span itemprop="title">OpenStack-Grizzly-Install-Guide</span></a></span></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/tree/OVS_MultiNode/KeystoneScripts" class="js-slide-to" data-branch="OVS_MultiNode" data-direction="back" itemscope="url"><span itemprop="title">KeystoneScripts</span></a></span><span class="separator"> / </span><strong class="final-path">keystone_basic.sh</strong> <span class="js-zeroclipboard zeroclipboard-button" data-clipboard-text="KeystoneScripts/keystone_basic.sh" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
        </div>

      <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/find/OVS_MultiNode" class="js-slide-to" data-hotkey="t" style="display:none">Show File Finder</a>


        
  <div class="commit file-history-tease">
    <img class="main-avatar" height="24" src="https://secure.gravatar.com/avatar/19e87be1da8e792ec19f87e976d8b7e9?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
    <span class="author"><a href="/mseknibilel" rel="author">mseknibilel</a></span>
    <time class="js-relative-date" datetime="2013-04-12T01:32:50-07:00" title="2013-04-12 01:32:50">April 12, 2013</time>
    <div class="commit-title">
        <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/commit/e0ebb56489a39e14790a81ff9e388f6a10795bb8" class="message">Update keystone_basic.sh</a>
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
      <div class="frame" data-permalink-url="/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/ded74ab73d08eedd170854080f7d2c52666197e8/KeystoneScripts/keystone_basic.sh" data-title="OpenStack-Grizzly-Install-Guide/KeystoneScripts/keystone_basic.sh at OVS_MultiNode · mseknibilel/OpenStack-Grizzly-Install-Guide · GitHub" data-type="blob">

        <div id="files" class="bubble">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><b class="octicon octicon-file-text"></b></span>
                <span class="mode" title="File Mode">file</span>
                  <span>57 lines (42 sloc)</span>
                <span>2.463 kb</span>
              </div>
              <div class="actions">
                <div class="button-group">
                        <a class="minibutton tooltipped leftwards"
                           title="Clicking this button will automatically fork this project so you can edit the file"
                           href="/mseknibilel/OpenStack-Grizzly-Install-Guide/edit/OVS_MultiNode/KeystoneScripts/keystone_basic.sh"
                           data-method="post" rel="nofollow">Edit</a>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/raw/OVS_MultiNode/KeystoneScripts/keystone_basic.sh" class="button minibutton " id="raw-url">Raw</a>
                    <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/blame/OVS_MultiNode/KeystoneScripts/keystone_basic.sh" class="button minibutton ">Blame</a>
                  <a href="/mseknibilel/OpenStack-Grizzly-Install-Guide/commits/OVS_MultiNode/KeystoneScripts/keystone_basic.sh" class="button minibutton " rel="nofollow">History</a>
                </div><!-- /.button-group -->
              </div><!-- /.actions -->

            </div>
                <div class="blob-wrapper data type-shell js-blob-data">
      <table class="file-code file-blob">
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

          </td>
          <td class="blob-line-code">
                  <div class="highlight"><pre><div class='line' id='LC1'><span class="c">#!/bin/sh</span></div><div class='line' id='LC2'><span class="c">#</span></div><div class='line' id='LC3'><span class="c"># Keystone basic configuration </span></div><div class='line' id='LC4'><br/></div><div class='line' id='LC5'><span class="c"># Mainly inspired by https://github.com/openstack/keystone/blob/master/tools/sample_data.sh</span></div><div class='line' id='LC6'><br/></div><div class='line' id='LC7'><span class="c"># Modified by Bilel Msekni / Institut Telecom</span></div><div class='line' id='LC8'><span class="c">#</span></div><div class='line' id='LC9'><span class="c"># Support: openstack@lists.launchpad.net</span></div><div class='line' id='LC10'><span class="c"># License: Apache Software License (ASL) 2.0</span></div><div class='line' id='LC11'><span class="c">#</span></div><div class='line' id='LC12'><span class="nv">HOST_IP</span><span class="o">=</span>10.10.10.51</div><div class='line' id='LC13'><span class="nv">ADMIN_PASSWORD</span><span class="o">=</span><span class="k">${</span><span class="nv">ADMIN_PASSWORD</span><span class="k">:-</span><span class="nv">admin_pass</span><span class="k">}</span></div><div class='line' id='LC14'><span class="nv">SERVICE_PASSWORD</span><span class="o">=</span><span class="k">${</span><span class="nv">SERVICE_PASSWORD</span><span class="k">:-</span><span class="nv">service_pass</span><span class="k">}</span></div><div class='line' id='LC15'><span class="nb">export </span><span class="nv">SERVICE_TOKEN</span><span class="o">=</span><span class="s2">&quot;ADMIN&quot;</span></div><div class='line' id='LC16'><span class="nb">export </span><span class="nv">SERVICE_ENDPOINT</span><span class="o">=</span><span class="s2">&quot;http://${HOST_IP}:35357/v2.0&quot;</span></div><div class='line' id='LC17'><span class="nv">SERVICE_TENANT_NAME</span><span class="o">=</span><span class="k">${</span><span class="nv">SERVICE_TENANT_NAME</span><span class="k">:-</span><span class="nv">service</span><span class="k">}</span></div><div class='line' id='LC18'><br/></div><div class='line' id='LC19'>get_id <span class="o">()</span> <span class="o">{</span></div><div class='line' id='LC20'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">echo</span> <span class="sb">`</span><span class="nv">$@</span> | awk <span class="s1">&#39;/ id / { print $4 }&#39;</span><span class="sb">`</span></div><div class='line' id='LC21'><span class="o">}</span></div><div class='line' id='LC22'><br/></div><div class='line' id='LC23'><span class="c"># Tenants</span></div><div class='line' id='LC24'><span class="nv">ADMIN_TENANT</span><span class="o">=</span><span class="k">$(</span>get_id keystone tenant-create --name<span class="o">=</span>admin<span class="k">)</span></div><div class='line' id='LC25'><span class="nv">SERVICE_TENANT</span><span class="o">=</span><span class="k">$(</span>get_id keystone tenant-create --name<span class="o">=</span><span class="nv">$SERVICE_TENANT_NAME</span><span class="k">)</span></div><div class='line' id='LC26'><br/></div><div class='line' id='LC27'><br/></div><div class='line' id='LC28'><span class="c"># Users</span></div><div class='line' id='LC29'><span class="nv">ADMIN_USER</span><span class="o">=</span><span class="k">$(</span>get_id keystone user-create --name<span class="o">=</span>admin --pass<span class="o">=</span><span class="s2">&quot;$ADMIN_PASSWORD&quot;</span> --email<span class="o">=</span>admin@domain.com<span class="k">)</span></div><div class='line' id='LC30'><br/></div><div class='line' id='LC31'><br/></div><div class='line' id='LC32'><span class="c"># Roles</span></div><div class='line' id='LC33'><span class="nv">ADMIN_ROLE</span><span class="o">=</span><span class="k">$(</span>get_id keystone role-create --name<span class="o">=</span>admin<span class="k">)</span></div><div class='line' id='LC34'><span class="nv">KEYSTONEADMIN_ROLE</span><span class="o">=</span><span class="k">$(</span>get_id keystone role-create --name<span class="o">=</span>KeystoneAdmin<span class="k">)</span></div><div class='line' id='LC35'><span class="nv">KEYSTONESERVICE_ROLE</span><span class="o">=</span><span class="k">$(</span>get_id keystone role-create --name<span class="o">=</span>KeystoneServiceAdmin<span class="k">)</span></div><div class='line' id='LC36'><br/></div><div class='line' id='LC37'><span class="c"># Add Roles to Users in Tenants</span></div><div class='line' id='LC38'>keystone user-role-add --user-id <span class="nv">$ADMIN_USER</span> --role-id <span class="nv">$ADMIN_ROLE</span> --tenant-id <span class="nv">$ADMIN_TENANT</span></div><div class='line' id='LC39'>keystone user-role-add --user-id <span class="nv">$ADMIN_USER</span> --role-id <span class="nv">$KEYSTONEADMIN_ROLE</span> --tenant-id <span class="nv">$ADMIN_TENANT</span></div><div class='line' id='LC40'>keystone user-role-add --user-id <span class="nv">$ADMIN_USER</span> --role-id <span class="nv">$KEYSTONESERVICE_ROLE</span> --tenant-id <span class="nv">$ADMIN_TENANT</span></div><div class='line' id='LC41'><br/></div><div class='line' id='LC42'><span class="c"># The Member role is used by Horizon and Swift</span></div><div class='line' id='LC43'><span class="nv">MEMBER_ROLE</span><span class="o">=</span><span class="k">$(</span>get_id keystone role-create --name<span class="o">=</span>Member<span class="k">)</span></div><div class='line' id='LC44'><br/></div><div class='line' id='LC45'><span class="c"># Configure service users/roles</span></div><div class='line' id='LC46'><span class="nv">NOVA_USER</span><span class="o">=</span><span class="k">$(</span>get_id keystone user-create --name<span class="o">=</span>nova --pass<span class="o">=</span><span class="s2">&quot;$SERVICE_PASSWORD&quot;</span> --tenant-id <span class="nv">$SERVICE_TENANT</span> --email<span class="o">=</span>nova@domain.com<span class="k">)</span></div><div class='line' id='LC47'>keystone user-role-add --tenant-id <span class="nv">$SERVICE_TENANT</span> --user-id <span class="nv">$NOVA_USER</span> --role-id <span class="nv">$ADMIN_ROLE</span></div><div class='line' id='LC48'><br/></div><div class='line' id='LC49'><span class="nv">GLANCE_USER</span><span class="o">=</span><span class="k">$(</span>get_id keystone user-create --name<span class="o">=</span>glance --pass<span class="o">=</span><span class="s2">&quot;$SERVICE_PASSWORD&quot;</span> --tenant-id <span class="nv">$SERVICE_TENANT</span> --email<span class="o">=</span>glance@domain.com<span class="k">)</span></div><div class='line' id='LC50'>keystone user-role-add --tenant-id <span class="nv">$SERVICE_TENANT</span> --user-id <span class="nv">$GLANCE_USER</span> --role-id <span class="nv">$ADMIN_ROLE</span></div><div class='line' id='LC51'><br/></div><div class='line' id='LC52'><span class="nv">QUANTUM_USER</span><span class="o">=</span><span class="k">$(</span>get_id keystone user-create --name<span class="o">=</span>quantum --pass<span class="o">=</span><span class="s2">&quot;$SERVICE_PASSWORD&quot;</span> --tenant-id <span class="nv">$SERVICE_TENANT</span> --email<span class="o">=</span>quantum@domain.com<span class="k">)</span></div><div class='line' id='LC53'>keystone user-role-add --tenant-id <span class="nv">$SERVICE_TENANT</span> --user-id <span class="nv">$QUANTUM_USER</span> --role-id <span class="nv">$ADMIN_ROLE</span></div><div class='line' id='LC54'><br/></div><div class='line' id='LC55'><span class="nv">CINDER_USER</span><span class="o">=</span><span class="k">$(</span>get_id keystone user-create --name<span class="o">=</span>cinder --pass<span class="o">=</span><span class="s2">&quot;$SERVICE_PASSWORD&quot;</span> --tenant-id <span class="nv">$SERVICE_TENANT</span> --email<span class="o">=</span>cinder@domain.com<span class="k">)</span></div><div class='line' id='LC56'>keystone user-role-add --tenant-id <span class="nv">$SERVICE_TENANT</span> --user-id <span class="nv">$CINDER_USER</span> --role-id <span class="nv">$ADMIN_ROLE</span></div></pre></div>
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


    <p class="right">&copy; 2013 <span title="0.06405s from fe17.rs.github.com">GitHub</span>, Inc. All rights reserved.</p>
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

    
    
    <span id='server_response_time' data-time='0.06454' data-host='fe17'></span>
    
  </body>
</html>

