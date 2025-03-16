class mx.controls.gridclasses.DataGridRow extends mx.controls.listclasses.SelectableRow
{
   var colBG;
   var cells;
   var owner;
   var backGround;
   var text;
   var textHeight;
   var listOwner;
   var columnIndex;
   var __height;
   var grandOwner;
   var wasPressed;
   var onPress;
   function DataGridRow()
   {
      super();
   }
   function createChildren(Void)
   {
      this.setupBG();
      this.colBG = this.createEmptyMovieClip("colbG_mc",mx.controls.listclasses.SelectableRow.LOWEST_DEPTH + 1);
   }
   function init(Void)
   {
      super.init();
      this.cells = new Array();
   }
   function size(Void)
   {
      if(this.cells.length != this.owner.columns.length)
      {
         this.createCells();
      }
      super.size();
   }
   function createCells(Void)
   {
      this.clearCells();
      this.backGround.onRelease = this.startEditCell;
      var _loc7_ = this.owner.columns.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc7_)
      {
         var _loc4_ = this.owner.columns[_loc2_];
         var _loc5_ = _loc4_.__cellRenderer;
         if(_loc5_ != undefined)
         {
            if(typeof _loc5_ == "string")
            {
               var _loc0_ = null;
               var _loc3_ = this.cells[_loc2_] = this.createObject(_loc5_,"fCell" + _loc2_,2 + _loc2_,{styleName:_loc4_});
            }
            else
            {
               _loc3_ = this.cells[_loc2_] = this.createClassObject(_loc5_,"fCell" + _loc2_,2 + _loc2_,{styleName:_loc4_});
            }
         }
         else
         {
            _loc3_ = this.cells[_loc2_] = this.createLabel("fCell" + _loc2_,2 + _loc2_);
            _loc3_.styleName = _loc4_;
            _loc3_.selectable = false;
            _loc3_.backGround = false;
            _loc3_.border = false;
            _loc3_._visible = false;
            _loc3_.getPreferredHeight = this.cellGetPreferredHeight;
         }
         _loc3_.listOwner = this.owner;
         _loc3_.columnIndex = _loc2_;
         _loc3_.owner = this;
         _loc3_.getCellIndex = this.getCellIndex;
         _loc3_.getDataLabel = this.getDataLabel;
         _loc2_ = _loc2_ + 1;
      }
   }
   function cellGetPreferredHeight()
   {
      var _loc3_ = this.text;
      this.text = "^g_p";
      this.draw();
      var _loc2_ = this.textHeight + 4;
      this.text = _loc3_;
      return _loc2_;
   }
   function getCellIndex(Void)
   {
      return {columnIndex:this.columnIndex,itemIndex:this.owner.rowIndex + this.listOwner.__vPosition};
   }
   function getDataLabel()
   {
      return this.listOwner.columns[this.columnIndex].columnName;
   }
   function clearCells()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.cells.length)
      {
         this.cells[_loc2_].removeTextField();
         this.cells[_loc2_].removeMovieClip();
         _loc2_ = _loc2_ + 1;
      }
      this.cells.splice(0);
   }
   function setValue(itmObj, state, transition)
   {
      var _loc7_ = this.owner.columns;
      var _loc8_ = _loc7_.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc8_)
      {
         var _loc6_ = this.cells[_loc3_];
         var _loc4_ = _loc7_[_loc3_];
         var _loc2_ = _loc4_.__labelFunction(itmObj);
         if(_loc2_ == undefined)
         {
            _loc2_ = !(itmObj instanceof XMLNode) ? itmObj[_loc4_.columnName] : itmObj.attributes[_loc4_.columnName];
         }
         if(_loc2_ == undefined)
         {
            _loc2_ = " ";
         }
         _loc6_.setValue(_loc2_,itmObj,state);
         _loc3_ = _loc3_ + 1;
      }
   }
   function drawCell(cellNum, xPos, w, bgCol)
   {
      var _loc2_ = this.cells[cellNum];
      _loc2_._x = xPos;
      _loc2_._visible = true;
      _loc2_.setSize(w - 2,Math.min(this.__height,_loc2_.getPreferredHeight()));
      _loc2_._y = (this.__height - _loc2_.height) / 2;
      if(bgCol != undefined)
      {
         var _loc3_ = Math.floor(xPos - 2);
         var _loc4_ = Math.floor(_loc3_ + w);
         this.colBG.moveTo(_loc3_,0);
         this.colBG.beginFill(bgCol);
         this.colBG.lineStyle(0,0,0);
         this.colBG.lineTo(_loc4_,0);
         this.colBG.lineTo(_loc4_,this.__height);
         this.colBG.lineTo(_loc3_,this.__height);
         this.colBG.endFill();
      }
   }
   function setState(newState, transition)
   {
      var _loc6_ = this.owner.columns;
      var _loc4_ = _loc6_.length;
      if(newState != "normal" || !this.owner.enabled)
      {
         var _loc5_ = undefined;
         if(!this.owner.enabled)
         {
            _loc5_ = this.owner.getStyle("disabledColor");
         }
         else if(newState == "highlighted")
         {
            _loc5_ = this.owner.getStyle("textRollOverColor");
         }
         else if(newState == "selected")
         {
            _loc5_ = this.owner.getStyle("textSelectedColor");
         }
         var _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.cells[_loc3_].setColor(_loc5_);
            this.cells[_loc3_].__enabled = this.owner.enabled;
            _loc3_ = _loc3_ + 1;
         }
      }
      else
      {
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.cells[_loc3_].setColor(_loc6_[_loc3_].getStyle("color"));
            this.cells[_loc3_].__enabled = this.owner.enabled;
            _loc3_ = _loc3_ + 1;
         }
      }
      super.setState(newState,transition);
   }
   function startEditCell()
   {
      var _loc2_ = this.grandOwner;
      _loc2_.dontEdit = true;
      _loc2_.releaseFocus();
      delete _loc2_.dontEdit;
      if(_loc2_.enabled && _loc2_.editable && this.owner.item != undefined)
      {
         var _loc9_ = this.owner.cells.length;
         var _loc3_ = 0;
         while(_loc3_ < _loc9_)
         {
            var _loc5_ = _loc2_.columns[_loc3_];
            if(_loc5_.editable)
            {
               var _loc4_ = this.owner._xmouse - this.owner.cells[_loc3_]._x;
               if(_loc4_ >= 0 && _loc4_ < _loc5_.__width)
               {
                  var _loc6_ = this.owner.rowIndex + _loc2_.__vPosition;
                  _loc2_.setFocusedCell({itemIndex:_loc6_,columnIndex:_loc3_},true);
                  if(this.wasPressed != true)
                  {
                     this.onPress();
                     _loc2_.onMouseUp();
                  }
                  delete this.wasPressed;
                  clearInterval(_loc2_.dragScrolling);
                  delete _loc2_.onMouseUp;
                  return undefined;
               }
            }
            _loc3_ = _loc3_ + 1;
         }
      }
   }
   function bGOnPress(Void)
   {
      this.wasPressed = true;
      this.grandOwner.pressFocus();
      this.grandOwner.onRowPress(this.owner.rowIndex);
   }
   function notifyStyleChangeInChildren(sheetName, styleProp, newValue)
   {
      var _loc6_ = this.owner.columns;
      var _loc4_ = this.cells.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc4_)
      {
         var _loc2_ = this.cells[_loc3_];
         if(_loc2_.stylecache != undefined)
         {
            delete _loc2_.stylecache.tf;
         }
         delete _loc2_.enabledColor;
         _loc2_.invalidateStyle(styleProp);
         _loc3_ = _loc3_ + 1;
      }
   }
}
