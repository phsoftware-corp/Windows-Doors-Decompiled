class mx.controls.menuclasses.MenuRow extends mx.controls.listclasses.SelectableRow
{
   var cell;
   var owner;
   var icon_branch;
   var branch;
   var type;
   var iconID;
   var icon_mc;
   var icon_sep;
   var __width;
   var __height;
   var idealWidth;
   var isEnabled = true;
   var selected = false;
   var lBuffer = 18;
   var rBuffer = 15;
   function MenuRow()
   {
      super();
   }
   function setValue(itemObj, sel)
   {
      var _loc7_ = this.cell;
      var _loc6_ = this.itemToString(itemObj);
      if(_loc7_.getValue() != _loc6_)
      {
         _loc7_.setValue(_loc6_,itemObj,this.state);
      }
      var _loc8_ = itemObj.hasChildNodes();
      var _loc5_ = mx.controls.Menu.isItemEnabled(itemObj);
      var _loc4_ = itemObj.attributes.type;
      if(_loc4_ == undefined)
      {
         _loc4_ = "normal";
      }
      var _loc9_ = mx.controls.Menu.isItemSelected(itemObj);
      var _loc3_ = this.owner.__iconFunction(itemObj);
      if(_loc3_ == undefined)
      {
         _loc3_ = itemObj.attributes[this.owner.__iconField];
      }
      if(_loc3_ == undefined)
      {
         _loc3_ = this.owner.getStyle("defaultIcon");
      }
      if(this.icon_branch && (_loc8_ != this.branch || _loc5_ != this.isEnabled || this.type == "separator"))
      {
         this.icon_branch.removeMovieClip();
         delete this.icon_branch;
      }
      if(_loc9_ != this.selected || _loc3_ != this.iconID || _loc4_ != this.type || _loc5_ != this.isEnabled && _loc4_ != "normal")
      {
         this.icon_mc.removeMovieClip();
         this.icon_sep.removeMovieClip();
         delete this.icon_sep;
         delete this.icon_mc;
      }
      this.branch = _loc8_;
      this.isEnabled = _loc5_;
      this.type = _loc4_;
      this.selected = _loc9_;
      this.iconID = _loc3_;
      this.cell.__enabled = this.isEnabled;
      this.cell.setColor(!this.isEnabled ? this.owner.getStyle("disabledColor") : this.owner.getStyle("color"));
      if(sel == "highlighted")
      {
         if(this.isEnabled)
         {
            this.cell.setColor(this.owner.getStyle("textRollOverColor"));
         }
      }
      else if(sel == "selected")
      {
         if(this.isEnabled)
         {
            this.cell.setColor(this.owner.getStyle("textSelectedColor"));
         }
      }
      if(this.branch && this.icon_branch == undefined)
      {
         this.icon_branch = this.createObject("MenuBranch" + (!this.isEnabled ? "Disabled" : "Enabled"),"icon_branch",20);
      }
      if(this.type == "separator")
      {
         if(this.icon_sep == undefined)
         {
            var _loc10_ = this.createObject("MenuSeparator","icon_sep",21);
         }
      }
      else if(this.icon_mc == undefined)
      {
         if(this.type != "normal")
         {
            if(this.selected)
            {
               this.iconID = (this.type != "check" ? "MenuRadio" : "MenuCheck") + (!this.isEnabled ? "Disabled" : "Enabled");
            }
            else
            {
               this.iconID = undefined;
            }
         }
         if(this.iconID != undefined)
         {
            this.icon_mc = this.createObject(this.iconID,"icon_mc",21);
         }
      }
      this.size();
   }
   function itemToString(itmObj)
   {
      if(itmObj.attributes.type == "separator")
      {
         return " ";
      }
      return super.itemToString(itmObj);
   }
   function size(Void)
   {
      super.size();
      this.cell._x = this.lBuffer;
      this.cell.setSize(this.__width - this.rBuffer - this.lBuffer,Math.min(this.__height,this.cell.getPreferredHeight()));
      if(this.icon_branch)
      {
         this.icon_branch._x = this.__width - this.rBuffer / 2;
         this.icon_branch._y = (this.__height - this.icon_branch._height) / 2;
      }
      if(this.icon_sep)
      {
         this.icon_sep._x = 4;
         this.icon_sep._y = (this.__height - this.icon_sep._height) / 2;
         this.icon_sep._width = this.__width - 8;
      }
      else if(this.icon_mc)
      {
         this.icon_mc._x = Math.max(0,(this.lBuffer - this.icon_mc._width) / 2);
         this.icon_mc._y = (this.__height - this.icon_mc._height) / 2;
      }
   }
   function getIdealWidth(Void)
   {
      this.cell.draw();
      this.idealWidth = this.cell.getPreferredWidth() + 4 + this.lBuffer + this.rBuffer;
      return this.idealWidth;
   }
}
