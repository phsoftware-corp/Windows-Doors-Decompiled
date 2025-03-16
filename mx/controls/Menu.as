class mx.controls.Menu extends mx.controls.listclasses.ScrollSelectList
{
   var __activator;
   var mask_mc;
   var listContent;
   var border_mc;
   var __menuCache;
   var __width;
   var __height;
   var invRowHeight;
   var invUpdateSize;
   var __menuDataProvider;
   var groupName;
   var __menuBar;
   var popupMask;
   var wasJustCreated;
   var popupTween;
   var isPressed;
   var __activeChildren;
   var __lastRowRolledOver;
   var clearSelected;
   var anchorRow;
   var supposedToLoseFocus;
   var __dataProvider;
   var getLength;
   var rows;
   var __namedItems;
   var __radioGroups;
   var _selection;
   var _members;
   var __anchor;
   var __parentMenu;
   var __anchorIndex;
   var dragScrolling;
   var __timer;
   var __timeOut;
   var focusManager;
   var getSelectedIndex;
   var wasKeySelected;
   var selectedIndex;
   var selectedItem;
   static var symbolName = "Menu";
   static var symbolOwner = mx.controls.Menu;
   var className = "Menu";
   static var version = "2.0.2.127";
   static var mixit = mx.controls.treeclasses.TreeDataProvider.Initialize(XMLNode);
   static var mixit2 = mx.controls.menuclasses.MenuDataProvider.Initialize(XMLNode);
   var __hScrollPolicy = "off";
   var __vScrollPolicy = "off";
   var __rowRenderer = "MenuRow";
   var __rowHeight = 19;
   var __wasVisible = false;
   var __enabled = true;
   var __openDelay = 250;
   var __closeDelay = 250;
   var __delayQueue = new Array();
   var __iconField = "icon";
   function Menu()
   {
      super();
   }
   static function createMenu(parent, mdp, initObj)
   {
      if(parent == undefined)
      {
         parent = _root;
      }
      var pt = new Object();
      pt.x = parent._root._xmouse;
      pt.y = parent._root._ymouse;
      parent._root.localToGlobal(pt);
      if(mdp == undefined)
      {
         mdp = new XML();
      }
      var _loc3_ = mx.managers.PopUpManager.createPopUp(parent,mx.controls.Menu,false,initObj,true);
      if(_loc3_ == undefined)
      {
         trace("Failed to create a new menu, probably because there is no Menu in the Library");
      }
      else
      {
         _loc3_.isPressed = true;
         _loc3_.mouseDownOutsideHandler = function(event)
         {
            if(!this.isMouseOverMenu() && !this.__activator.hitTest(pt.x,pt.y))
            {
               this.hideAllMenus();
            }
         };
         _loc3_.dataProvider = mdp;
      }
      return _loc3_;
   }
   static function isItemEnabled(itm)
   {
      var _loc1_ = itm.attributes.enabled;
      return (_loc1_ == undefined || _loc1_ == true || _loc1_.toLowerCase() == "true") && itm.attributes.type.toLowerCase() != "separator";
   }
   static function isItemSelected(itm)
   {
      var _loc1_ = itm.attributes.selected;
      return _loc1_ == true || _loc1_.toLowerCase() == "true";
   }
   function init(Void)
   {
      super.init();
      this.visible = false;
   }
   function createChildren(Void)
   {
      super.createChildren();
      this.listContent.setMask(MovieClip(this.mask_mc));
      this.mask_mc.removeMovieClip();
      this.border_mc.move(0,0);
      this.border_mc.borderStyle = "menuBorder";
   }
   function propagateToSubMenus(prop, value)
   {
      for(var _loc5_ in this.__menuCache)
      {
         var _loc2_ = this.__menuCache[_loc5_];
         if(_loc2_ != this)
         {
            _loc2_["set" + prop](value);
         }
      }
   }
   function setLabelField(lbl)
   {
      super.setLabelField(lbl);
      this.propagateToSubMenus("LabelField",lbl);
   }
   function setLabelFunction(lbl)
   {
      super.setLabelFunction(lbl);
      this.propagateToSubMenus("LabelFunction",lbl);
   }
   function setCellRenderer(cR)
   {
      super.setCellRenderer(cR);
      this.propagateToSubMenus("CellRenderer",cR);
   }
   function setRowHeight(v)
   {
      super.setRowHeight(v);
      this.propagateToSubMenus("RowHeight",v);
   }
   function setIconField(v)
   {
      super.setIconField(v);
      this.propagateToSubMenus("IconField",v);
   }
   function setIconFunction(v)
   {
      super.setIconFunction(v);
      this.propagateToSubMenus("IconFunction",v);
   }
   function size(Void)
   {
      super.size();
      var _loc3_ = this.getViewMetrics();
      this.layoutContent(_loc3_.left,_loc3_.top,this.__width - _loc3_.left - _loc3_.right,this.__height - _loc3_.top - _loc3_.bottom);
   }
   function draw(Void)
   {
      if(this.invRowHeight)
      {
         super.draw();
         this.listContent.setMask(MovieClip(this.mask_mc));
         this.invUpdateSize = true;
      }
      super.draw();
      if(this.invUpdateSize)
      {
         this.updateSize();
      }
   }
   function onSetFocus()
   {
      super.onSetFocus();
      this.getFocusManager().defaultPushButtonEnabled = false;
   }
   function setDataProvider(dP)
   {
      if(typeof dP == "string")
      {
         dP = new XML(dP).firstChild;
      }
      this.__menuDataProvider.removeEventListener("modelChanged",this);
      this.__menuDataProvider = dP;
      if(!(this.__menuDataProvider instanceof XML))
      {
         this.__menuDataProvider.isTreeRoot = true;
      }
      this.__menuDataProvider.addEventListener("modelChanged",this);
      this.modelChanged({eventName:"updateTree"});
   }
   function getDataProvider()
   {
      return this.__menuDataProvider;
   }
   function addMenuItem(arg)
   {
      return this.__menuDataProvider.addMenuItem(arg);
   }
   function addMenuItemAt(index, arg)
   {
      return this.__menuDataProvider.addMenuItemAt(index,arg);
   }
   function removeMenuItemAt(index)
   {
      var _loc2_ = this.getMenuItemAt(index);
      if(_loc2_ != undefined && _loc2_ != null)
      {
         _loc2_.removeMenuItem();
      }
      return _loc2_;
   }
   function removeMenuItem(item)
   {
      return this.removeMenuItemAt(this.indexOf(item));
   }
   function removeAll(Void)
   {
      return this.__menuDataProvider.removeAll();
   }
   function getMenuItemAt(index)
   {
      return this.__menuDataProvider.getMenuItemAt(index);
   }
   function setMenuItemSelected(item, select)
   {
      if(item.attributes.type == "radio")
      {
         var _loc3_ = this.getRootMenu();
         this.groupName = item.attributes.groupName;
         _loc3_[this.groupName].setGroupSelection(item);
         return undefined;
      }
      if(select != item.attributes.selected)
      {
         item.attributes.selected = select;
         item.updateViews({eventName:"selectionChanged",node:item});
      }
   }
   function setMenuItemEnabled(item, enable)
   {
      if(enable != item.attributes.enabled)
      {
         item.attributes.enabled = enable;
         item.updateViews({eventName:"enabledChanged",node:item});
      }
   }
   function indexOf(item)
   {
      return this.__menuDataProvider.indexOf(item);
   }
   function show(x, y)
   {
      if(!this.visible)
      {
         var _loc2_ = this.getRootMenu();
         _loc2_.dispatchEvent({type:"menuShow",menuBar:this.__menuBar,menu:this,menuItem:this.__menuDataProvider});
         if(x != undefined)
         {
            this._x = x;
            if(y != undefined)
            {
               this._y = y;
            }
         }
         if(this != _loc2_)
         {
            var _loc5_ = this._x + this._width - Stage.width;
            if(_loc5_ > 0)
            {
               this._x -= _loc5_;
               if(this._x < 0)
               {
                  this._x = 0;
               }
            }
         }
         this.popupMask = this.attachMovie("BoundingBox","pMask_mc",6000);
         this.setMask(this.popupMask);
         var _loc3_ = this.width;
         if(_loc3_ < 50)
         {
            _loc3_ = 100;
         }
         this.popupMask._width = _loc3_;
         this.popupMask._height = this.height;
         this.popupMask._x = - this.popupMask._width;
         this.popupMask._y = - this.popupMask._height;
         var _loc4_ = this.getStyle("popupDuration");
         if(this.wasJustCreated && _loc4_ < 200)
         {
            _loc4_ = 200;
            delete this.wasJustCreated;
         }
         this.popupTween = new mx.effects.Tween(this,[this.popupMask._x,this.popupMask._y],[0,0],_loc4_);
         this.visible = true;
         this.isPressed = true;
         if(!this.__menuBar && _loc2_ == this)
         {
            Selection.setFocus(this);
         }
      }
   }
   function onTweenUpdate(val)
   {
      this.popupMask._width = this.width;
      this.popupMask._x = val[0];
      this.popupMask._y = val[1];
   }
   function onTweenEnd(val)
   {
      this.popupMask._x = val[0];
      this.popupMask._y = val[1];
      this.setMask(undefined);
      this.popupMask.removeMovieClip();
   }
   function hide(Void)
   {
      if(this.visible)
      {
         for(var _loc2_ in this.__activeChildren)
         {
            this.__activeChildren[_loc2_].hide();
         }
         this.__lastRowRolledOver = undefined;
         this.clearSelected();
         if(this.anchorRow != undefined)
         {
            this.anchorRow.highlight._visible = false;
         }
         this.visible = false;
         this.isPressed = false;
         this.__wasVisible = false;
         var _loc3_ = this.getRootMenu();
         _loc3_.dispatchEvent({type:"menuHide",menuBar:this.__menuBar,menu:this,menuItem:this.__menuDataProvider});
      }
   }
   function onKillFocus()
   {
      super.onKillFocus();
      this.getFocusManager().defaultPushButtonEnabled = true;
      if(this.supposedToLoseFocus == undefined)
      {
         this.hideAllMenus();
      }
      delete this.supposedToLoseFocus;
   }
   function modelChanged(eventObj)
   {
      var _loc4_ = eventObj.eventName;
      if(_loc4_ == "updateTree")
      {
         this.__dataProvider.removeAll();
         this.__dataProvider.addItemsAt(0,this.__menuDataProvider.childNodes);
         this.invUpdateSize = true;
         this.invalidate();
         super.modelChanged({eventName:"updateAll"});
         this.deinstallAllItems();
         this.installItem(this.__menuDataProvider);
         if(this.__menuCache == undefined)
         {
            this.__menuCache = new Object();
         }
         this.__menuCache[this.__menuDataProvider.getID()] = this;
      }
      else if(_loc4_ == "addNode" || _loc4_ == "removeNode")
      {
         var _loc5_ = eventObj.node;
         var _loc7_ = eventObj.parentNode;
         var _loc8_ = this.__menuCache[_loc7_.getID()];
         if(_loc4_ == "removeNode")
         {
            this.deleteDependentSubMenus(_loc5_);
            _loc8_.removeItemAt(eventObj.index);
            this.deinstallItem(_loc5_);
         }
         else
         {
            _loc8_.addItemAt(eventObj.index,_loc5_);
            this.installItem(_loc5_);
         }
         _loc8_.invUpdateSize = true;
         _loc8_.invalidate();
         var _loc6_ = this.__menuCache[_loc7_.parentNode.getID()];
         _loc6_.invUpdateControl = true;
         _loc6_.invalidate();
      }
      else if(_loc4_ == "selectionChanged" || _loc4_ == "enabledChanged")
      {
         _loc8_ = this.__menuCache[eventObj.node.parentNode.getID()];
         _loc8_.invUpdateControl = true;
         _loc8_.invalidate();
      }
      else
      {
         super.modelChanged(eventObj);
      }
   }
   function updateSize()
   {
      delete this.invUpdateSize;
      var _loc2_ = this.calcHeight();
      if(this.getLength() != this.__rowCount)
      {
         this.setSize(0,_loc2_);
      }
      this.setSize(this.calcWidth(),_loc2_);
   }
   function calcWidth()
   {
      var _loc4_ = -1;
      var _loc3_ = undefined;
      var _loc2_ = 0;
      while(_loc2_ < this.rows.length)
      {
         _loc3_ = this.rows[_loc2_].getIdealWidth();
         if(_loc3_ > _loc4_)
         {
            _loc4_ = _loc3_;
         }
         _loc2_ = _loc2_ + 1;
      }
      var _loc5_ = this.getStyle("textIndent");
      if(_loc5_ == undefined)
      {
         _loc5_ = 0;
      }
      return _loc4_ + _loc5_;
   }
   function calcHeight()
   {
      var _loc2_ = this.getViewMetrics();
      return this.__dataProvider.length * this.__rowHeight + _loc2_.top + _loc2_.bottom;
   }
   function invalidateStyle(propName)
   {
      super.invalidateStyle(propName);
      for(var _loc4_ in this.__activeChildren)
      {
         this.__activeChildren[_loc4_].invalidateStyle(propName);
      }
   }
   function notifyStyleChangeInChildren(sheetName, styleProp, newValue)
   {
      super.notifyStyleChangeInChildren(sheetName,styleProp,newValue);
      for(var _loc6_ in this.__activeChildren)
      {
         this.__activeChildren[_loc6_].notifyStyleChangeInChildren(sheetName,styleProp,newValue);
      }
   }
   function deleteDependentSubMenus(menuItem)
   {
      var _loc2_ = menuItem.childNodes;
      for(var _loc3_ in _loc2_)
      {
         this.deleteDependentSubMenus(_loc2_[_loc3_]);
      }
      var _loc4_ = this.__menuCache[menuItem.getID()];
      if(_loc4_ != undefined)
      {
         _loc4_.hide();
         delete this.__menuCache[menuItem.getID()];
      }
   }
   function installItem(item)
   {
      if(item.attributes.instanceName != undefined)
      {
         var _loc6_ = item.attributes.instanceName;
         if(this[_loc6_] != undefined)
         {
            trace("WARNING:  Duplicate menu item instanceNames - " + _loc6_);
         }
         if(this.__namedItems == undefined)
         {
            this.__namedItems = new Object();
         }
         this.__namedItems[_loc6_] = item;
         this[_loc6_] = item;
      }
      if(item.attributes.type == "radio" && item.attributes.groupName != undefined)
      {
         var _loc5_ = item.attributes.groupName;
         var _loc2_ = this[_loc5_];
         if(_loc2_ == undefined)
         {
            _loc2_ = new Object();
            _loc2_.name = _loc5_;
            _loc2_._rootMenu = this;
            _loc2_._members = new Object();
            _loc2_._memberCount = 0;
            _loc2_.getGroupSelection = this.getGroupSelection;
            _loc2_.setGroupSelection = this.setGroupSelection;
            _loc2_.addProperty("selection",_loc2_.getGroupSelection,_loc2_.setGroupSelection);
            if(this.__radioGroups == undefined)
            {
               this.__radioGroups = new Object();
            }
            this.__radioGroups[_loc5_] = _loc2_;
            this[_loc5_] = _loc2_;
         }
         _loc2_._members[item.getID()] = item;
         _loc2_._memberCount = _loc2_._memberCount + 1;
         if(mx.controls.Menu.isItemSelected(item))
         {
            _loc2_.selection = item;
         }
      }
      var _loc3_ = item.childNodes;
      for(var _loc7_ in _loc3_)
      {
         this.installItem(_loc3_[_loc7_]);
      }
   }
   function deinstallItem(item)
   {
      var _loc2_ = item.childNodes;
      for(var _loc5_ in _loc2_)
      {
         this.deinstallItem(_loc2_[_loc5_]);
      }
      if(item.attributes.instanceName != undefined)
      {
         var _loc7_ = item.attributes.instanceName;
         delete this[_loc7_];
         delete this.__namedItems[_loc7_];
      }
      if(item.attributes.type == "radio" && item.attributes.groupName != undefined)
      {
         var _loc6_ = item.attributes.groupName;
         var _loc3_ = this[_loc6_];
         if(_loc3_ == undefined)
         {
            return undefined;
         }
         delete _loc3_._members[item.getID()];
         _loc3_._memberCount = _loc3_._memberCount - 1;
         if(_loc3_._memberCount == 0)
         {
            delete this[_loc6_];
            delete this.__radioGroups[_loc6_];
         }
         else if(_loc3_.selection == item)
         {
            delete _loc3_._selection;
         }
      }
   }
   function deinstallAllItems(Void)
   {
      for(var _loc2_ in this.__namedItems)
      {
         delete this[_loc2_];
      }
      delete this.__namedItems;
      for(_loc2_ in this.__radioGroups)
      {
         delete this[_loc2_];
      }
      delete this.__radioGroups;
   }
   function getGroupSelection()
   {
      return this._selection;
   }
   function setGroupSelection(item)
   {
      this._selection = item;
      for(var _loc4_ in this._members)
      {
         var _loc2_ = this._members[_loc4_];
         _loc2_.attributes.selected = _loc2_ == item;
      }
      item.updateViews({eventName:"selectionChanged",node:item});
   }
   function onRowRelease(rowIndex)
   {
      if(!this.enabled || !this.selectable || !this.visible)
      {
         return undefined;
      }
      var _loc5_ = this.rows[rowIndex];
      var _loc2_ = _loc5_.item;
      if(_loc2_ != undefined && mx.controls.Menu.isItemEnabled(_loc2_))
      {
         var _loc10_ = _loc2_.attributes.type;
         var _loc4_ = !_loc2_.hasChildNodes() && _loc10_ != "separator";
         if(_loc4_)
         {
            this.hideAllMenus();
         }
         var _loc6_ = undefined;
         var _loc3_ = this.getRootMenu();
         if(_loc10_ == "check" || _loc10_ == "radio")
         {
            this.setMenuItemSelected(_loc2_,!mx.controls.Menu.isItemSelected(_loc2_));
         }
         if(_loc4_)
         {
            _loc3_.dispatchEvent({type:"change",menuBar:this.__menuBar,menu:_loc3_,menuItem:_loc2_,groupName:_loc2_.attributes.groupName});
         }
      }
   }
   function onRowPress(rowIndex)
   {
      var _loc3_ = this.rows[rowIndex].item;
      if(mx.controls.Menu.isItemEnabled(_loc3_) && !_loc3_.hasChildNodes())
      {
         super.onRowPress(rowIndex);
      }
   }
   function onRowRollOut(rowIndex)
   {
      if(!this.enabled || !this.selectable || !this.visible)
      {
         return undefined;
      }
      super.onRowRollOut(rowIndex);
      var _loc4_ = this.rows[rowIndex].item;
      if(_loc4_ != undefined)
      {
         var _loc5_ = this.getRootMenu();
         _loc5_.dispatchEvent({type:"rollOut",menuBar:this.__menuBar,menu:this,menuItem:_loc4_});
      }
      var _loc3_ = this.__activeChildren[_loc4_.getID()];
      if(_loc4_.hasChildNodes() > 0)
      {
         if(_loc3_.isOpening || _loc3_.isOpening == undefined)
         {
            this.cancelMenuDelay();
            _loc3_.isOpening = false;
         }
         if(_loc3_.visible)
         {
            this.rows[rowIndex].drawRow(_loc4_,"selected",false);
         }
      }
      else if(_loc3_.isClosing || _loc3_.isClosing == undefined)
      {
         this.cancelMenuDelay();
         _loc3_.isClosing = false;
      }
      this.setTimeOut(this.__closeDelay,_loc4_.getID());
   }
   function onRowRollOver(rowIndex)
   {
      if(!this.enabled || !this.selectable || !this.visible)
      {
         return undefined;
      }
      var _loc2_ = this.rows[rowIndex];
      var _loc8_ = _loc2_.item;
      var _loc6_ = _loc8_.getID();
      var _loc4_ = this.__activeChildren[this.__anchor];
      var _loc5_ = this.__activeChildren[_loc6_];
      this.clearSelected();
      this.clearTimeOut();
      this.__lastRowRolledOver = rowIndex;
      if(this.anchorRow != undefined)
      {
         this.anchorRow.drawRow(this.anchorRow.item,"normal",false);
         delete this.anchorRow;
      }
      if(this.__parentMenu)
      {
         var _loc3_ = this.__parentMenu.rows[this.__anchorIndex];
         _loc3_.drawRow(_loc3_.item,"selected",false);
         this.__parentMenu.anchorRow = _loc3_;
      }
      if(_loc5_.__activeChildren[_loc5_.__anchor].visible)
      {
         _loc5_.__activeChildren[_loc5_.__anchor].hide();
      }
      if(_loc4_.visible && this.__anchor != _loc6_)
      {
         _loc4_.isClosing = true;
         this.setMenuDelay(this.__closeDelay,"closeSubMenu",{id:this.__anchor});
      }
      if(_loc8_ != undefined && mx.controls.Menu.isItemEnabled(_loc8_))
      {
         var _loc7_ = this.getRootMenu();
         _loc7_.dispatchEvent({type:"rollOver",menuBar:this.__menuBar,menu:this,menuItem:_loc8_});
         if(_loc8_.hasChildNodes() > 0)
         {
            this.anchorRow = _loc2_;
            _loc2_.drawRow(_loc8_,"selected",false);
            if(!_loc5_.visible)
            {
               _loc5_.isOpening = true;
               this.setMenuDelay(this.__openDelay,"openSubMenu",{item:_loc8_,rowIndex:rowIndex});
            }
         }
         else
         {
            _loc2_.drawRow(_loc8_,"highlighted",false);
         }
      }
   }
   function onRowDragOver(rowIndex)
   {
      var _loc4_ = this.__dataProvider.getItemAt(rowIndex + this.__vPosition);
      if(mx.controls.Menu.isItemEnabled(_loc4_))
      {
         super.onRowDragOver(rowIndex);
         this.onRowRollOver(rowIndex);
      }
   }
   function __onMouseUp()
   {
      clearInterval(this.dragScrolling);
      delete this.dragScrolling;
      delete this.isPressed;
      if(!this.selectable)
      {
         return undefined;
      }
      if(this.__wasVisible)
      {
         this.hide();
      }
      this.__wasVisible = false;
   }
   function setMenuDelay(delay, request, args)
   {
      if(this.__timer == null)
      {
         this.__timer = setInterval(this,"callMenuDelay",delay,request,args);
      }
      else
      {
         this.__delayQueue.push({delay:delay,request:request,args:args});
      }
   }
   function callMenuDelay(request, args)
   {
      this[request](args);
      this.clearMenuDelay();
   }
   function clearMenuDelay(Void)
   {
      clearInterval(this.__timer);
      this.__timer = null;
      this.runDelayQueue();
   }
   function cancelMenuDelay(Void)
   {
      var _loc2_ = this.__delayQueue.pop();
      this.clearMenuDelay();
   }
   function runDelayQueue(Void)
   {
      if(this.__delayQueue.length == 0)
      {
         return undefined;
      }
      var _loc2_ = this.__delayQueue.shift();
      var _loc4_ = _loc2_.delay;
      var _loc5_ = _loc2_.request;
      var _loc3_ = _loc2_.args;
      this.setMenuDelay(_loc4_,_loc5_,_loc3_);
   }
   function setTimeOut(delay, id)
   {
      this.clearTimeOut();
      this.__timeOut = setInterval(this,"callTimeOut",delay,id);
   }
   function clearTimeOut(Void)
   {
      clearInterval(this.__timeOut);
      this.__timeOut = null;
   }
   function callTimeOut(Void)
   {
      var _loc2_ = this.__activeChildren[this.__anchor];
      this.clearTimeOut();
      if(!this.isMouseOverMenu() && _loc2_)
      {
         var _loc3_ = _loc2_.__anchorIndex;
         var _loc5_ = this.__dataProvider.getItemAt(_loc3_ + this.__vPosition);
         var _loc4_ = this.rows[_loc3_];
         _loc4_.drawRow(_loc5_,"normal",false);
         _loc2_.hide();
         this.__delayQueue.length = 0;
      }
   }
   function openSubMenu(o)
   {
      var _loc3_ = this.getRootMenu();
      var _loc5_ = this.rows[o.rowIndex];
      var _loc7_ = o.item;
      var _loc0_ = null;
      var _loc6_ = this.__anchor = _loc7_.getID();
      var _loc2_ = _loc3_.__menuCache[_loc6_];
      if(_loc2_ == undefined)
      {
         _loc2_ = mx.managers.PopUpManager.createPopUp(_loc3_,mx.controls.Menu,false,{__parentMenu:this,__anchorIndex:o.rowIndex,styleName:_loc3_},true);
         _loc2_.labelField = _loc3_.__labelField;
         _loc2_.labelFunction = _loc3_.__labelFunction;
         _loc2_.iconField = _loc3_.__iconField;
         _loc2_.iconFunction = _loc3_.__iconFunction;
         _loc2_.wasJustCreated = true;
         _loc2_.cellRenderer = _loc3_.__cellRenderer;
         _loc2_.rowHeight = _loc3_.__rowHeight;
         if(_loc3_.__menuCache == undefined)
         {
            _loc3_.__menuCache = new Object();
            _loc3_.__menuCache[_loc3_.__menuDataProvider.getID()] = _loc3_;
         }
         if(this.__activeChildren == undefined)
         {
            this.__activeChildren = new Object();
         }
         _loc3_.__menuCache[_loc6_] = _loc2_;
         this.__activeChildren[_loc6_] = _loc2_;
         _loc2_.__dataProvider.addItemsAt(0,_loc7_.childNodes);
         _loc2_.invUpdateSize = true;
         _loc2_.invalidate();
      }
      _loc2_.__menuBar = this.__menuBar;
      var _loc4_ = {x:0,y:0};
      _loc5_.localToGlobal(_loc4_);
      _loc5_._root.globalToLocal(_loc4_);
      _loc2_.focusManager.lastFocus = undefined;
      _loc2_.show(_loc4_.x + _loc5_.__width,_loc4_.y);
      this.focusManager.lastFocus = undefined;
      _loc2_.isOpening = false;
   }
   function closeSubMenu(o)
   {
      var _loc2_ = this.__activeChildren[o.id];
      _loc2_.hide();
      _loc2_.isClosing = false;
   }
   function moveSelBy(incr)
   {
      var _loc3_ = this.getSelectedIndex();
      if(_loc3_ == undefined)
      {
         _loc3_ = -1;
      }
      var _loc2_ = _loc3_ + incr;
      if(_loc2_ > this.__dataProvider.length - 1)
      {
         _loc2_ = 0;
      }
      else if(_loc2_ < 0)
      {
         _loc2_ = this.__dataProvider.length - 1;
      }
      this.wasKeySelected = true;
      this.selectRow(_loc2_ - this.__vPosition,false,false);
      var _loc4_ = this.__dataProvider.getItemAt(_loc2_ + this.__vPosition);
      if(_loc4_.attributes.type == "separator")
      {
         this.moveSelBy(incr);
      }
   }
   function keyDown(e)
   {
      if(this.__lastRowRolledOver != undefined)
      {
         this.selectedIndex = this.__lastRowRolledOver;
         this.__lastRowRolledOver = undefined;
      }
      var _loc2_ = this.selectedItem;
      if(Key.isDown(38))
      {
         var _loc4_ = this.getRootMenu();
         var _loc3_ = _loc4_.__menuCache[_loc2_.getID()];
         if(_loc2_.hasChildNodes() && _loc3_.visible)
         {
            this.supposedToLoseFocus = true;
            Selection.setFocus(_loc3_);
            _loc3_.selectedIndex = _loc3_.rows.length - 1;
         }
         else
         {
            this.moveSelBy(-1);
         }
      }
      if(Key.isDown(40))
      {
         _loc4_ = this.getRootMenu();
         _loc3_ = _loc4_.__menuCache[_loc2_.getID()];
         if(_loc2_.hasChildNodes() && _loc3_.visible)
         {
            this.supposedToLoseFocus = true;
            Selection.setFocus(_loc3_);
            _loc3_.selectedIndex = 0;
         }
         else
         {
            this.moveSelBy(1);
         }
      }
      if(Key.isDown(39))
      {
         if(mx.controls.Menu.isItemEnabled(_loc2_) && _loc2_.hasChildNodes())
         {
            this.openSubMenu({item:_loc2_,rowIndex:this.selectedIndex});
            _loc4_ = this.getRootMenu();
            _loc3_ = _loc4_.__menuCache[_loc2_.getID()];
            this.supposedToLoseFocus = true;
            Selection.setFocus(_loc3_);
            _loc3_.selectedIndex = 0;
         }
         else if(this.__menuBar)
         {
            this.supposedToLoseFocus = true;
            Selection.setFocus(this.__menuBar);
            this.__menuBar.keyDown(e);
         }
      }
      if(Key.isDown(37))
      {
         if(this.__parentMenu)
         {
            this.supposedToLoseFocus = true;
            this.hide();
            Selection.setFocus(this.__parentMenu);
         }
         else if(this.__menuBar)
         {
            this.supposedToLoseFocus = true;
            Selection.setFocus(this.__menuBar);
            this.__menuBar.keyDown(e);
         }
      }
      if(Key.isDown(13) || Key.isDown(32))
      {
         if(mx.controls.Menu.isItemEnabled(_loc2_) && _loc2_.hasChildNodes())
         {
            this.openSubMenu({item:_loc2_,rowIndex:this.selectedIndex});
            _loc4_ = this.getRootMenu();
            _loc3_ = _loc4_.__menuCache[_loc2_.getID()];
            this.supposedToLoseFocus = true;
            Selection.setFocus(_loc3_);
            _loc3_.selectedIndex = 0;
         }
         else
         {
            this.onRowRelease(this.selectedIndex);
         }
      }
      if(Key.isDown(27) || Key.isDown(9))
      {
         this.hideAllMenus();
      }
   }
   function hideAllMenus(Void)
   {
      this.getRootMenu().hide();
   }
   function isMouseOverMenu(Void)
   {
      var _loc4_ = new Object();
      _loc4_.x = _root._xmouse;
      _loc4_.y = _root._ymouse;
      _root.localToGlobal(_loc4_);
      if(this.border_mc.hitTest(_loc4_.x,_loc4_.y))
      {
         return true;
      }
      var _loc5_ = this.getRootMenu();
      for(var _loc6_ in _loc5_.__menuCache)
      {
         var _loc3_ = _loc5_.__menuCache[_loc6_];
         if(_loc3_.visible && _loc3_.border_mc.hitTest(_loc4_.x,_loc4_.y))
         {
            return true;
         }
      }
      return false;
   }
   function getRootMenu(Void)
   {
      var _loc2_ = this;
      while(_loc2_.__parentMenu != undefined)
      {
         _loc2_ = _loc2_.__parentMenu;
      }
      return _loc2_;
   }
}
