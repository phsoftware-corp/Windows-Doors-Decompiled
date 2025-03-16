class mx.controls.MenuBar extends mx.core.UIComponent
{
   var __menus;
   var __menuBarItems;
   var __labels;
   var boundingBox_mc;
   var invUpdateDisplay;
   var invUpdateSize;
   var openMenuIndex;
   var dispatchEvent;
   var supposedToLoseFocus;
   var background_mc;
   var __menuDataProvider;
   var labelFunction;
   var __height;
   var enableByPass;
   var mask_mc;
   var __width;
   var isDown;
   static var symbolName = "MenuBar";
   static var symbolOwner = mx.controls.MenuBar;
   static var version = "2.0.2.127";
   var className = "MenuBar";
   static var _s_MenuIndex = 0;
   var topItemDepth = 200;
   var menuBarBackLeftName = "MenuBarBackLeft";
   var menuBarBackRightName = "MenuBarBackRight";
   var menuBarBackMiddleName = "MenuBarBackMiddle";
   var __backgroundWidth = 550;
   var __marginWidth = 10;
   var tabChildren = false;
   var labelField = "label";
   var clipParameters = {enabled:1,visible:1,labels:1,minWidth:1,minHeight:1};
   var rebroadcastEvents = {menuHide:1,menuShow:1,rollOver:1,rollOut:1,change:1};
   function MenuBar()
   {
      super();
   }
   function init(Void)
   {
      super.init();
      this.__menus = new Object();
      this.__menuBarItems = new Array();
      var _loc3_ = 0;
      while(_loc3_ < this.__labels.length)
      {
         this.addMenu(this.__labels[_loc3_]);
         _loc3_ = _loc3_ + 1;
      }
      this.boundingBox_mc._visible = false;
      this.boundingBox_mc._width = this.boundingBox_mc._height = 0;
   }
   function draw(Void)
   {
      super.draw();
      if(this.invUpdateDisplay)
      {
         this.updateDisplay(this.invUpdateSize);
      }
   }
   function handleEvent(event)
   {
      var _loc2_ = event.type;
      if(_loc2_ == "menuHide")
      {
         if(event.menu.menuBarIndex == this.openMenuIndex)
         {
            this.__menuBarItems[this.openMenuIndex].setLabelBorder("none");
            delete this.openMenuIndex;
         }
      }
      if(this.rebroadcastEvents[_loc2_])
      {
         event.target = this;
         this.dispatchEvent(event);
      }
   }
   function onSetFocus()
   {
      super.onSetFocus();
      this.getFocusManager().defaultPushButtonEnabled = false;
   }
   function onKillFocus()
   {
      super.onKillFocus();
      this.getFocusManager().defaultPushButtonEnabled = true;
      if(this.supposedToLoseFocus == undefined)
      {
         this.getMenuAt(this.openMenuIndex).hide();
      }
      delete this.supposedToLoseFocus;
   }
   function createChildren(Void)
   {
      super.createChildren();
      if(this.background_mc == undefined)
      {
         this.createEmptyMovieClip("background_mc",0);
         this.background_mc.createObject(this.menuBarBackLeftName,"bckLeft",1);
         this.background_mc.createObject(this.menuBarBackRightName,"bckRight",2);
         this.background_mc.createObject(this.menuBarBackMiddleName,"bckCenter",3);
      }
      if(!_global.isLivePreview)
      {
         var _loc4_ = this.createObject("BoundingBox","mask_mc",10);
         this.setMask(_loc4_);
      }
      this.updateBackgroundDisplay();
   }
   function size(Void)
   {
      super.size();
      this.updateDisplay(true);
      this.updateBackgroundDisplay();
   }
   function addMenu(arg1, arg2)
   {
      var _loc2_ = this.__menuDataProvider.childNodes.length;
      if(_loc2_ == undefined)
      {
         _loc2_ = 0;
      }
      return this.addMenuAt(_loc2_,arg1,arg2);
   }
   function addMenuAt(index, arg1, arg2)
   {
      if(this.__menuDataProvider == undefined)
      {
         this.__menuDataProvider = new XML();
         this.__menuDataProvider.addEventListener("modelChanged",this);
      }
      var _loc8_ = undefined;
      var _loc3_ = undefined;
      var _loc4_ = arg1;
      if(arg2 != undefined)
      {
         if(arg2 instanceof XML)
         {
            _loc3_ = this.__menuDataProvider.addMenuItemAt(index,arg1);
            var _loc2_ = arg2.childNodes;
            while(_loc2_.length != 0)
            {
               _loc3_.addMenuItem(_loc2_[0]);
            }
            _loc4_ = undefined;
         }
         else
         {
            arg2.attributes.label = arg1;
            _loc4_ = arg2;
         }
      }
      if(_loc4_ != undefined)
      {
         _loc3_ = this.__menuDataProvider.addMenuItemAt(index,_loc4_);
      }
      return this.insertMenuBarItem(index,_loc3_);
   }
   function insertMenuBarItem(index, mdp)
   {
      var _loc2_ = mx.controls.Menu.createMenu(this._parent._root,mdp,{styleName:this,menuBarIndex:index});
      this.__menus[mdp.getID()] = _loc2_;
      _loc2_.__menuBar = this;
      _loc2_.addEventListener("menuHide",this);
      _loc2_.addEventListener("rollOver",this);
      _loc2_.addEventListener("rollOut",this);
      _loc2_.addEventListener("menuShow",this);
      _loc2_.addEventListener("change",this);
      _loc2_.border_mc.borderStyle = "menuBorder";
      _loc2_.labelField = this.labelField;
      _loc2_.labelFunction = this.labelFunction;
      var _loc4_ = this.labelFunction(mdp);
      if(_loc4_ == undefined)
      {
         _loc4_ = mdp.attributes[this.labelField];
      }
      var _loc3_ = this.createObject("MenuBarItem","mbItem" + this.topItemDepth++,this.topItemDepth,{owner:this,__initText:_loc4_,styleName:this,_visible:false});
      _loc3_.enabled = this.enabled;
      _loc3_.setSize(_loc3_.getPreferredWidth(),this.__height);
      _loc2_.__activator = _loc3_;
      this.__menuBarItems.splice(index,0,_loc3_);
      this.invUpdateDisplay = true;
      this.invalidate();
      return _loc2_;
   }
   function getMenuAt(index)
   {
      return this.__menus[this.__menuDataProvider.childNodes[index].getID()];
   }
   function removeMenuAt(index)
   {
      var _loc2_ = this.__menuDataProvider.removeMenuItemAt(index);
      var _loc3_ = this.__menuBarItems[index];
      this.__menuBarItems.splice(index,1);
      _loc3_.removeMovieClip();
      var _loc5_ = this.__menus[_loc2_.getID()];
      delete this.__menus[_loc2_.getID()];
      this.invUpdateDisplay = true;
      this.invalidate();
      return _loc5_;
   }
   function setEnabled(b)
   {
      super.setEnabled(b);
      var _loc4_ = this.__menuBarItems.length;
      this.enableByPass = true;
      var _loc3_ = 0;
      while(_loc3_ < _loc4_)
      {
         this.__menuBarItems[_loc3_].enabled = b;
         _loc3_ = _loc3_ + 1;
      }
      delete this.enableByPass;
   }
   function setMenuEnabledAt(index, enable)
   {
      if(!this.enabled && this.enableByPass == undefined)
      {
         return undefined;
      }
      this.__menuBarItems[index].enabled = enable;
   }
   function getMenuEnabledAt(index)
   {
      return this.__menuBarItems[index].enabled;
   }
   function setDataProvider(dp)
   {
      this.removeAll();
      this.__menuDataProvider = dp;
      dp.isTreeRoot = true;
      var _loc3_ = dp.childNodes;
      var _loc4_ = _loc3_.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc4_)
      {
         this.insertMenuBarItem(_loc2_,_loc3_[_loc2_]);
         _loc2_ = _loc2_ + 1;
      }
   }
   function get dataProvider()
   {
      return this.__menuDataProvider;
   }
   function set dataProvider(dp)
   {
      this.setDataProvider(dp);
   }
   function get labels()
   {
      return this.__labels;
   }
   function set labels(lbls)
   {
      this.__labels = lbls;
      var _loc4_ = this.__menuBarItems.length;
      var _loc3_ = this.__labels.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc4_)
      {
         this.removeMenuAt(0);
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < _loc3_)
      {
         this.addMenu(this.__labels[_loc2_]);
         _loc2_ = _loc2_ + 1;
      }
      this.redraw(true);
   }
   function invalidateStyle(propName)
   {
      super.invalidateStyle(propName);
      if(propName == "fontFamily" || propName == "fontSize" || propName == "fontWeight" || propName == "styleName")
      {
         this.invUpdateDisplay = true;
         this.invUpdateSize = true;
         this.invalidate();
      }
      var _loc3_ = 0;
      while(_loc3_ < this.__menuBarItems.length)
      {
         this.getMenuAt(_loc3_).invalidateStyle(propName);
         _loc3_ = _loc3_ + 1;
      }
   }
   function changeColorStyleInChildren(sheet, styleProp, newValue)
   {
      super.changeColorStyleInChildren(sheet,styleProp,newValue);
      var _loc3_ = 0;
      while(_loc3_ < this.__menuBarItems.length)
      {
         this.getMenuAt(_loc3_).changeColorStyleInChildren(sheet,styleProp,newValue);
         _loc3_ = _loc3_ + 1;
      }
   }
   function notifyStyleChangeInChildren(sheet, styleProp, newValue)
   {
      super.notifyStyleChangeInChildren(sheet,styleProp,newValue);
      var _loc3_ = 0;
      while(_loc3_ < this.__menuBarItems.length)
      {
         this.getMenuAt(_loc3_).notifyStyleChangeInChildren(sheet,styleProp,newValue);
         _loc3_ = _loc3_ + 1;
      }
   }
   function updateDisplay(resize)
   {
      delete this.invUpdateDisplay;
      delete this.invUpdateSize;
      var _loc4_ = this.__marginWidth;
      var _loc5_ = 0;
      var _loc6_ = this.__menuBarItems.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc6_)
      {
         var _loc2_ = this.__menuBarItems[_loc3_];
         _loc2_._visible = true;
         _loc2_.menuBarIndex = _loc3_;
         this.getMenuAt(_loc3_).menuBarIndex = _loc3_;
         if(resize)
         {
            _loc2_.setSize(_loc2_.getPreferredWidth(),this.__height);
         }
         var _loc0_ = null;
         _loc4_ = _loc2_._x = _loc4_ + _loc5_;
         _loc5_ = _loc2_.__width;
         _loc3_ = _loc3_ + 1;
      }
   }
   function updateBackgroundDisplay()
   {
      this.mask_mc._width = this.width;
      this.mask_mc._height = this.height;
      var _loc2_ = this.background_mc;
      _loc2_._height = this.__height;
      _loc2_.bckLeft._x = 0;
      var _loc3_ = _loc2_.bckLeft._width;
      _loc2_.bckCenter._width = this.__width - (_loc3_ + _loc2_.bckRight._width);
      _loc2_.bckCenter._x = _loc3_;
      _loc2_.bckRight._x = _loc3_ + _loc2_.bckCenter._width;
   }
   function showMenu(index)
   {
      this.openMenuIndex = index;
      var _loc3_ = this.__menuBarItems[index];
      var _loc6_ = _loc3_.dP;
      if(this.__menus[_loc6_.getID()] == undefined)
      {
         var _loc2_ = mx.controls.Menu.createMenu(this._parent._root,_loc6_,{styleName:this,menuBarIndex:index});
         this.__menus[_loc6_.getID()] = _loc2_;
         _loc2_.__menuBar = this;
         _loc2_.addEventListener("menuHide",this);
         _loc2_.addEventListener("rollOver",this);
         _loc2_.addEventListener("rollOut",this);
         _loc2_.addEventListener("menuShow",this);
         _loc2_.addEventListener("change",this);
         _loc2_.border_mc.borderStyle = "menuBorder";
         _loc2_.labelField = this.labelField;
         _loc2_.labelFunction = this.labelFunction;
         _loc2_.__activator = _loc3_;
      }
      var _loc4_ = {x:0,y:0};
      _loc3_.setLabelBorder("falsedown");
      _loc3_.localToGlobal(_loc4_);
      var _loc5_ = this.getMenuAt(index);
      _loc5_._root.globalToLocal(_loc4_);
      _loc5_.focusManager.lastFocus = undefined;
      _loc5_.show(_loc4_.x,_loc4_.y + (_loc3_._height + 1));
   }
   function removeMenuBarItemAt(index)
   {
      var _loc2_ = this.__menuBarItems[index];
      var _loc3_ = _loc2_.__menu;
      if(_loc2_ != undefined)
      {
         _loc3_.removeMovieClip();
         _loc2_.removeMovieClip();
         this.__menuBarItems.splice(index,1);
         this.updateDisplay(false);
      }
   }
   function removeAll()
   {
      while(this.__menuBarItems.length > 0)
      {
         var _loc2_ = this.__menuBarItems[0];
         var _loc3_ = _loc2_.__menu;
         _loc3_.removeMovieClip();
         _loc2_.removeMovieClip();
         this.__menuBarItems.splice(0,1);
      }
      this.updateDisplay(false);
   }
   function onItemRollOver(index)
   {
      var _loc3_ = this.__menuBarItems[index];
      if(this.openMenuIndex != undefined)
      {
         var _loc2_ = this.openMenuIndex;
         if(_loc2_ != index)
         {
            this.isDown = false;
            var _loc4_ = this.__menuBarItems[_loc2_];
            this.onItemRelease(_loc2_);
            _loc4_.setLabelBorder("none");
            this.showMenu(index);
            this.isDown = true;
         }
      }
      else
      {
         _loc3_.setLabelBorder("falserollover");
         this.isDown = false;
      }
   }
   function onItemPress(index)
   {
      var _loc2_ = this.__menuBarItems[index];
      if(!this.isDown)
      {
         this.showMenu(index);
         this.isDown = true;
      }
      else
      {
         _loc2_.setLabelBorder("falsedown");
         this.isDown = false;
      }
      this.pressFocus();
   }
   function onItemRelease(index)
   {
      var _loc2_ = this.__menuBarItems[index];
      if(!this.isDown)
      {
         this.getMenuAt(index).hide();
         _loc2_.setLabelBorder("falserollover");
      }
      this.releaseFocus();
   }
   function onItemRollOut(index)
   {
      if(this.openMenuIndex != index)
      {
         this.__menuBarItems[index].setLabelBorder("none");
      }
   }
   function onItemDragOver(index)
   {
      var _loc5_ = this.__menuBarItems[index];
      if(this.openMenuIndex != undefined)
      {
         var _loc2_ = this.openMenuIndex;
         if(_loc2_ != index)
         {
            this.isDown = false;
            var _loc3_ = this.__menuBarItems[_loc2_];
            this.onItemRelease(_loc2_);
            _loc3_.setLabelBorder("none");
         }
      }
      else
      {
         this.isDown = true;
      }
      this.onItemPress(index);
   }
   function onItemDragOut(index)
   {
      this.onItemRollOut(index);
   }
   function keyDown(e)
   {
      var _loc3_ = this.__menuBarItems.length;
      var _loc8_ = undefined;
      if(e.code == 39 || e.code == 37)
      {
         if(this.openMenuIndex == undefined)
         {
            this.openMenuIndex = -1;
         }
         var _loc2_ = this.openMenuIndex;
         var _loc5_ = false;
         var _loc4_ = 0;
         while(!_loc5_ && _loc4_ < _loc3_)
         {
            _loc4_ = _loc4_ + 1;
            _loc2_ = e.code != 39 ? _loc2_ - 1 : _loc2_ + 1;
            if(_loc2_ >= _loc3_)
            {
               _loc2_ = 0;
            }
            else if(_loc2_ < 0)
            {
               _loc2_ = _loc3_ - 1;
            }
            if(this.__menuBarItems[_loc2_].enabled)
            {
               _loc5_ = true;
            }
         }
         if(_loc4_ <= _loc3_)
         {
            this.onItemRollOver(_loc2_);
         }
      }
      if(Key.isDown(40))
      {
         if(this.openMenuIndex != undefined)
         {
            var _loc7_ = this.getMenuAt(this.openMenuIndex);
            _loc7_.focusEnabled = true;
            _loc7_.moveSelBy(1);
            this.supposedToLoseFocus = true;
            Selection.setFocus(_loc7_);
         }
      }
      if(Key.isDown(13) || Key.isDown(27))
      {
         this.getMenuAt(this.openMenuIndex).hide();
      }
   }
}
