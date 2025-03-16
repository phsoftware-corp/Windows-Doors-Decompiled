class mx.controls.treeclasses.TreeRow extends mx.controls.listclasses.SelectableRow
{
   var node;
   var owner;
   var disclosure;
   var nodeIcon;
   var open;
   var cell;
   var item;
   var rowIndex;
   var __height;
   var __width;
   var indentAdjust = 3;
   function TreeRow()
   {
      super();
   }
   function setValue(item, state)
   {
      this.node = item;
      var _loc4_ = this.owner.getIsBranch(this.node);
      super.setValue(this.node,state);
      if(this.node == undefined)
      {
         this.disclosure._visible = this.nodeIcon._visible = false;
         return undefined;
      }
      this.nodeIcon._visible = true;
      this.open = this.owner.getIsOpen(this.node);
      var _loc6_ = (this.owner.getNodeDepth(this.node) - 1) * this.getStyle("indentation");
      var _loc5_ = this.owner.getStyle(!this.open ? "disclosureClosedIcon" : "disclosureOpenIcon");
      this.disclosure = this.createObject(_loc5_,"disclosure",3);
      this.disclosure.onPress = this.disclosurePress;
      this.disclosure.useHandCursor = false;
      this.disclosure._visible = _loc4_;
      this.disclosure._x = _loc6_ + 4;
      var _loc3_ = this.owner.nodeIcons[this.node.getID()][!this.open ? "iconID" : "iconID2"];
      if(_loc3_ == undefined)
      {
         _loc3_ = this.owner.__iconFunction(this.node);
      }
      if(_loc4_)
      {
         if(_loc3_ == undefined)
         {
            _loc3_ = this.owner.getStyle(!this.open ? "folderClosedIcon" : "folderOpenIcon");
         }
      }
      else
      {
         if(_loc3_ == undefined)
         {
            _loc3_ = this.node.attributes[this.owner.iconField];
         }
         if(_loc3_ == undefined)
         {
            _loc3_ = this.owner.getStyle("defaultLeafIcon");
         }
      }
      this.nodeIcon.removeMovieClip();
      this.nodeIcon = this.createObject(_loc3_,"nodeIcon",20);
      this.nodeIcon._x = this.disclosure._x + this.disclosure._width + 2;
      this.cell._x = this.nodeIcon._x + this.nodeIcon._width + 2;
      this.size();
   }
   function getNormalColor()
   {
      this.node = this.item;
      var _loc6_ = super.getNormalColor();
      var _loc7_ = this.rowIndex + this.owner.__vPosition;
      var _loc5_ = this.owner.getColorAt(_loc7_);
      if(_loc5_ == undefined)
      {
         var _loc4_ = this.owner.getStyle("depthColors");
         if(_loc4_ == undefined)
         {
            return _loc6_;
         }
         var _loc3_ = this.owner.getNodeDepth(this.node);
         if(_loc3_ == undefined)
         {
            _loc3_ = 1;
         }
         _loc5_ = _loc4_[(_loc3_ - 1) % _loc4_.length];
      }
      return _loc5_;
   }
   function createChildren()
   {
      super.createChildren();
      if(this.disclosure == undefined)
      {
         this.createObject("Disclosure","disclosure",3,{_visible:false});
         this.disclosure.onPress = this.disclosurePress;
         this.disclosure.useHandCursor = false;
      }
   }
   function size()
   {
      super.size();
      this.disclosure._y = (this.__height - this.disclosure._height) / 2;
      this.nodeIcon._y = (this.height - this.nodeIcon._height) / 2;
      this.cell.setSize(this.__width - this.cell._x,this.__height);
   }
   function disclosurePress()
   {
      var _loc3_ = this._parent;
      var _loc2_ = _loc3_.owner;
      if(_loc2_.isOpening || !_loc2_.enabled)
      {
         return undefined;
      }
      var _loc4_ = !_loc3_.open ? 0 : 90;
      _loc3_.open = !this._parent.open;
      _loc2_.pressFocus();
      _loc2_.releaseFocus();
      _loc2_.setIsOpen(_loc3_.node,_loc3_.open,true,true);
   }
}
