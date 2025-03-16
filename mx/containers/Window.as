class mx.containers.Window extends mx.core.ScrollView
{
   var __contentPath;
   var boundingBox_mc;
   var modalWindow;
   var regX;
   var regY;
   var onMouseMove;
   var back_mc;
   var depth;
   var titleStyleDeclaration;
   var button_mc;
   var validateNow;
   var _title;
   var _child0;
   var border_mc;
   var vScroller;
   var hScroller;
   var closeButton;
   var dispatchEvent;
   static var symbolName = "Window";
   static var symbolOwner = mx.containers.Window;
   static var version = "2.0.2.127";
   var className = "Window";
   static var skinIDBorder = 0;
   static var skinIDTitleBackground = 1;
   static var skinIDForm = 2;
   var idNames = new Array("border_mc","back_mc","content");
   var skinTitleBackground = "TitleBackground";
   var skinCloseUp = "CloseButtonUp";
   var skinCloseOver = "CloseButtonOver";
   var skinCloseDown = "CloseButtonDown";
   var skinCloseDisabled = "CloseButtonDisabled";
   var clipParameters = {title:1,contentPath:1,closeButton:1};
   static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.containers.Window.prototype.clipParameters,mx.core.ScrollView.prototype.clipParameters);
   var initializing = true;
   var loadingChild = false;
   function Window()
   {
      super();
   }
   function set contentPath(scrollableContent)
   {
      if(!this.initializing)
      {
         if(scrollableContent == undefined)
         {
            this.destroyChildAt(0);
         }
         else
         {
            if(this[mx.core.View.childNameBase + 0] != undefined)
            {
               this.destroyChildAt(0);
            }
            this.createChild(scrollableContent,"content",{styleName:this});
         }
      }
      this.__contentPath = scrollableContent;
   }
   function get contentPath()
   {
      return this.__contentPath;
   }
   function init(Void)
   {
      super.init();
      this.boundingBox_mc._visible = false;
      this.boundingBox_mc._width = this.boundingBox_mc._height = 0;
   }
   function delegateClick(obj)
   {
      this._parent.dispatchEvent({type:"click"});
   }
   function startDragging(Void)
   {
      if(this.modalWindow == undefined)
      {
         var _loc2_ = this._parent.createChildAtDepth("BoundingBox",mx.managers.DepthManager.kTop,{_visible:false});
         this.swapDepths(_loc2_);
         _loc2_.removeMovieClip();
      }
      this.regX = this._xmouse;
      this.regY = this._ymouse;
      this.onMouseMove = this.dragTracking;
   }
   function stopDragging(Void)
   {
      delete this.onMouseMove;
   }
   function dragTracking()
   {
      var _loc5_ = this._parent._xmouse - this.regX;
      var _loc4_ = this._parent._ymouse - this.regY;
      var _loc3_ = 5;
      var _loc2_ = mx.managers.SystemManager.screen;
      if(_loc5_ < _loc2_.x - this.regX + _loc3_)
      {
         _loc5_ = _loc2_.x - this.regX + _loc3_;
      }
      if(_loc5_ > _loc2_.width + _loc2_.x - (this.regX + _loc3_))
      {
         _loc5_ = _loc2_.width + _loc2_.x - (this.regX + _loc3_);
      }
      if(_loc4_ < _loc2_.y - this.regY + _loc3_)
      {
         _loc4_ = _loc2_.y - this.regY + _loc3_;
      }
      if(_loc4_ > _loc2_.height + _loc2_.y - (this.regY + _loc3_))
      {
         _loc4_ = _loc2_.height + _loc2_.y - (this.regY + _loc3_);
      }
      this.move(_loc5_,_loc4_);
      updateAfterEvent();
   }
   function createChildren(Void)
   {
      super.createChildren();
      if(this.back_mc == undefined)
      {
         this.createClassObject(mx.core.UIObject,"back_mc",1);
         this.back_mc.createObject(this.skinTitleBackground,"back_mc",0);
      }
      this.back_mc.visible = false;
      this.depth = 3;
      var _loc6_ = new Object();
      this.back_mc.useHandCursor = false;
      this.back_mc.onPress = function()
      {
         if(this._parent.enabled)
         {
            this._parent.startDragging();
         }
      };
      this.back_mc.onDragOut = this.back_mc.onRollOut = this.back_mc.onReleaseOutside = this.back_mc.onRelease = function()
      {
         var _loc2_ = this._parent;
         _loc2_.stopDragging();
      };
      this.back_mc.tabEnabled = false;
      if(this.back_mc.title_mc == undefined)
      {
         this.back_mc.createLabel("title_mc",1,this.title);
         var _loc4_ = this.back_mc.title_mc;
         if(this.titleStyleDeclaration == undefined)
         {
            _loc4_.fontSize = 10;
            _loc4_.color = 16777215;
            _loc4_.fontWeight = "bold";
         }
         else
         {
            _loc4_.styleName = this.titleStyleDeclaration;
         }
         _loc4_.invalidateStyle();
      }
      else
      {
         this.back_mc.title_mc.text = this.title;
      }
      var _loc3_ = new Object();
      _loc3_.falseUpSkin = this.skinCloseUp;
      _loc3_.falseOverSkin = this.skinCloseOver;
      _loc3_.falseDownSkin = this.skinCloseDown;
      _loc3_.falseDisabledSkin = this.skinCloseDisabled;
      _loc3_.tabEnabled = false;
      this.createClassObject(mx.controls.SimpleButton,"button_mc",2,_loc3_);
      this.button_mc.clickHandler = this.delegateClick;
      this.button_mc.visible = false;
      if(this.validateNow)
      {
         this.redraw(true);
      }
      else
      {
         this.invalidate();
      }
   }
   function get title()
   {
      return this._title;
   }
   function set title(s)
   {
      this._title = s;
      this.back_mc.title_mc.text = s;
      if(!this.initializing)
      {
         this.draw();
      }
   }
   function setEnabled(enable)
   {
      super.setEnabled(enable);
      this.button_mc.enabled = enable;
      this._child0.enabled = enable;
   }
   function getComponentCount(Void)
   {
      return 1;
   }
   function getComponentRect(container)
   {
      if(container == 1)
      {
         var _loc3_ = this.border_mc.borderMetrics;
         var _loc2_ = new Object();
         _loc2_.x = _loc3_.left;
         _loc2_.y = _loc3_.top + this.back_mc.height;
         _loc2_.width = this.width - _loc2_.x - _loc3_.right;
         _loc2_.height = this.height - _loc2_.y - _loc3_.bottom;
         return _loc2_;
      }
      return undefined;
   }
   function draw(Void)
   {
      if(this.initializing)
      {
         this.initializing = false;
         if(this.__contentPath != undefined)
         {
            this.contentPath = this.__contentPath;
         }
         this._child0.visible = true;
         this.border_mc.visible = true;
         this.back_mc.visible = true;
      }
      this.size();
   }
   function getViewMetrics(Void)
   {
      var _loc3_ = super.getViewMetrics();
      _loc3_.top += this.back_mc.height;
      return _loc3_;
   }
   function doLayout(Void)
   {
      super.doLayout();
      var _loc3_ = this.border_mc.borderMetrics;
      _loc3_.right += this.vScroller.visible != true ? 0 : this.vScroller.width;
      _loc3_.bottom += this.hScroller.visible != true ? 0 : this.hScroller.height;
      var _loc4_ = _loc3_.left;
      var _loc6_ = _loc3_.top;
      this.back_mc.move(_loc4_,_loc6_);
      this.back_mc.back_mc.setSize(this.width - _loc4_ - _loc3_.right,this.back_mc.height);
      this._child0.move(_loc4_,_loc6_ + this.back_mc.height);
      if(this._child0.size != mx.core.UIObject.prototype.size)
      {
         this._child0.setSize(this.width - _loc4_ - _loc3_.right,this.height - _loc6_ - this.back_mc.height - _loc3_.bottom);
      }
      this.button_mc.visible = this.closeButton == true;
      this.button_mc.move(this.width - _loc4_ - _loc4_ - this.button_mc.width,(this.back_mc.height - this.button_mc.height) / 2 + _loc6_);
      var _loc7_ = this.back_mc.title_mc.textHeight;
      var _loc5_ = (this.back_mc.height - _loc7_ - 4) / 2;
      this.back_mc.title_mc.move(_loc5_,_loc5_ - 1);
      this.back_mc.title_mc.setSize(this.width - _loc5_ - _loc5_,_loc7_ + 4);
   }
   function createChild(id, name, props)
   {
      this.loadingChild = true;
      var _loc3_ = super.createChild(id,name,props);
      this.loadingChild = false;
      return _loc3_;
   }
   function childLoaded(obj)
   {
      super.childLoaded(obj);
      if(this.loadingChild)
      {
         this.dispatchEvent({type:"complete",current:obj.getBytesLoaded(),total:obj.getBytesTotal()});
      }
   }
}
