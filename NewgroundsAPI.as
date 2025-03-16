class NewgroundsAPI
{
   var firstChild;
   static var tracker_id;
   static var host;
   static var version;
   static var debug;
   static var error_format;
   static var header_format;
   static var normal_format;
   static var link_format;
   static var movie_options = new Object();
   static var custom_events = new Object();
   static var custom_links = new Object();
   static var MOVIE_VIEWS = 1;
   static var AUTHOR_SITE = 2;
   static var NEWGROUNDS = 3;
   static var NEW_VERSION = 4;
   static var CUSTOM_STATS = 50;
   static var GATEWAY_URL = "http://www.ngads.com/gateway.php";
   function NewgroundsAPI()
   {
   }
   static function connectMovie(id)
   {
      if(!id)
      {
         NewgroundsAPI.SendError("Missing required \'id\' parameter in NewgroundsAPI.connectMovie(id:Number)");
      }
      else if(!NewgroundsAPI.tracker_id)
      {
         NewgroundsAPI.SendMessage("Connecting to API gateway...");
         NewgroundsAPI.tracker_id = id;
         NewgroundsAPI.host = _url.split("/")[2].toLowerCase();
         if(NewgroundsAPI.host.length < 1)
         {
            NewgroundsAPI.host = "localhost";
         }
         var _loc2_ = new Object();
         NewgroundsAPI.SendEvent(NewgroundsAPI.MOVIE_VIEWS);
      }
   }
   static function setMovieVersion(movie_version)
   {
      if(!movie_version)
      {
         NewgroundsAPI.SendError("Missing required \'version\' in NewgroundsAPI.setMovieVersion(version:String)");
      }
      else
      {
         NewgroundsAPI.version = movie_version;
      }
   }
   static function debugMode()
   {
      NewgroundsAPI.debug = true;
   }
   static function addCustomEvent(stat_id, stat_name)
   {
      if(!stat_id)
      {
         NewgroundsAPI.SendError("Missing required \'id\' parameter in NewgroundsAPI.AddCustomEvent(id:Number, event_name:String)");
      }
      else if(!stat_name)
      {
         NewgroundsAPI.SendError("Missing required \'event_name\' parameter in NewgroundsAPI.AddCustomEvent(id:Number, event_name:String)");
      }
      else
      {
         NewgroundsAPI.custom_events[stat_name] = NewgroundsAPI.CUSTOM_STATS + stat_id;
         NewgroundsAPI.SendMessage("Created custom event: " + stat_name);
      }
   }
   static function addCustomLink(stat_id, stat_name)
   {
      if(!stat_id)
      {
         NewgroundsAPI.SendError("Missing required \'id\' parameter in NewgroundsAPI.AddCustomLink(id:Number, link_name:String)");
      }
      else if(!stat_name)
      {
         NewgroundsAPI.SendError("Missing required \'link_name\' parameter in NewgroundsAPI.AddCustomLink(id:Number, link_name:String)");
      }
      else
      {
         NewgroundsAPI.custom_links[stat_name] = NewgroundsAPI.CUSTOM_STATS + stat_id;
         NewgroundsAPI.SendMessage("Created custom link " + stat_id + ": " + stat_name);
      }
   }
   static function loadMySite()
   {
      NewgroundsAPI.SendLink(NewgroundsAPI.AUTHOR_SITE);
   }
   static function loadNewgrounds(special)
   {
      if(special)
      {
         var _loc1_ = {page:special};
      }
      NewgroundsAPI.SendLink(NewgroundsAPI.NEWGROUNDS,_loc1_);
   }
   static function logCustomEvent(event_name)
   {
      if(!event_name)
      {
         NewgroundsAPI.SendError("Missing required \'event_name\' parameter in NewgroundsAPI.logCustomEvent(event_name:String)");
      }
      else if(!NewgroundsAPI.custom_events[event_name])
      {
         NewgroundsAPI.SendError("Attempted to log undefined custom event: " + event_name);
      }
      else
      {
         NewgroundsAPI.SendEvent(NewgroundsAPI.custom_events[event_name]);
      }
   }
   static function loadCustomLink(link_name)
   {
      if(!link_name)
      {
         NewgroundsAPI.SendError("Missing required \'link_name\' parameter in NewgroundsAPI.loadCustomLink(link_name:String)");
      }
      else if(!NewgroundsAPI.custom_links[link_name])
      {
         NewgroundsAPI.SendError("Attempted to open undefined custom link: " + link_name);
      }
      else
      {
         NewgroundsAPI.SendLink(NewgroundsAPI.custom_links[link_name]);
      }
   }
   static function getAdURL()
   {
      return NewgroundsAPI.movie_options.ad_url;
   }
   static function getMovieURL()
   {
      if(NewgroundsAPI.movie_options.movie_url)
      {
         return NewgroundsAPI.movie_options.movie_url;
      }
      return "Newgrounds.com";
   }
   static function getNewVersionURL()
   {
      return NewgroundsAPI.GATEWAY_URL + "?&id=" + NewgroundsAPI.tracker_id + "&host=" + escape(NewgroundsAPI.host) + "&stat=" + NewgroundsAPI.NEW_VERSION;
   }
   static function SendEvent(id)
   {
      NewgroundsAPI.SendStat(id,false);
   }
   static function SendLink(id, extra)
   {
      NewgroundsAPI.SendStat(id,true,extra);
   }
   static function ReadGatewayData(params)
   {
      for(var _loc2_ in params)
      {
         params[_loc2_] = unescape(params[_loc2_]);
         NewgroundsAPI.movie_options[_loc2_] = params[_loc2_];
      }
      if(params.settings_loaded)
      {
         NewgroundsAPI.SendMessage("You have successfully connected to the Newgrounds API gateway!");
         NewgroundsAPI.SendMessage("Movie Identified as \'" + NewgroundsAPI.movie_options.movie_name + "\'");
         if(NewgroundsAPI.movie_options.message)
         {
            NewgroundsAPI.SendMessage(NewgroundsAPI.movie_options.message);
         }
         if(NewgroundsAPI.movie_options.ad_url)
         {
            NewgroundsAPI.SendMessage("Your movie has been approved to run Flash Ads");
            NewgroundsAPI.onAdsApproved(NewgroundsAPI.movie_options.ad_url);
         }
         if(NewgroundsAPI.movie_options.movie_version and NewgroundsAPI.movie_options.movie_version.toString() != NewgroundsAPI.version.toString())
         {
            NewgroundsAPI.SendMessage("WARNING: The movie version configured in your API settings does not match this movie\'s version!");
            NewgroundsAPI.onNewVersionAvailable(NewgroundsAPI.movie_options.movie_version,NewgroundsAPI.getMovieURL(),NewgroundsAPI.getNewVersionURL());
         }
         if(NewgroundsAPI.movie_options.deny_host)
         {
            NewgroundsAPI.SendMessage("You have blocked \'localHost\' in your API settings.");
            NewgroundsAPI.SendMessage("If you wish to test your movie you will need to remove this block.");
            NewgroundsAPI.onDenyHost(NewgroundsAPI.host,NewgroundsAPI.getMovieURL(),NewgroundsAPI.getNewVersionURL());
         }
         if(NewgroundsAPI.movie_options.request_portal_url == 1)
         {
            var _loc4_ = NewgroundsAPI.GATEWAY_URL + "?&id=" + NewgroundsAPI.tracker_id + "&portal_url=" + escape(_url);
            var _loc3_ = new XML();
            _loc3_.ignoreWhite = true;
            _loc3_.load(_loc4_);
         }
      }
      else if(!NewgroundsAPI.movie_options.settings_loaded)
      {
         NewgroundsAPI.SendError("Could not establish connection to the API gateway.");
      }
   }
   static function SendStat(stat_id, open_in_browser, extra)
   {
      if(!NewgroundsAPI.tracker_id)
      {
         NewgroundsAPI.SendError("API calls cannot be made without a valid movie id.");
         NewgroundsAPI.SendError("Did you remember to add the \"NewgroundsAPI.connectMovie()\" code?");
      }
      else
      {
         var _loc7_ = NewgroundsAPI.GATEWAY_URL + "?&id=" + NewgroundsAPI.tracker_id + "&host=" + escape(NewgroundsAPI.host) + "&stat=" + stat_id;
         for(var _loc9_ in extra)
         {
            _loc7_ += "&" + escape(_loc9_) + "=" + escape(extra[_loc9_]);
         }
         trace(_loc7_);
         if(NewgroundsAPI.debug)
         {
            _loc7_ += "&debug=1";
         }
         if(open_in_browser)
         {
            getURL(_loc7_,"_blank");
         }
         else
         {
            var _loc10_ = new XML();
            _loc10_.ignoreWhite = true;
            _loc10_.onLoad = function(success)
            {
               var _loc6_ = new Object();
               var _loc3_ = 0;
               while(_loc3_ < this.firstChild.childNodes.length)
               {
                  var _loc4_ = this.firstChild.childNodes[_loc3_];
                  var _loc5_ = _loc4_.nodeName;
                  var _loc2_ = _loc4_.attributes.value;
                  if(_loc2_ == Number(_loc2_))
                  {
                     _loc2_ = Number(_loc2_);
                  }
                  _loc6_[_loc5_] = _loc2_;
                  _loc3_ = _loc3_ + 1;
               }
               NewgroundsAPI.ReadGatewayData(_loc6_);
            };
            _loc10_.load(_loc7_);
         }
      }
   }
   static function SendError(msg)
   {
      trace("[NEWGROUNDS API ERROR] :: " + msg);
   }
   static function SendMessage(msg)
   {
      trace("[NEWGROUNDS API] :: " + msg);
   }
   static function InitTextFormats()
   {
      if(!NewgroundsAPI.error_format)
      {
         NewgroundsAPI.error_format = new TextFormat();
         NewgroundsAPI.error_format.font = "Arial Black";
         NewgroundsAPI.error_format.size = 48;
         NewgroundsAPI.error_format.color = 16711680;
      }
      if(!NewgroundsAPI.header_format)
      {
         NewgroundsAPI.header_format = new TextFormat();
         NewgroundsAPI.header_format.font = "Arial Black";
         NewgroundsAPI.header_format.size = 24;
         NewgroundsAPI.header_format.color = 16777215;
      }
      if(!NewgroundsAPI.normal_format)
      {
         NewgroundsAPI.normal_format = new TextFormat();
         NewgroundsAPI.normal_format.font = "Arial";
         NewgroundsAPI.normal_format.bold = true;
         NewgroundsAPI.normal_format.size = 12;
         NewgroundsAPI.normal_format.color = 16777215;
      }
      if(!NewgroundsAPI.link_format)
      {
         NewgroundsAPI.link_format = new TextFormat();
         NewgroundsAPI.link_format.color = 16776960;
         NewgroundsAPI.link_format.underline = true;
      }
   }
   static function onNewVersionAvailable(version, movie_url, redirect_url)
   {
      NewgroundsAPI.InitTextFormats();
      var _loc2_ = new Object();
      _loc2_.x = Stage.width / 2;
      _loc2_.y = Stage.height / 2;
      _root.createEmptyMovieClip("NGAPI_new_version_overlay",_root.getNextHighestDepth());
      _root.NGAPI_new_version_overlay.lineStyle(1,0,100);
      _root.NGAPI_new_version_overlay.beginFill(0,70);
      _root.NGAPI_new_version_overlay.moveTo(-10,-10);
      _root.NGAPI_new_version_overlay.lineTo(-10,1000);
      _root.NGAPI_new_version_overlay.lineTo(1000,1000);
      _root.NGAPI_new_version_overlay.lineTo(1000,-10);
      _root.NGAPI_new_version_overlay.lineTo(-10,-10);
      _root.NGAPI_new_version_overlay.endFill();
      _root.NGAPI_new_version_overlay.lineStyle(10,0,100);
      _root.NGAPI_new_version_overlay.beginFill(51);
      _root.NGAPI_new_version_overlay.moveTo(_loc2_.x - 240,_loc2_.y - 120);
      _root.NGAPI_new_version_overlay.lineTo(_loc2_.x + 240,_loc2_.y - 120);
      _root.NGAPI_new_version_overlay.lineTo(_loc2_.x + 240,_loc2_.y + 80);
      _root.NGAPI_new_version_overlay.lineTo(_loc2_.x - 240,_loc2_.y + 80);
      _root.NGAPI_new_version_overlay.lineTo(_loc2_.x - 240,_loc2_.y - 120);
      _root.NGAPI_new_version_overlay.endFill();
      _root.NGAPI_new_version_overlay.createEmptyMovieClip("exit",1000);
      _root.NGAPI_new_version_overlay.exit.lineStyle(2,39423,100);
      _root.NGAPI_new_version_overlay.exit.beginFill(0,50);
      _root.NGAPI_new_version_overlay.exit.moveTo(_loc2_.x + 210,_loc2_.y - 110);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 230,_loc2_.y - 110);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 230,_loc2_.y - 90);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 210,_loc2_.y - 90);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 210,_loc2_.y - 110);
      _root.NGAPI_new_version_overlay.exit.endFill();
      _root.NGAPI_new_version_overlay.exit.moveTo(_loc2_.x + 214,_loc2_.y - 106);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 226,_loc2_.y - 94);
      _root.NGAPI_new_version_overlay.exit.moveTo(_loc2_.x + 226,_loc2_.y - 106);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 214,_loc2_.y - 94);
      _root.NGAPI_new_version_overlay.exit.onMouseUp = function()
      {
         if(_root.NGAPI_new_version_overlay.exit.hitTest(_root._xmouse,_root._ymouse))
         {
            _root.NGAPI_new_version_overlay.removeMovieClip();
         }
      };
      var _loc3_ = "Version " + version + " is now available at:" + "\n";
      var _loc5_ = _loc3_.length;
      _loc3_ += movie_url;
      var _loc4_ = _loc3_.length;
      _root.NGAPI_new_version_overlay.createTextField("mouseblocker",99,-10,-10,1000,1000);
      _root.NGAPI_new_version_overlay.createTextField("newversion",100,_loc2_.x - 210,_loc2_.y - 90,400,80);
      _root.NGAPI_new_version_overlay.newversion.text = "New Version Available!";
      _root.NGAPI_new_version_overlay.newversion.setTextFormat(NewgroundsAPI.header_format);
      _root.NGAPI_new_version_overlay.createTextField("message",101,(Stage.width - 400) / 2,Stage.height / 2,400,40);
      _root.NGAPI_new_version_overlay.message.text = _loc3_;
      _root.NGAPI_new_version_overlay.message.multiline = true;
      _root.NGAPI_new_version_overlay.message.wordWrap = true;
      _root.NGAPI_new_version_overlay.message.html = true;
      _root.NGAPI_new_version_overlay.message.setTextFormat(NewgroundsAPI.normal_format);
      NewgroundsAPI.link_format.url = redirect_url;
      _root.NGAPI_new_version_overlay.message.setTextFormat(_loc5_,_loc4_,NewgroundsAPI.link_format);
   }
   static function onDenyHost(hostname, movie_url, redirect_url)
   {
      NewgroundsAPI.InitTextFormats();
      _root.createEmptyMovieClip("NGAPI_deny_host_overlay",_root.getNextHighestDepth());
      _root.NGAPI_deny_host_overlay.lineStyle(20,0,100);
      _root.NGAPI_deny_host_overlay.beginFill(6684672);
      _root.NGAPI_deny_host_overlay.moveTo(0,0);
      _root.NGAPI_deny_host_overlay.lineTo(Stage.width,0);
      _root.NGAPI_deny_host_overlay.lineTo(Stage.width,Stage.height);
      _root.NGAPI_deny_host_overlay.lineTo(0,Stage.height);
      _root.NGAPI_deny_host_overlay.lineTo(0,0);
      _root.NGAPI_deny_host_overlay.endFill();
      var _loc2_ = "This movie has not been approved for use on " + hostname + ".";
      _loc2_ += "\r\rFor an aproved copy, please visit:\r";
      var _loc4_ = _loc2_.length;
      _loc2_ += movie_url;
      var _loc3_ = _loc2_.length;
      _root.NGAPI_deny_host_overlay.createTextField("mousekill",100,0,0,Stage.width,Stage.height);
      _root.NGAPI_deny_host_overlay.createTextField("error",101,(Stage.width - 400) / 2,Stage.height / 2 - 100,400,200);
      _root.NGAPI_deny_host_overlay.error.text = "ERROR!";
      _root.NGAPI_deny_host_overlay.error.setTextFormat(NewgroundsAPI.error_format);
      _root.NGAPI_deny_host_overlay.createTextField("message",102,(Stage.width - 400) / 2,Stage.height / 2,400,200);
      _root.NGAPI_deny_host_overlay.message.text = _loc2_;
      _root.NGAPI_deny_host_overlay.message.multiline = true;
      _root.NGAPI_deny_host_overlay.message.wordWrap = true;
      _root.NGAPI_deny_host_overlay.message.html = true;
      _root.NGAPI_deny_host_overlay.message.setTextFormat(NewgroundsAPI.normal_format);
      NewgroundsAPI.link_format.url = redirect_url;
      _root.NGAPI_deny_host_overlay.message.setTextFormat(_loc4_,_loc3_,NewgroundsAPI.link_format);
   }
   static function isInstalled()
   {
      return true;
   }
   static function onAdsApproved(ad_url)
   {
   }
}
