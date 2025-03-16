class MultiLineCell extends mx.core.UIComponent
{
   var multiLineLabel;
   var listOwner;
   var __width;
   var __height;
   var owner;
   static var PREFERRED_HEIGHT_OFFSET = 4;
   static var PREFERRED_WIDTH = 100;
   var startDepth = 1;
   function MultiLineCell()
   {
      super();
   }
   function createChildren()
   {
      var _loc0_ = null;
      var _loc2_ = this.multiLineLabel = this.createLabel("multiLineLabel",this.startDepth);
      _loc2_.styleName = this.listOwner;
      _loc2_.selectable = false;
      _loc2_.tabEnabled = false;
      _loc2_.background = false;
      _loc2_.border = false;
      _loc2_.multiline = true;
      _loc2_.wordWrap = true;
   }
   function size()
   {
      var _loc2_ = this.multiLineLabel;
      _loc2_.setSize(this.__width,this.__height);
   }
   function getPreferredHeight()
   {
      return this.owner.__height - MultiLineCell.PREFERRED_HEIGHT_OFFSET;
   }
   function setValue(suggestedValue, item, selected)
   {
      if(item == undefined)
      {
         this.multiLineLabel.text._visible = false;
      }
      this.multiLineLabel.text = suggestedValue;
   }
}
