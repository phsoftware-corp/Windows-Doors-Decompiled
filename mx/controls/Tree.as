class mx.controls.Tree extends mx.controls.List
{
   var nodeIcons;
   var invUpdateControl;
   var branchNodes;
   var treeDataProvider;
   var openNodes;
   var nodeList;
   var rowIndex;
   var tween;
   var opening;
   var rows;
   var maskList;
   var rowList;
   var __viewMetrics;
   var __width;
   var __maxHPosition;
   var topRowZ;
   var listContent;
   var __dataProvider;
   var eventAfterTween;
   var invScrollProps;
   var eventPending;
   var vScroller;
   var setSelectedIndex;
   var getSelectedItem;
   var setSelectedIndices;
   var getSelectedItems;
   var nodeIndices;
   var dispatchEvent;
   static var symbolName = "Tree";
   static var symbolOwner = mx.controls.Tree;
   var className = "Tree";
   static var version = "2.0.2.127";
   static var mixIt2 = mx.controls.treeclasses.TreeDataProvider.Initialize(XMLNode);
   var isNewRowStyle = {depthColors:true,indentation:true,disclosureOpenIcon:true,disclosureClosedIcon:true,folderOpenIcon:true,folderClosedIcon:true,defaultLeafIcon:true};
   var __rowRenderer = "TreeRow";
   var isOpening = false;
   var minScrollInterval = 50;
   function Tree()
   {
      super();
   }
   function setIcon(node, iconID, iconID2)
   {
      if(this.nodeIcons == undefined)
      {
         this.nodeIcons = new Object();
      }
      if(iconID2 == undefined)
      {
         iconID2 = iconID;
      }
      var _loc0_ = null;
      var _loc3_ = this.nodeIcons[node.getID()] = {iconID:iconID,iconID2:iconID2};
      this.invUpdateControl = true;
      this.invalidate();
   }
   function getIsBranch(node)
   {
      return node.hasChildNodes() || this.branchNodes[node.getID()] != undefined;
   }
   function setIsBranch(node, branch)
   {
      if(this.branchNodes == undefined)
      {
         this.branchNodes = new Object();
      }
      if(!branch)
      {
         delete this.branchNodes[node.getID()];
      }
      else
      {
         this.branchNodes[node.getID()] = true;
      }
      if(this.isNodeVisible(node))
      {
         this.invUpdateControl = true;
         this.invalidate();
      }
   }
   function getNodeDepth(node)
   {
      var _loc3_ = 0;
      var _loc2_ = node;
      while(_loc2_.parentNode != undefined && _loc2_ != this.treeDataProvider)
      {
         _loc3_ = _loc3_ + 1;
         _loc2_ = _loc2_.parentNode;
      }
      return _loc3_;
   }
   function getIsOpen(node)
   {
      return this.openNodes[node.getID()] == true;
   }
   function setIsOpen(node, open, animate, fireEvent)
   {
      if(!this.getIsBranch(node) || this.getIsOpen(node) == open || this.isOpening)
      {
         return undefined;
      }
      if(open)
      {
         this.openNodes[node.getID()] = open;
      }
      if(this.isNodeVisible(node))
      {
         this.nodeList = this.getDisplayList(node,!open);
         this.rowIndex = this.getDisplayIndex(node) + 1 - this.__vPosition;
         var _loc6_ = Math.min(this.nodeList.length,this.__rowCount - this.rowIndex);
         var _loc13_ = this.getStyle("openDuration");
         if(animate && this.rowIndex < this.__rowCount && _loc6_ > 0 && _loc6_ < 20 && _loc13_ != 0)
         {
            this.tween.endTween();
            this.opening = open;
            this.isOpening = true;
            var _loc7_ = _loc6_ * this.__rowHeight;
            var _loc15_ = this.rowIndex;
            while(_loc15_ < this.__rowCount)
            {
               this.rows[_loc15_].__lastY = this.rows[_loc15_]._y;
               _loc15_ = _loc15_ + 1;
            }
            this.maskList = new Array();
            this.rowList = new Array();
            var _loc4_ = this.__viewMetrics;
            var _loc12_ = !(this.__hScrollPolicy == "on" || this.__hScrollPolicy == "auto") ? this.__width - _loc4_.left - _loc4_.right : this.__width + this.__maxHPosition;
            _loc15_ = 0;
            while(_loc15_ < _loc6_)
            {
               var _loc0_ = null;
               var _loc3_ = this.maskList[_loc15_] = this.attachMovie("BoundingBox","openMask" + _loc15_,2001 + _loc15_);
               _loc3_._width = this.__width - _loc4_.left - _loc4_.right;
               _loc3_._x = _loc4_.left;
               _loc3_._height = _loc7_;
               _loc3_._y = this.rows[this.rowIndex]._y;
               var _loc2_ = this.rowList[_loc15_] = this.listContent.createObject(this.__rowRenderer,"treeRow" + this.topRowZ++,this.topRowZ,{owner:this,styleName:this});
               _loc2_._x = _loc4_.left;
               _loc2_.setSize(_loc12_,this.__rowHeight);
               if(open)
               {
                  _loc2_.drawRow(this.nodeList[_loc15_],"normal");
                  _loc2_._y = this.rows[this.rowIndex]._y - _loc7_ + this.__rowHeight * _loc15_;
                  _loc2_.setMask(_loc3_);
               }
               else
               {
                  var _loc5_ = Math.max(this.__vPosition + this.__rowCount + _loc15_ + this.nodeList.length - _loc6_,this.rowIndex + this.nodeList.length);
                  _loc2_.drawRow(this.__dataProvider.getItemAt(_loc5_),this.getStateAt(_loc5_));
                  _loc2_._y = this.rows[this.__rowCount - 1]._y + (_loc15_ + 1) * this.__rowHeight;
                  this.rows[this.rowIndex + _loc15_].setMask(_loc3_);
               }
               _loc2_.__lastY = _loc2_._y;
               _loc15_ = _loc15_ + 1;
            }
            _loc13_ *= Math.max(_loc6_ / 5,1);
            if(fireEvent)
            {
               this.eventAfterTween = node;
            }
            this.tween = new mx.effects.Tween(this,0,!open ? -1 * _loc7_ : _loc7_,_loc13_,5);
            var _loc16_ = this.getStyle("openEasing");
            if(_loc16_ != undefined)
            {
               this.tween.easingEquation = _loc16_;
            }
         }
         else
         {
            this.isOpening = false;
            if(open)
            {
               this.addItemsAt(this.getDisplayIndex(node) + 1,this.nodeList);
            }
            else
            {
               this.__dataProvider.removeItemsAt(this.getDisplayIndex(node) + 1,this.nodeList.length);
            }
            this.invScrollProps = true;
            if(fireEvent)
            {
               this.eventPending = node;
            }
            this.invalidate();
         }
      }
      if(!open)
      {
         this.openNodes[node.getID()] = open;
      }
      _loc15_ = this.getDisplayIndex(node);
      var _loc14_ = this.rows[_loc15_ - this.__vPosition];
      _loc14_.drawRow(_loc14_.item,this.getStateAt(_loc15_));
   }
   function onTweenUpdate(val)
   {
      var _loc2_ = this.rowIndex;
      while(_loc2_ < this.__rowCount)
      {
         this.rows[_loc2_]._y = this.rows[_loc2_].__lastY + val;
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.rowList.length)
      {
         this.rowList[_loc2_]._y = this.rowList[_loc2_].__lastY + val;
         _loc2_ = _loc2_ + 1;
      }
   }
   function onTweenEnd(val)
   {
      var _loc2_ = this.rowIndex;
      while(_loc2_ < this.__rowCount)
      {
         this.rows[_loc2_]._y = this.rows[_loc2_].__lastY + val;
         delete this.rows[_loc2_].__lastY;
         if(_loc2_ >= this.__rowCount - this.rowList.length && this.opening)
         {
            this.rows[_loc2_].removeMovieClip();
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.rowList.length)
      {
         this.rowList[_loc2_]._y = this.rowList[_loc2_].__lastY + val;
         if(this.opening)
         {
            this.rowList[_loc2_].setMask(undefined);
         }
         else
         {
            this.rows[this.rowIndex + _loc2_].removeMovieClip();
         }
         this.maskList[_loc2_].removeMovieClip();
         _loc2_ = _loc2_ + 1;
      }
      this.isOpening = false;
      this.vScroller.scrollPosition = this.__vPosition;
      if(this.opening)
      {
         var _loc4_ = this.rowIndex + this.rowList.length;
         _loc2_ = this.__rowCount - 1;
         while(_loc2_ >= _loc4_)
         {
            this.rows[_loc2_] = this.rows[_loc2_ - this.rowList.length];
            this.rows[_loc2_].rowIndex = _loc2_;
            _loc2_ = _loc2_ - 1;
         }
         _loc2_ = this.rowIndex;
         while(_loc2_ < _loc4_)
         {
            this.rows[_loc2_] = this.rowList[_loc2_ - this.rowIndex];
            this.rows[_loc2_].rowIndex = _loc2_;
            _loc2_ = _loc2_ + 1;
         }
         this.addItemsAt(this.rowIndex + this.__vPosition,this.nodeList);
      }
      else
      {
         var _loc3_ = this.__rowCount - this.rowList.length;
         _loc2_ = this.rowIndex;
         while(_loc2_ < _loc3_)
         {
            this.rows[_loc2_] = this.rows[_loc2_ + this.rowList.length];
            this.rows[_loc2_].rowIndex = _loc2_;
            _loc2_ = _loc2_ + 1;
         }
         _loc2_ = _loc3_;
         while(_loc2_ < this.__rowCount)
         {
            this.rows[_loc2_] = this.rowList[_loc2_ - _loc3_];
            this.rows[_loc2_].rowIndex = _loc2_;
            _loc2_ = _loc2_ + 1;
         }
         this.__dataProvider.removeItemsAt(this.rowIndex + this.__vPosition,this.nodeList.length);
      }
      if(this.eventAfterTween != undefined)
      {
         this.eventPending = this.eventAfterTween;
         this.invalidate();
         delete this.eventAfterTween;
      }
      delete this.tween;
      delete this.invUpdateControl;
   }
   function size(Void)
   {
      this.tween.endTween();
      super.size();
   }
   function setVPosition(pos)
   {
      if(this.isOpening)
      {
         return undefined;
      }
      super.setVPosition(pos);
   }
   function onScroll(evt)
   {
      if(this.isOpening)
      {
         return undefined;
      }
      super.onScroll(evt);
   }
   function addItemsAt(index, arr)
   {
      var _loc4_ = this.__dataProvider.slice(0,index);
      var _loc3_ = this.__dataProvider.slice(index);
      this.__dataProvider = _loc4_.concat(arr,_loc3_);
      this.__dataProvider.addEventListener("modelChanged",this);
      this.modelChanged({eventName:"addItems",firstItem:index,lastItem:index + arr.length - 1});
   }
   function setDataProvider(dP)
   {
      if(this.treeDataProvider != undefined)
      {
         this.treeDataProvider.removeEventListener(this);
      }
      if(typeof dP == "string")
      {
         dP = new XML(dP);
      }
      this.treeDataProvider = dP;
      this.treeDataProvider.isTreeRoot = true;
      this.setIsBranch(this.treeDataProvider,true);
      this.setIsOpen(this.treeDataProvider,true);
      this.setDisplayIndex(this.treeDataProvider,-1);
      this.treeDataProvider.addEventListener("modelChanged",this);
      this.modelChanged({eventName:"updateTree"});
   }
   function getDataProvider()
   {
      return this.treeDataProvider;
   }
   function refresh()
   {
      this.updateControl();
   }
   function addTreeNode(label, data)
   {
      if(this.treeDataProvider == undefined)
      {
         this.setDataProvider(new XML());
      }
      return this.treeDataProvider.addTreeNode(label,data);
   }
   function addTreeNodeAt(index, label, data)
   {
      if(this.treeDataProvider == undefined)
      {
         this.setDataProvider(new XML());
      }
      return this.treeDataProvider.addTreeNodeAt(index,label,data);
   }
   function getTreeNodeAt(index)
   {
      return this.treeDataProvider.getTreeNodeAt(index);
   }
   function removeTreeNodeAt(index)
   {
      return this.treeDataProvider.removeTreeNodeAt(index);
   }
   function removeAll()
   {
      return this.treeDataProvider.removeAll();
   }
   function getNodeDisplayedAt(index)
   {
      return this.__dataProvider.getItemAt(index);
   }
   function modelChanged(eventObj)
   {
      var _loc6_ = eventObj.eventName;
      if(_loc6_ == "updateTree")
      {
         this.__dataProvider = this.getDisplayList(this.treeDataProvider);
         this.__dataProvider.addEventListener("modelChanged",this);
         super.modelChanged({eventName:"updateAll"});
      }
      else if(_loc6_ == "addNode")
      {
         var _loc8_ = eventObj.node;
         if(this.isNodeVisible(_loc8_))
         {
            if(_loc8_.nextSibling != undefined)
            {
               this.setDisplayIndex(_loc8_,this.getDisplayIndex(_loc8_.nextSibling));
            }
            else if(_loc8_.previousSibling != undefined)
            {
               var _loc7_ = this.getDisplayList(_loc8_.previousSibling);
               if(_loc7_.length > 0)
               {
                  this.setDisplayIndex(_loc8_,this.getDisplayIndex(_loc7_.pop()) + 1);
               }
               else
               {
                  this.setDisplayIndex(_loc8_,this.getDisplayIndex(_loc8_.previousSibling) + 1);
               }
            }
            else
            {
               this.setDisplayIndex(_loc8_,this.getDisplayIndex(_loc8_.parentNode) + 1);
            }
            var _loc10_ = this.getDisplayList(_loc8_);
            _loc10_.unshift(_loc8_);
            this.addItemsAt(this.getDisplayIndex(_loc8_),_loc10_);
         }
         else
         {
            this.invUpdateControl = true;
            this.invalidate();
         }
      }
      else if(_loc6_ == "removeNode")
      {
         _loc8_ = eventObj.node;
         var _loc9_ = this.getDisplayIndex(_loc8_);
         if(_loc9_ != undefined)
         {
            var _loc11_ = this.getDisplayList(_loc8_);
            this.__dataProvider.removeItemsAt(_loc9_,_loc11_.length + 1);
         }
      }
      else if(_loc6_ == "addItems")
      {
         super.modelChanged(eventObj);
         var _loc5_ = this.__dataProvider;
         var _loc3_ = eventObj.firstItem;
         while(_loc3_ < _loc5_.length)
         {
            this.setDisplayIndex(_loc5_[_loc3_],_loc3_);
            _loc3_ = _loc3_ + 1;
         }
      }
      else if(_loc6_ == "removeItems")
      {
         _loc5_ = this.__dataProvider;
         _loc3_ = eventObj.firstItem;
         while(_loc3_ < _loc5_.length)
         {
            this.setDisplayIndex(_loc5_[_loc3_],_loc3_);
            _loc3_ = _loc3_ + 1;
         }
         super.modelChanged(eventObj);
      }
      else
      {
         super.modelChanged(eventObj);
      }
   }
   function isNodeVisible(node)
   {
      return this.getDisplayIndex(node) != undefined || this.getDisplayIndex(node.parentNode) != undefined && this.getIsOpen(node.parentNode);
   }
   function getFirstVisibleNode()
   {
      return this.__dataProvider.getItemAt(this.__vPosition);
   }
   function setFirstVisibleNode(node)
   {
      var _loc2_ = this.getDisplayIndex(node);
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      this.setVPosition(_loc2_);
   }
   function set firstVisibleNode(node)
   {
      this.setFirstVisibleNode(node);
   }
   function get firstVisibleNode()
   {
      return this.getFirstVisibleNode();
   }
   function set selectedNode(node)
   {
      var _loc2_ = this.getDisplayIndex(node);
      if(_loc2_ >= 0)
      {
         this.setSelectedIndex(_loc2_);
      }
   }
   function get selectedNode()
   {
      return this.getSelectedItem();
   }
   function set selectedNodes(nodeArray)
   {
      var _loc5_ = new Array();
      var _loc3_ = undefined;
      var _loc2_ = 0;
      while(_loc2_ < nodeArray.length)
      {
         _loc3_ = this.getDisplayIndex(nodeArray[_loc2_]);
         if(_loc3_ != undefined)
         {
            _loc5_.push(_loc3_);
         }
         _loc2_ = _loc2_ + 1;
      }
      this.setSelectedIndices(_loc5_);
   }
   function get selectedNodes()
   {
      return this.getSelectedItems();
   }
   function getDisplayList(node, removed)
   {
      var _loc5_ = new Array();
      if(!this.isNodeVisible(node) || !this.getIsOpen(node))
      {
         return _loc5_;
      }
      var _loc6_ = this.getDisplayIndex(node);
      var _loc3_ = new Array();
      var _loc2_ = node.firstChild;
      var _loc4_ = _loc2_ == undefined;
      while(!_loc4_)
      {
         if(removed)
         {
            this.setDisplayIndex(_loc2_,undefined);
         }
         else
         {
            this.setDisplayIndex(_loc2_,_loc6_ = _loc6_ + 1);
         }
         _loc5_.push(_loc2_);
         if(_loc2_.childNodes.length > 0 && this.getIsOpen(_loc2_))
         {
            if(_loc2_.nextSibling != undefined)
            {
               _loc3_.push(_loc2_.nextSibling);
            }
            _loc2_ = _loc2_.firstChild;
         }
         else if(_loc2_.nextSibling != undefined)
         {
            _loc2_ = _loc2_.nextSibling;
         }
         else if(_loc3_.length == 0)
         {
            _loc4_ = true;
         }
         else
         {
            _loc2_ = _loc3_.pop();
         }
      }
      return _loc5_;
   }
   function getDisplayIndex(node)
   {
      return this.nodeIndices[node.getID()];
   }
   function setDisplayIndex(node, UID)
   {
      this.nodeIndices[node.getID()] = UID;
   }
   function keyDown(e)
   {
      if(this.isOpening)
      {
         return undefined;
      }
      var _loc3_ = this.selectedNode;
      if(e.ctrlKey)
      {
         super.keyDown(e);
      }
      else if(e.code == 32)
      {
         if(this.getIsBranch(_loc3_))
         {
            var _loc6_ = !this.getIsOpen(_loc3_);
            this.setIsOpen(_loc3_,_loc6_,true,true);
         }
      }
      else if(e.code == 37)
      {
         if(this.getIsOpen(_loc3_))
         {
            this.setIsOpen(_loc3_,false,true,true);
         }
         else
         {
            this.selectedNode = _loc3_.parentNode;
            this.dispatchEvent({type:"change"});
            var _loc5_ = this.getDisplayIndex(this.selectedNode);
            if(_loc5_ < this.__vPosition)
            {
               this.setVPosition(_loc5_);
            }
         }
      }
      else if(e.code == 39)
      {
         if(this.getIsBranch(_loc3_))
         {
            if(this.getIsOpen(_loc3_))
            {
               this.selectedNode = _loc3_.firstChild;
               this.dispatchEvent({type:"change"});
            }
            else
            {
               this.setIsOpen(_loc3_,true,true,true);
            }
         }
      }
      else
      {
         super.keyDown(e);
      }
   }
   function init()
   {
      super.init();
      this.openNodes = new Object();
      this.nodeIndices = new Object();
   }
   function invalidateStyle(propName)
   {
      if(this.isNewRowStyle[propName])
      {
         this.invUpdateControl = true;
         this.invalidate();
      }
      super.invalidateStyle(propName);
   }
   function layoutContent(x, y, tW, tH, dW, dH)
   {
      var _loc5_ = 0;
      var _loc6_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < this.rows.length)
      {
         var _loc4_ = this.rows[_loc3_].getDepth();
         if(_loc4_ > _loc5_)
         {
            _loc5_ = _loc4_;
            _loc6_ = _loc3_;
         }
         _loc3_ = _loc3_ + 1;
      }
      var _loc7_ = _loc5_ + this.rows.length - _loc6_;
      if(this.topRowZ < _loc7_)
      {
         this.topRowZ = _loc7_;
      }
      super.layoutContent(x,y,tW,tH,dW,dH);
   }
   function draw(Void)
   {
      super.draw();
      if(this.eventPending != undefined)
      {
         this.dispatchEvent({type:(!this.getIsOpen(this.eventPending) ? "nodeClose" : "nodeOpen"),node:this.eventPending});
         delete this.eventPending;
      }
   }
}
