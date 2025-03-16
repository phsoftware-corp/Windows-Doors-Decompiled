class com.gskinner.controls.SimpleTabBox extends MovieClip
{
   var sampleTab;
   var doLaterMethods;
   var model;
   var clipList;
   var mask;
   var cover;
   var tabList;
   var __width;
   var __height;
   var _tmpModel;
   var bg;
   var currentTab;
   var dispatchEvent;
   var destroyChildAt;
   var doLaterIntervalID;
   static var CLASS_REF = com.gskinner.controls.SimpleTabBox;
   static var LINKAGE_ID = "SimpleTabBox";
   static var SELECTED_DEPTH = 201;
   var nextDepth = 300;
   var _selected = -1;
   var _tabLinkage = "SimpleTab";
   var _bgLinkage = "SimpleBackground";
   var loaded = false;
   var _enabled = true;
   function SimpleTabBox()
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.sampleTab = this.attachMovie(this.tabLinkage,"sampleTab",1000,{label:"yS",_visible:false});
      this.doLaterMethods = {};
      this.model = [];
      this.clipList = [];
   }
   function onLoad()
   {
      this.init();
   }
   function init()
   {
      this.mask = this.createEmptyMovieClip("mask",400);
      this.mask._visible = false;
      this.mask.beginFill(16750848);
      this.mask.moveTo(0,0);
      this.mask.lineTo(100,0);
      this.mask.lineTo(100,100);
      this.mask.lineTo(0,100);
      this.mask.lineTo(0,0);
      this.mask.endFill();
      this.cover = this.createEmptyMovieClip("cover",401);
      this.cover._visible = false;
      this.cover.beginFill(16777215,70);
      this.cover.moveTo(0,0);
      this.cover.lineTo(100,0);
      this.cover.lineTo(100,100);
      this.cover.lineTo(0,100);
      this.cover.lineTo(0,0);
      this.cover.endFill();
      this.cover.onRelease = function()
      {
      };
      this.cover.useHandCursor = false;
      this.configUI();
   }
   function createChild(p_linkage, p_instance, p_props, p_initObj)
   {
      return this.createChildAt(this.length,p_linkage,p_instance,p_props,p_initObj);
   }
   function createChildAt(p_index, p_linkage, p_instance, p_props, p_initObj)
   {
      this.nextDepth = this.nextDepth + 1;
      p_index = Math.max(0,Math.min(this.length,p_index));
      if(p_instance == undefined)
      {
         p_instance = "instance" + this.nextDepth;
      }
      this.model.splice(p_index,0,{label:p_props.label,linkage:p_linkage});
      if(!this.loaded)
      {
         return undefined;
      }
      var _loc2_ = this.attachMovie(p_linkage,p_instance,this.nextDepth,{_visible:false,_x:3,_y:this.sampleTab.height + 3});
      if(_loc2_ == undefined)
      {
         _loc2_ = this.createEmptyMovieClip(p_instance,this.nextDepth);
         _loc2_._x = 3;
         _loc2_._y = this.sampleTab._y + 3;
         _loc2_._visible = false;
      }
      this.clipList.splice(p_index,1,_loc2_);
      this.doLater("draw");
      return _loc2_;
   }
   function getChildAt(p_index)
   {
      return this.clipList[p_index];
   }
   function getTabAt(p_index)
   {
      if(!this.loaded)
      {
         return this.model[p_index];
      }
      return this.tabList[p_index];
   }
   function getInstance(p_name)
   {
      var _loc3_ = this.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc3_)
      {
         if(this.clipList[_loc2_]._name == p_name)
         {
            return this.clipList[_loc2_];
         }
         _loc2_ = _loc2_ + 1;
      }
      return null;
   }
   function getIndex(p_instance)
   {
      var _loc4_ = this.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc4_)
      {
         if(p_instance instanceof String)
         {
            if(this.clipList[_loc2_]._name == p_instance)
            {
               return _loc2_;
            }
         }
         else if(p_instance instanceof MovieClip)
         {
            if(this.clipList[_loc2_] == p_instance)
            {
               return _loc2_;
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      return -1;
   }
   function removeInstance(p_instance)
   {
      var _loc2_ = this.getIndex(p_instance);
      return this.removeChildAt(_loc2_);
   }
   function removeChildAt(p_index)
   {
      if(this.getChildAt(p_index) == undefined)
      {
         return false;
      }
      this.clipList[p_index].removeMovieClip();
      this.clipList.splice(p_index,1);
      this.tabList[p_index].removeMovieClip();
      this.tabList.splice(p_index,1);
      this.model.splice(p_index,1);
      if(this.selectedIndex >= p_index)
      {
         this.selectedIndex = this.selectedIndex - 1;
      }
      this.doLater("draw");
      return true;
   }
   function removeAll()
   {
      this.dataProvider = [];
      while(this.tabList.length)
      {
         this.tabList.pop().removeMovieClip();
      }
      while(this.clipList.length)
      {
         this.clipList.pop().removeMovieClip();
      }
      this.model = [];
      this.selectedIndex = -1;
      this.doLater("draw");
   }
   function setSize(p_width, p_height)
   {
      this.__width = p_width;
      this.__height = p_height;
      this.doLater("draw");
   }
   function move(p_x, p_y)
   {
      this._x = p_x;
      this._y = p_y;
   }
   function get dataProvider()
   {
      return this.model;
   }
   function set dataProvider(p_dp)
   {
      this._tmpModel = p_dp;
      while(this.clipList.length)
      {
         this.clipList.pop().removeMovieClip();
      }
      this.clipList = [];
      var _loc5_ = 300;
      var _loc4_ = this._tmpModel.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc4_)
      {
         this.createChild(this._tmpModel[_loc2_].linkage,this._tmpModel[_loc2_].name,{label:this._tmpModel[_loc2_].label});
         _loc2_ = _loc2_ + 1;
      }
      this.doLater("draw");
   }
   function get length()
   {
      return this.model.length;
   }
   function get numChildren()
   {
      return this.model.length;
   }
   function get selectedIndex()
   {
      return this._selected != -1 ? this._selected : 0;
   }
   function set selectedIndex(p_index)
   {
      if(this._selected == p_index)
      {
         return;
      }
      this._selected = p_index;
      this.doLater("drawTabs");
   }
   function get tabLinkage()
   {
      return this._tabLinkage;
   }
   function set tabLinkage(p_linkage)
   {
      this._tabLinkage = p_linkage;
      this.sampleTab = this.attachMovie(this.tabLinkage,"sampleTab",1000,{label:"yS",_visible:false});
      this.doLater("draw");
   }
   function get background()
   {
      return this._bgLinkage;
   }
   function set background(p_linkage)
   {
      this._bgLinkage = p_linkage;
      this.bg.removeMovieClip();
      this.bg = this.attachMovie(this._bgLinkage,"bg",200,{_y:this.sampleTab.height});
      this.doLater("draw");
   }
   function get width()
   {
      return this.__width;
   }
   function get height()
   {
      return this.__height;
   }
   function get enabled()
   {
      return this._enabled;
   }
   function set enabled(p_enabled)
   {
      this._enabled = p_enabled;
      var _loc3_ = this.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc3_)
      {
         if(this.loaded)
         {
            this.getTabAt(_loc2_).enabled = this.enabled;
         }
         this.model[_loc2_].enabled = this.enabled;
         _loc2_ = _loc2_ + 1;
      }
      var _loc4_ = this.getTabIndex(this.currentTab);
      this.clipList[_loc4_]._visible = this.enabled;
   }
   function click(p_evtObj)
   {
      var _loc2_ = this.getTabIndex(p_evtObj.target);
      if(_loc2_ == -1)
      {
         return undefined;
      }
      this.dispatchEvent({type:"click"});
      this.selectedIndex = _loc2_;
   }
   function change(p_evtObj)
   {
      var _loc2_ = this.getTabIndex(p_evtObj.target);
      this.dataProvider[_loc2_].enabled = p_evtObj.target.enabled;
      this.dataProvider[_loc2_].label = p_evtObj.target.label;
      this.doLater("drawTabs");
   }
   function configUI()
   {
      this.model = [];
      var _loc3_ = this._width;
      var _loc2_ = this._height;
      this._xscale = this._yscale = 100;
      if(this.width == undefined)
      {
         this.setSize(_loc3_,_loc2_);
      }
      this.destroyChildAt = this.removeChildAt;
      this.loaded = true;
      this.background = this._bgLinkage;
      this.dataProvider = this._tmpModel;
   }
   function draw()
   {
      if(!this.loaded)
      {
         return undefined;
      }
      if(this.bg.setSize != undefined)
      {
         this.bg.setSize(this.width,this.height - this.bg._y);
      }
      else
      {
         this.bg._width = this.width;
         this.bg._height = this.height - this.bg._y;
      }
      this.mask._y = this.cover._y = this.sampleTab._height + 3;
      this.mask._x = this.cover._x = 3;
      var _loc4_ = this.width - 6;
      var _loc3_ = this.height - this.mask._y - 3;
      this.mask._width = this.cover._width = _loc4_;
      this.mask._height = this.cover._height = _loc3_;
      var _loc2_ = 0;
      while(_loc2_ < this.length)
      {
         if(this.clipList[_loc2_].setSize != undefined)
         {
            this.clipList[_loc2_].setSize(this.width - 6,this.height - this.mask._y - 3);
         }
         _loc2_ = _loc2_ + 1;
      }
      this.drawTabs();
   }
   function drawTabs()
   {
      if(!this.loaded)
      {
         return undefined;
      }
      while(this.tabList.length)
      {
         this.tabList.pop().removeMovieClip();
      }
      this.tabList = [];
      var _loc2_ = undefined;
      var _loc11_ = this.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc11_)
      {
         var _loc4_ = 199 - _loc3_;
         var _loc5_ = _loc2_ != undefined ? _loc2_._x + (_loc2_.width != undefined ? _loc2_.width : _loc2_._width) : 2;
         _loc2_ = this.attachMovie(this.tabLinkage,"tab" + _loc3_,_loc4_,{index:_loc3_,label:this.model[_loc3_].label,_x:_loc5_,__enabled:this.model[_loc3_].enabled != false,depth:_loc4_});
         if(_loc2_._x + _loc2_._width > this.width)
         {
            _loc2_.removeMovieClip();
            break;
         }
         _loc2_.enabled = this._enabled;
         _loc2_.addEventListener("click",this);
         _loc2_.addEventListener("change",this);
         this.tabList.push(_loc2_);
         _loc3_ = _loc3_ + 1;
      }
      this.selectTab(this.selectedIndex);
   }
   function getTabIndex(p_tab)
   {
      var _loc3_ = this.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc3_)
      {
         if(this.tabList[_loc2_] == p_tab)
         {
            return _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      return -1;
   }
   function selectTab(p_index)
   {
      var _loc3_ = this.getTabIndex(this.currentTab);
      this.clipList[_loc3_]._visible = false;
      this.currentTab.swapDepths(this.currentTab.depth);
      this.currentTab.selected = false;
      this.currentTab.useHandCursor = true;
      this.currentTab = this.tabList[p_index];
      var _loc2_ = this.clipList[p_index];
      _loc2_._visible = true;
      this.cover._visible = this.model[p_index].enabled == false || this.enabled == false;
      _loc2_.setMask(this.mask);
      this.currentTab.swapDepths(com.gskinner.controls.SimpleTabBox.SELECTED_DEPTH);
      this.currentTab.selected = true;
      this.currentTab.useHandCursor = false;
   }
   function doLater(p_fn)
   {
      this.doLaterMethods[p_fn] = true;
      if(!this.doLaterIntervalID)
      {
         this.doLaterIntervalID = setInterval(this,"doLaterDispatcher",1);
      }
   }
   function doLaterDispatcher()
   {
      for(var _loc2_ in this.doLaterMethods)
      {
         this[_loc2_]();
         delete this.doLaterMethods[_loc2_];
      }
      clearInterval(this.doLaterIntervalID);
      delete this.doLaterIntervalID;
   }
}
