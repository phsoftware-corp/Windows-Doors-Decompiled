class mx.controls.DataGrid extends mx.controls.List
{
   var invInitHeaders;
   var columns;
   var invDrawCols;
   var __width;
   var invCheckCols;
   var cellEditor;
   var __dataProvider;
   var rows;
   var __maxHPosition;
   var oldVWidth;
   var invLayoutContent;
   var __height;
   var border_mc;
   var oldWidth;
   var displayWidth;
   var invRowHeight;
   var invSpaceColsEqually;
   var invColChange;
   var totalWidth;
   var lines_mc;
   var listContent;
   var headerCells;
   var header_mc;
   var dispatchEvent;
   var __viewMetrics;
   var sortArrow;
   var sortIndex;
   var layoutX;
   var sortDirection;
   var owner;
   var column;
   var cell;
   var asc;
   var col;
   var stretcher;
   var oldX;
   var stretchBar;
   var colX;
   var onRollOut;
   var __focusedCell;
   var editorMask;
   var editTween;
   var __tabHandlerCache;
   var vScroller;
   var hScroller;
   var dontEdit;
   var listOwner;
   var activeGrid;
   var getLength;
   static var symbolOwner = mx.controls.DataGrid;
   static var symbolName = "DataGrid";
   static var version = "2.0.2.127";
   var className = "DataGrid";
   var selectable = true;
   var resizableColumns = true;
   var __showHeaders = true;
   var sortableColumns = true;
   var autoHScrollAble = true;
   var editable = false;
   var minColWidth = 20;
   var totColW = 0;
   var __rowRenderer = "DataGridRow";
   var __headerHeight = 20;
   var hasDrawn = false;
   var minScrollInterval = 60;
   var HEADERDEPTH = 5001;
   var LINEDEPTH = 5000;
   var SORTARROWDEPTH = 5500;
   var EDITORDEPTH = 5002;
   var DISABLEDHEADERDEPTH = 5003;
   var HEADERCELLDEPTH = 4500;
   var HEADEROVERLAYDEPTH = 4000;
   var SEPARATORDEPTH = 5000;
   var STRETCHERDEPTH = 1000;
   function DataGrid()
   {
      super();
   }
   function init()
   {
      super.init();
      this.invInitHeaders = true;
      this.columns = new Array();
   }
   function layoutContent(x, y, tW, tH, dW, dH)
   {
      var _loc3_ = this.__rowCount;
      if(this.__showHeaders)
      {
         y += this.__headerHeight;
         dH -= this.__headerHeight;
      }
      super.layoutContent(x,y,tW,tH,dW,dH);
      if(tW != this.totColW)
      {
         this.drawHeaderBG();
      }
      if(this.__rowCount > _loc3_)
      {
         this.invDrawCols = true;
         this.invalidate();
      }
   }
   function setRowCount(rC)
   {
      if(isNaN(rC))
      {
         return undefined;
      }
      var _loc2_ = this.getViewMetrics();
      this.setSize(this.__width,this.__rowHeight * rC + _loc2_.top + _loc2_.bottom + this.__headerHeight * this.__showHeaders);
   }
   function setRowHeight(rH)
   {
      this.__rowHeight = rH;
      if(this.hasDrawn)
      {
         super.setRowHeight(rH);
      }
   }
   function setHScrollPolicy(policy)
   {
      super.setHScrollPolicy(policy);
      this.invCheckCols = true;
      this.invalidate();
   }
   function setEnabled(v)
   {
      if(v == this.enabled)
      {
         return undefined;
      }
      super.setEnabled(v);
      if(this.__showHeaders)
      {
         this.enableHeader(v);
      }
      if(this.cellEditor._visible == true)
      {
         this.disposeEditor();
      }
      this.invDrawCols = true;
      this.invalidate();
   }
   function modelChanged(eventObj)
   {
      if(eventObj.eventName == "updateField")
      {
         var _loc3_ = eventObj.firstItem;
         var _loc5_ = this.__dataProvider.getItemAt(_loc3_);
         this.rows[_loc3_ - this.__vPosition].drawRow(_loc5_,this.getStateAt(_loc3_));
         return undefined;
      }
      if(eventObj.eventName == "schemaLoaded")
      {
         this.removeAllColumns();
      }
      if(this.columns.length == 0)
      {
         this.generateCols();
      }
      super.modelChanged(eventObj);
   }
   function configureScrolling(Void)
   {
      var _loc3_ = this.getViewMetrics();
      var _loc4_ = this.__hScrollPolicy == "off" ? this.__width - _loc3_.left - _loc3_.right : this.__maxHPosition + this.__width - _loc3_.left - _loc3_.right;
      var _loc2_ = this.__dataProvider.length;
      if(_loc2_ == undefined)
      {
         _loc2_ = 0;
      }
      if(this.__vPosition > Math.max(0,_loc2_ - this.getRowCount() + this.roundUp))
      {
         this.setVPosition(Math.max(0,Math.min(_loc2_ - this.getRowCount() + this.roundUp,this.__vPosition)));
      }
      this.setScrollProperties(_loc4_,1,_loc2_,this.__rowHeight,this.__headerHeight * this.__showHeaders);
      if(this.oldVWidth != _loc4_)
      {
         this.invLayoutContent = true;
      }
      this.oldVWidth = _loc4_;
   }
   function setVPosition(pos)
   {
      if(this.cellEditor != undefined)
      {
         this.disposeEditor();
      }
      super.setVPosition(pos);
   }
   function size(Void)
   {
      if(this.hasDrawn != true)
      {
         this.border_mc.setSize(this.__width,this.__height);
         return undefined;
      }
      if(this.cellEditor != undefined)
      {
         this.disposeEditor();
      }
      if(this.__hScrollPolicy != "off")
      {
         var _loc5_ = 0;
         var _loc6_ = this.columns.length;
         var _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc5_ += this.columns[_loc3_].__width;
            _loc3_ = _loc3_ + 1;
         }
         var _loc8_ = this.getViewMetrics();
         var _loc9_ = this.__width - _loc8_.left - _loc8_.right;
         this.setMaxHPosition(Math.max(_loc5_ - _loc9_,0));
         var _loc7_ = _loc9_ - _loc5_;
         if(_loc7_ > 0)
         {
            this.columns[_loc6_ - 1].__width += _loc7_;
         }
         this.setHPosition(Math.min(this.getMaxHPosition(),this.getHPosition()));
      }
      super.size();
      if(this.__hScrollPolicy == "off")
      {
         var _loc10_ = new Array();
         _loc6_ = this.columns.length;
         if(this.oldWidth == undefined)
         {
            this.oldWidth = this.displayWidth;
         }
         var _loc4_ = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ += this.columns[_loc3_].__width = this.displayWidth * this.columns[_loc3_].__width / this.oldWidth;
            _loc3_ = _loc3_ + 1;
         }
         if(_loc4_ != this.displayWidth)
         {
            this.columns[this.columns.length - 1].__width += this.displayWidth - _loc4_;
         }
         this.totColW = this.numberOfCols = this.displayWidth;
      }
      this.oldWidth = this.displayWidth;
      this.drawColumns();
      this.drawHeaderBG();
      this.invalidate();
   }
   function draw()
   {
      if(this.invRowHeight)
      {
         super.draw();
         this.invInitHeaders = true;
         this.invDrawCols = true;
         delete this.cellEditor;
      }
      if(this.invInitHeaders)
      {
         this.initHeaders();
         this.invLayoutContent = true;
      }
      super.draw();
      if(this.invSpaceColsEqually)
      {
         delete this.invSpaceColsEqually;
         this.spaceColumnsEqually();
      }
      if(this.invColChange)
      {
         delete this.invColChange;
         if(this.hasDrawn)
         {
            this.initHeaders();
            this.initRows();
            this.invDrawCols = true;
            this.updateControl();
            this.invCheckCols = true;
         }
      }
      if(this.invCheckCols)
      {
         if(this.totColW != this.displayWidth)
         {
            this.resizeColumn(this.columns.length - 1,this.columns[this.columns.length - 1].__width);
         }
         delete this.invCheckCols;
      }
      if(this.invDrawCols)
      {
         this.drawColumns();
      }
      this.hasDrawn = true;
   }
   function editField(index, colName, data)
   {
      this.__dataProvider.editField(index,colName,data);
   }
   function get columnNames()
   {
      return this.getColumnNames();
   }
   function set columnNames(w)
   {
      this.setColumnNames(w);
   }
   function setColumnNames(tmpArray)
   {
      var _loc2_ = 0;
      while(_loc2_ < tmpArray.length)
      {
         this.addColumn(tmpArray[_loc2_]);
         _loc2_ = _loc2_ + 1;
      }
   }
   function getColumnNames(Void)
   {
      var _loc3_ = new Array();
      var _loc2_ = 0;
      while(_loc2_ < this.columns.length)
      {
         _loc3_[_loc2_] = this.columns[_loc2_].columnName;
         _loc2_ = _loc2_ + 1;
      }
      return _loc3_;
   }
   function addColumnAt(index, newCol)
   {
      if(index < this.columns.length)
      {
         this.columns.splice(index,0,"tmp");
      }
      var _loc4_ = newCol;
      if(!(_loc4_ instanceof mx.controls.gridclasses.DataGridColumn))
      {
         _loc4_ = new mx.controls.gridclasses.DataGridColumn(_loc4_);
      }
      this.columns[index] = _loc4_;
      _loc4_.colNum = index;
      var _loc2_ = index + 1;
      while(_loc2_ < this.columns.length)
      {
         this.columns[_loc2_].colNum = this.columns[_loc2_].colNum + 1;
         _loc2_ = _loc2_ + 1;
      }
      _loc4_.parentGrid = this;
      this.totColW += _loc4_.width;
      this.invColChange = true;
      this.invalidate();
      return newCol;
   }
   function addColumn(newCol)
   {
      return this.addColumnAt(this.columns.length,newCol);
   }
   function removeColumnAt(index)
   {
      var _loc4_ = this.columns[index];
      this.columns.splice(index,1);
      this.totColW -= _loc4_.width;
      var _loc2_ = index;
      while(_loc2_ < this.columns.length)
      {
         this.columns[_loc2_].colNum--;
         _loc2_ = _loc2_ + 1;
      }
      this.invColChange = true;
      this.invalidate();
      return _loc4_;
   }
   function removeAllColumns(Void)
   {
      this.totColW = 0;
      this.columns = new Array();
      this.invColChange = true;
      this.invalidate();
   }
   function getColumnAt(index)
   {
      return this.columns[index];
   }
   function getColumnIndex(name)
   {
      var _loc2_ = 0;
      while(_loc2_ < this.columns.length)
      {
         if(this.columns[_loc2_].columnName == name)
         {
            return _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function get columnCount()
   {
      return this.columns.length;
   }
   function spaceColumnsEqually(Void)
   {
      if(this.displayWidth == undefined)
      {
         var _loc4_ = this.getViewMetrics();
         this.displayWidth = this.__width - _loc4_.left - _loc4_.right;
      }
      var _loc3_ = Math.ceil(this.totalWidth / this.columns.length);
      var _loc2_ = 0;
      while(_loc2_ < this.columns.length)
      {
         this.columns[_loc2_].__width = _loc3_;
         _loc2_ = _loc2_ + 1;
      }
      this.totColW = this.totalWidth;
      this.invDrawCols = true;
      this.invalidate();
   }
   function generateCols(Void)
   {
      if(this.columns.length == 0)
      {
         var _loc3_ = this.__dataProvider.getColumnNames();
         if(_loc3_ == undefined)
         {
            var _loc4_ = this.__dataProvider.getItemAt(0);
            for(var _loc2_ in _loc4_)
            {
               if(_loc2_ != "__ID__")
               {
                  this.addColumn(_loc2_);
               }
            }
         }
         else
         {
            var _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               this.addColumn(_loc3_[_loc2_]);
               _loc2_ = _loc2_ + 1;
            }
         }
         this.invSpaceColsEqually = true;
         this.invColChange = true;
         this.invCheckCols = true;
         this.invalidate();
      }
   }
   function resizeColumn(col, w)
   {
      if(this.__hScrollPolicy == "on" || this.__hScrollPolicy == "auto")
      {
         this.columns[col].__width = w;
         var _loc11_ = 0;
         var _loc5_ = this.columns.length;
         var _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc11_ += this.columns[_loc2_].__width;
            _loc2_ = _loc2_ + 1;
         }
         this.setMaxHPosition(Math.max(_loc11_ - this.displayWidth,0));
         var _loc12_ = this.displayWidth - _loc11_;
         if(_loc12_ > 0)
         {
            this.columns[_loc5_ - 1].__width += _loc12_;
         }
         this.setHPosition(Math.min(this.getMaxHPosition(),this.getHPosition()));
         this.invDrawCols = true;
         this.invalidate();
         return undefined;
      }
      var _loc10_ = 0;
      _loc2_ = 0;
      while(_loc2_ < col)
      {
         _loc10_ += this.columns[_loc2_].__width;
         _loc2_ = _loc2_ + 1;
      }
      var _loc8_ = this.displayWidth + 2 - _loc10_ - this.columns[col].__width;
      var _loc6_ = this.displayWidth + 2 - _loc10_ - w;
      this.columns[col].__width = w;
      _loc5_ = this.columns.length;
      _loc2_ = col + 1;
      while(_loc2_ < _loc5_)
      {
         if(!this.columns[_loc2_].resizable)
         {
            _loc6_ -= this.columns[_loc2_].__width;
            _loc8_ -= this.columns[_loc2_].__width;
         }
         _loc2_ = _loc2_ + 1;
      }
      var _loc9_ = 0;
      _loc2_ = col + 1;
      while(_loc2_ < _loc5_)
      {
         if(this.columns[_loc2_].resizable)
         {
            this.columns[_loc2_].__width = this.columns[_loc2_].width * _loc6_ / _loc8_;
            _loc9_ += this.columns[_loc2_].__width;
         }
         _loc2_ = _loc2_ + 1;
      }
      var _loc3_ = 0;
      var _loc7_ = false;
      _loc2_ = _loc5_ - 1;
      while(_loc2_ >= 0)
      {
         if(this.columns[_loc2_].resizable)
         {
            if(!_loc7_)
            {
               this.columns[_loc2_].__width += _loc6_ - _loc9_;
               _loc7_ = true;
            }
            if(_loc3_ > 0)
            {
               this.columns[_loc2_].__width -= _loc3_;
               _loc3_ = 0;
            }
            if(this.columns[_loc2_].__width < this.minColWidth)
            {
               _loc3_ += this.minColWidth - this.columns[_loc2_].__width;
               this.columns[_loc2_].__width = this.minColWidth;
            }
         }
         _loc2_ = _loc2_ - 1;
      }
      this.invDrawCols = true;
      this.invalidate();
   }
   function drawColumns(Void)
   {
      delete this.invDrawCols;
      var _loc0_ = null;
      var _loc4_ = this.lines_mc = this.listContent.createEmptyMovieClip("lines_mc",this.LINEDEPTH);
      var _loc9_ = 0.75;
      var _loc5_ = 1;
      var _loc15_ = this.height - 1;
      var _loc12_ = this.getStyle("vGridLineColor");
      var _loc14_ = this.columns.length;
      this.placeSortArrow();
      var _loc7_ = 0;
      while(_loc7_ < _loc14_)
      {
         var _loc6_ = this.columns[_loc7_];
         var _loc13_ = !this.enabled ? "backgroundDisabledColor" : "backgroundColor";
         var _loc10_ = _loc6_.getStyle(_loc13_);
         _loc9_ += _loc6_.__width;
         _loc4_.moveTo(_loc5_,1);
         _loc4_.lineStyle(0,_loc12_,0);
         var _loc11_ = Math.floor(_loc9_);
         _loc4_.lineTo(_loc11_,1);
         if(_loc7_ < this.columns.length - 1 && this.getStyle("vGridLines"))
         {
            _loc4_.lineStyle(0,_loc12_,100);
         }
         _loc4_.lineTo(_loc11_,this.height);
         _loc4_.lineStyle(0,_loc12_,0);
         _loc4_.lineTo(_loc5_,this.height);
         _loc4_.lineTo(_loc5_,1);
         if(this.__showHeaders)
         {
            var _loc3_ = this.headerCells[_loc7_];
            _loc3_._x = _loc5_ + 2;
            _loc3_.hO._x = _loc5_;
            _loc3_.setSize(_loc6_.__width - 5,Math.min(this.__headerHeight,_loc3_.getPreferredHeight()));
            _loc3_.hO._width = _loc6_.__width - 2;
            _loc3_.hO._height = this.__headerHeight;
            _loc3_._y = (this.__headerHeight - _loc3_._height) / 2;
            this.header_mc["sep" + _loc7_]._x = _loc9_ - 2;
            this.listContent.disableHeader._width = this.totalWidth;
         }
         var _loc2_ = 0;
         while(_loc2_ < this.__rowCount)
         {
            if(_loc7_ == 0)
            {
               this.rows[_loc2_].colBG.clear();
            }
            var _loc8_ = _loc6_.__width;
            this.rows[_loc2_].drawCell(_loc7_,_loc5_,_loc8_,_loc10_);
            _loc2_ = _loc2_ + 1;
         }
         _loc5_ = _loc9_;
         _loc7_ = _loc7_ + 1;
      }
      if(this.getStyle("hGridLines"))
      {
         this.lines_mc.lineStyle(0,this.getStyle("hGridLineColor"));
         _loc7_ = 1;
         while(_loc7_ < this.__rowCount)
         {
            this.lines_mc.moveTo(4,this.rows[_loc7_]._y);
            this.lines_mc.lineTo(this.totalWidth,this.rows[_loc7_]._y);
            _loc7_ = _loc7_ + 1;
         }
      }
   }
   function initRows(Void)
   {
      var _loc2_ = 0;
      while(_loc2_ < this.__rowCount)
      {
         this.rows[_loc2_].createCells();
         _loc2_ = _loc2_ + 1;
      }
   }
   function onRowPress(rowIndex)
   {
      super.onRowPress(rowIndex);
      if(!this.enabled)
      {
         return undefined;
      }
      var _loc11_ = this.columns.length;
      var _loc6_ = this.rows[rowIndex];
      var _loc3_ = 0;
      while(_loc3_ < _loc11_)
      {
         var _loc5_ = this.columns[_loc3_];
         var _loc4_ = _loc6_._xmouse - _loc6_.cells[_loc3_]._x;
         if(_loc4_ >= 0 && _loc4_ < _loc5_.__width)
         {
            this.dispatchEvent({type:"cellPress",columnIndex:_loc3_,view:this,itemIndex:rowIndex + this.__vPosition});
            return undefined;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function get showHeaders()
   {
      return this.getShowHeaders();
   }
   function set showHeaders(w)
   {
      this.setShowHeaders(w);
   }
   function setShowHeaders(b)
   {
      this.__showHeaders = b;
      this.invInitHeaders = true;
      this.invDrawCols = true;
      this.invalidate();
   }
   function getShowHeaders()
   {
      return this.__showHeaders;
   }
   function get headerHeight()
   {
      return this.getHeaderHeight();
   }
   function set headerHeight(w)
   {
      this.setHeaderHeight(w);
   }
   function setHeaderHeight(h)
   {
      this.__headerHeight = h;
      this.invInitHeaders = true;
      this.invDrawCols = true;
      this.invalidate();
   }
   function getHeaderHeight(Void)
   {
      return this.__headerHeight;
   }
   function initHeaders(Void)
   {
      delete this.invInitHeaders;
      if(this.__showHeaders)
      {
         this.header_mc = this.listContent.createClassObject(mx.core.UIObject,"header_mc",this.HEADERDEPTH,{styleName:this});
         this.headerCells = new Array();
         var _loc2_ = 0;
         while(_loc2_ < this.columns.length)
         {
            var _loc6_ = this.columns[_loc2_];
            var _loc4_ = undefined;
            var _loc7_ = _loc6_.__headerRenderer;
            if(_loc7_ == undefined)
            {
               var _loc0_ = null;
               _loc4_ = this.headerCells[_loc2_] = this.header_mc.createLabel("fHeaderCell" + _loc2_,this.HEADERCELLDEPTH + _loc2_);
               _loc4_.selectable = false;
               _loc4_.setStyle("styleName",_loc6_);
            }
            else if(typeof _loc7_ == "string")
            {
               _loc4_ = this.headerCells[_loc2_] = this.header_mc.createObject(_loc7_,"fHeaderCell" + _loc2_,this.HEADERCELLDEPTH + _loc2_,{styleName:_loc6_});
            }
            else
            {
               _loc4_ = this.headerCells[_loc2_] = this.header_mc.createClassObject(_loc7_,"fHeaderCell" + _loc2_,this.HEADERCELLDEPTH + _loc2_,{styleName:_loc6_});
            }
            _loc4_.setValue(_loc6_.headerText);
            _loc6_.headerCell = _loc4_;
            var _loc3_ = this.header_mc.attachMovie("DataHeaderOverlay","hO" + _loc2_,this.HEADEROVERLAYDEPTH + _loc2_);
            _loc4_.hO = _loc3_;
            _loc3_.cell = _loc4_;
            _loc4_.column = _loc3_.column = _loc6_;
            _loc4_.asc = _loc3_.asc = false;
            _loc4_.owner = _loc3_.owner = this;
            _loc3_._alpha = 0;
            if(_loc3_.column.sortable && _loc3_.onPress == undefined)
            {
               _loc3_.useHandCursor = false;
               _loc3_.onRollOver = this.headerRollOver;
               _loc3_.onRollOut = this.headerRollOut;
               _loc3_.onPress = this.headerPress;
               _loc3_.onRelease = this.headerRelease;
               _loc3_.onReleaseOutside = this.headerUp;
               _loc3_.headerUp = this.headerUp;
            }
            if(_loc2_ < this.columns.length - 1)
            {
               var _loc5_ = this.header_mc.attachMovie("DataHeaderSeperator","sep" + _loc2_,this.SEPARATORDEPTH + _loc2_);
               _loc5_._height = this.__headerHeight;
               if(_loc6_.resizable && this.resizableColumns)
               {
                  _loc5_.useHandCursor = false;
                  _loc5_.col = _loc2_;
                  _loc5_.owner = this;
                  _loc5_.onRollOver = this.showStretcher;
                  _loc5_.onPress = this.startSizing;
                  _loc5_.onRelease = _loc5_.onReleaseOutside = this.stopSizing;
                  _loc5_.onRollOut = this.hideStretcher;
               }
            }
            _loc2_ = _loc2_ + 1;
         }
         this.drawHeaderBG();
      }
      else
      {
         this.header_mc.removeMovieClip();
      }
   }
   function invalidateHeaderStyle(Void)
   {
      var _loc4_ = this.columns.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc4_)
      {
         var _loc2_ = this.headerCells[_loc3_];
         if(_loc2_.stylecache != undefined)
         {
            delete _loc2_.stylecache.tf;
         }
         delete _loc2_.enabledColor;
         _loc2_.invalidateStyle();
         _loc2_.draw();
         _loc3_ = _loc3_ + 1;
      }
   }
   function drawHeaderBG(Void)
   {
      var _loc2_ = this.header_mc;
      _loc2_.clear();
      var _loc5_ = this.getStyle("headerColor");
      var _loc3_ = this.__viewMetrics;
      var _loc4_ = Math.max(this.totalWidth,this.displayWidth + 3);
      _loc2_.moveTo(_loc3_.left,_loc3_.top);
      var _loc7_ = {matrixType:"box",x:0,y:0,w:_loc4_,h:this.__headerHeight + 1,r:1.5707963267948966};
      var _loc8_ = [_loc5_,_loc5_,16777215];
      var _loc9_ = [0,60,255];
      var _loc6_ = [100,100,100];
      _loc2_.beginGradientFill("linear",_loc8_,_loc6_,_loc9_,_loc7_);
      _loc2_.lineStyle(0,0,0);
      _loc2_.lineTo(_loc4_,_loc3_.top);
      _loc2_.lineTo(_loc4_,this.__headerHeight + 1);
      _loc2_.lineStyle(0,0,100);
      _loc2_.lineTo(_loc3_.left,this.__headerHeight + 1);
      _loc2_.lineStyle(0,0,0);
      _loc2_.endFill();
   }
   function enableHeader(v)
   {
      if(v)
      {
         this.listContent.disableHeader.removeMovieClip();
      }
      else
      {
         var _loc2_ = this.listContent.attachMovie("DataHeaderOverlay","disableHeader",this.DISABLEDHEADERDEPTH);
         _loc2_._width = this.totalWidth;
         _loc2_._height = this.__headerHeight;
         var _loc3_ = new Color(_loc2_);
         _loc3_.setRGB(this.getStyle("backgroundDisabledColor"));
         _loc2_._alpha = 60;
      }
   }
   function placeSortArrow(Void)
   {
      this.sortArrow.removeMovieClip();
      if(this.sortIndex == undefined)
      {
         return undefined;
      }
      if(this.columns[this.sortIndex].__width - this.headerCells[this.sortIndex].getPreferredWidth() <= 20)
      {
         return undefined;
      }
      this.sortArrow = this.header_mc.createObject("DataSortArrow","sortArrow",this.SORTARROWDEPTH);
      var _loc3_ = this.layoutX;
      var _loc2_ = 0;
      while(_loc2_ <= this.sortIndex)
      {
         _loc3_ += this.columns[_loc2_].__width;
         _loc2_ = _loc2_ + 1;
      }
      var _loc4_ = this.sortDirection == "ASC";
      this.sortArrow._yscale = !_loc4_ ? 100 : -100;
      this.sortArrow._x = _loc3_ - this.sortArrow._width - 8;
      this.sortArrow._y = (this.__headerHeight - this.sortArrow._height) / 2 + _loc4_ * this.sortArrow._height;
   }
   function headerRollOver(Void)
   {
      var _loc2_ = this.owner;
      if(!_loc2_.enabled || _loc2_.cellEditor != undefined || !_loc2_.sortableColumns || !this.column.sortable)
      {
         return undefined;
      }
      var _loc3_ = new Color(this);
      _loc3_.setRGB(_loc2_.getStyle("rollOverColor"));
      this._alpha = 50;
   }
   function headerRollOut(Void)
   {
      this._alpha = 0;
   }
   function headerPress(Void)
   {
      var _loc2_ = this.owner;
      if(!this.column.sortable || !_loc2_.sortableColumns || !_loc2_.enabled)
      {
         return undefined;
      }
      this.cell._x += 1;
      this.cell._y += 1;
      var _loc3_ = new Color(this);
      _loc3_.setRGB(_loc2_.getStyle("selectionColor"));
      this._alpha = 100;
   }
   function headerUp(Void)
   {
      if(!this.column.sortable || !this.owner.sortableColumns || !this.owner.enabled)
      {
         return undefined;
      }
      this._alpha = 0;
      this.cell._x -= 1;
      this.cell._y -= 1;
   }
   function headerRelease(Void)
   {
      var _loc2_ = this.owner;
      var _loc3_ = this.column;
      if(!_loc3_.sortable || !_loc2_.sortableColumns || !_loc2_.enabled)
      {
         return undefined;
      }
      this.headerUp();
      this.asc = !this.asc;
      var _loc4_ = !this.asc ? "DESC" : "ASC";
      _loc2_.sortIndex = _loc2_.getColumnIndex(_loc3_.columnName);
      _loc2_.sortDirection = _loc4_;
      _loc2_.placeSortArrow();
      if(_loc3_.sortOnHeaderRelease)
      {
         _loc2_.sortItemsBy(_loc3_.columnName,_loc4_);
      }
      _loc2_.dispatchEvent({type:"headerRelease",view:_loc2_,columnIndex:_loc2_.getColumnIndex(_loc3_.columnName)});
      _loc2_.dontEdit = true;
   }
   function isStretchable(col)
   {
      var _loc2_ = true;
      if(!this.resizableColumns)
      {
         _loc2_ = false;
      }
      else if(!this.columns[col].resizable)
      {
         _loc2_ = false;
      }
      else if(col == this.columns.length - 2 && !this.columns[col + 1].resizable)
      {
         _loc2_ = false;
      }
      return _loc2_;
   }
   function showStretcher(Void)
   {
      var _loc2_ = this.owner;
      if(!_loc2_.isStretchable(this.col) || !_loc2_.enabled || _loc2_.cellEditor != undefined)
      {
         return undefined;
      }
      Mouse.hide();
      if(_loc2_.stretcher == undefined)
      {
         _loc2_.attachMovie("cursorStretch","stretcher",_loc2_.STRETCHERDEPTH);
      }
      _loc2_.stretcher._x = _loc2_._xmouse;
      _loc2_.stretcher._y = _loc2_._ymouse;
      _loc2_.stretcher._visible = true;
      _loc2_.onMouseMove = function()
      {
         this.stretcher._x = this._xmouse;
         this.stretcher._y = this._ymouse;
         updateAfterEvent();
      };
   }
   function startSizing(Void)
   {
      var _loc2_ = this.owner;
      if(!_loc2_.isStretchable(this.col) || !_loc2_.enabled)
      {
         return undefined;
      }
      _loc2_.pressFocus();
      _loc2_.attachMovie("DataStretchBar","stretchBar",999);
      _loc2_.stretchBar._height = _loc2_.height;
      _loc2_.stretchBar._x = _loc2_._xmouse;
      this.oldX = _loc2_.stretchBar._x;
      _loc2_.colX = this.oldX - _loc2_.columns[this.col].width;
      _loc2_.onMouseMove = function()
      {
         this.stretcher._x = this._xmouse;
         this.stretcher._y = this._ymouse;
         this.stretchBar._x = Math.max(this._xmouse,this.colX + this.minColWidth);
         if(this.__hScrollPolicy == "off")
         {
            this.stretchBar._x = Math.min(this.stretchBar._x,this.displayWidth - this.minColWidth);
         }
         updateAfterEvent();
      };
   }
   function stopSizing(Void)
   {
      var _loc2_ = this.owner;
      var _loc3_ = this.col;
      if(!_loc2_.isStretchable(_loc3_) || !_loc2_.enabled)
      {
         return undefined;
      }
      _loc2_.stretchBar._visible = false;
      this.onRollOut();
      var _loc4_ = _loc2_.stretchBar._x - this.oldX;
      _loc2_.resizeColumn(_loc3_,_loc2_.columns[_loc3_].width + _loc4_);
      _loc2_.dispatchEvent({type:"columnStretch",columnIndex:_loc3_});
   }
   function hideStretcher(Void)
   {
      this.owner.stretcher._visible = false;
      delete this.owner.onMouseMove;
      Mouse.show();
   }
   function set focusedCell(obj)
   {
      this.setFocusedCell(obj);
   }
   function get focusedCell()
   {
      return this.__focusedCell;
   }
   function setFocusedCell(coord, broadCast)
   {
      if(!this.enabled || !this.editable)
      {
         return undefined;
      }
      if(coord == undefined && this.cellEditor != undefined)
      {
         this.disposeEditor();
         return undefined;
      }
      var _loc2_ = coord.itemIndex;
      var _loc5_ = coord.columnIndex;
      if(_loc2_ == undefined)
      {
         _loc2_ = 0;
      }
      if(_loc5_ == undefined)
      {
         _loc5_ = 0;
      }
      var _loc9_ = this.columns[_loc5_].columnName;
      if(this.__vPosition > _loc2_)
      {
         this.setVPosition(_loc2_);
      }
      else
      {
         var _loc11_ = _loc2_ - this.__vPosition - this.__rowCount + this.roundUp + 1;
         if(_loc11_ > 0)
         {
            this.setVPosition(this.__vPosition + _loc11_);
         }
      }
      var _loc10_ = this.columns[_loc5_];
      var _loc8_ = this.rows[_loc2_ - this.__vPosition];
      var _loc3_ = _loc8_.cells[_loc5_];
      if(_loc3_._x > this.__hPosition + this.displayWidth || _loc3_._x < this.__hPosition)
      {
         this.setHPosition(_loc3_._x);
      }
      var _loc4_ = this.__dataProvider.getEditingData(_loc2_,_loc9_);
      if(_loc4_ == undefined)
      {
         _loc4_ = this.__dataProvider.getItemAt(_loc2_)[_loc9_];
      }
      if(_loc4_ == undefined)
      {
         _loc4_ = " ";
      }
      if(_loc3_.isCellEditor != true)
      {
         if(this.cellEditor == undefined)
         {
            this.cellEditor = this.listContent.createClassObject(mx.controls.TextInput,"editor_mc",this.EDITORDEPTH,{styleName:_loc10_,listOwner:this});
         }
         this.cellEditor.backgroundColor = 16777215;
         this.cellEditor._visible = true;
         this.cellEditor.setSize(_loc10_.__width,this.__rowHeight + 2);
         this.cellEditor._x = _loc3_._x - 1;
         this.cellEditor.text = _loc4_;
         this.editorMask = this.listContent.attachMovie("BoundingBox","editorMask",60001,{_alpha:0});
         this.cellEditor.setMask(this.editorMask);
         this.editorMask._width = this.cellEditor.width;
         this.editorMask._height = this.cellEditor.height;
         this.editorMask._y = this.cellEditor._y = _loc8_._y - 1;
         this.editorMask._x = this.cellEditor._x - this.editorMask._width;
         this.editTween = new mx.effects.Tween(this,this.cellEditor._x - this.editorMask._width,this.cellEditor._x,150);
      }
      else
      {
         this.cellEditor = _loc3_;
         this.cellEditor.setValue(_loc4_,this.__dataProvider.getItemAt(_loc2_));
      }
      var _loc6_ = this.getFocusManager();
      _loc6_.setFocus(this.cellEditor);
      _loc6_.defaultPushButtonEnabled = false;
      if(_loc3_.isCellEditor != true)
      {
         this.cellEditor.hPosition = 0;
         this.cellEditor.redraw();
         Selection.setSelection(0,this.cellEditor.length);
      }
      this.__focusedCell = coord;
      if(this.__tabHandlerCache == undefined)
      {
         this.__tabHandlerCache = _loc6_.tabHandler;
         _loc6_.tabHandler = this.tabHandler;
      }
      _loc6_.activeGrid = this;
      this.cellEditor.addEventListener("keyDown",this.editorKeyDown);
      if(broadCast)
      {
         this.dispatchEvent({type:"cellFocusIn",itemIndex:_loc2_,columnIndex:_loc5_});
      }
   }
   function onMouseDown(Void)
   {
      if(this.cellEditor._visible && !this.cellEditor.hitTest(_root._xmouse,_root._ymouse))
      {
         this.editCell();
      }
      if(this.vScroller.hitTest(_root._xmouse,_root._ymouse) || this.hScroller.hitTest(_root._xmouse,_root._ymouse) || this.header_mc.hitTest(_root._xmouse,_root._ymouse))
      {
         this.dontEdit = true;
      }
   }
   function editorKeyDown(Void)
   {
      if(Key.isDown(27))
      {
         this.listOwner.disposeEditor();
      }
      else if(Key.isDown(13) && Key.getCode() != 229)
      {
         this.listOwner.editCell();
         this.listOwner.findNextEnterCell();
      }
   }
   function tabHandler(Void)
   {
      var _loc3_ = -1;
      var _loc4_ = -1;
      var _loc2_ = this.activeGrid;
      if(_loc2_.__focusedCell != undefined)
      {
         _loc3_ = _loc2_.__focusedCell.itemIndex;
         _loc4_ = _loc2_.__focusedCell.columnIndex;
      }
      _loc2_.editCell();
      _loc2_.findNextCell(_loc3_,_loc4_);
   }
   function findNextEnterCell(Void)
   {
      var _loc3_ = !Key.isDown(16) ? 1 : -1;
      var _loc2_ = this.__focusedCell.itemIndex + _loc3_;
      if(_loc2_ < this.getLength() && _loc2_ >= 0)
      {
         this.__focusedCell.itemIndex = _loc2_;
      }
      this.setFocusedCell(this.__focusedCell,true);
   }
   function findNextCell(index, colIndex)
   {
      if(index == undefined)
      {
         index = colIndex = -1;
      }
      var _loc5_ = false;
      var _loc4_ = !Key.isDown(16) ? 1 : -1;
      while(!_loc5_)
      {
         colIndex += _loc4_;
         if(colIndex >= this.columns.length || colIndex < 0)
         {
            colIndex = colIndex >= 0 ? 0 : this.columns.length;
            index += _loc4_;
            if(index >= this.getLength() || index < 0)
            {
               if(this.getFocusManager().activeGrid != undefined)
               {
                  this.disposeEditor();
               }
               this.dontEdit = true;
               Selection.setFocus(this);
               delete this.dontEdit;
               this.getFocusManager().tabHandler();
               return undefined;
            }
         }
         if(this.columns[colIndex].editable)
         {
            _loc5_ = true;
            if(this.__tabHandlerCache != undefined)
            {
               this.disposeEditor();
            }
            this.setFocusedCell({itemIndex:index,columnIndex:colIndex},true);
         }
      }
   }
   function onSetFocus(Void)
   {
      super.onSetFocus();
      if(this.editable && this.dontEdit != true)
      {
         if(this.__focusedCell == undefined)
         {
            this.__focusedCell = {itemIndex:0,columnIndex:0};
         }
         if(this.columns[this.__focusedCell.columnIndex].editable == true)
         {
            this.setFocusedCell(this.__focusedCell,true);
         }
         else
         {
            this.findNextCell(this.__focusedCell.itemIndex,this.__focusedCell.columnIndex);
         }
      }
      delete this.dontEdit;
   }
   function onTweenUpdate(val)
   {
      this.editorMask._x = val;
   }
   function onTweenEnd(val)
   {
      this.editorMask._x = val;
      this.cellEditor.setMask(undefined);
      this.editorMask.removeMovieClip();
   }
   function disposeEditor(Void)
   {
      this.cellEditor.removeEventListener("keyDown",this.editorKeyDown);
      this.dispatchEvent({type:"cellFocusOut",itemIndex:this.__focusedCell.itemIndex,columnIndex:this.__focusedCell.columnIndex});
      if(this.cellEditor.isCellEditor != true)
      {
         this.cellEditor._visible = false;
      }
      var _loc3_ = this.getFocusManager();
      if(this.__tabHandlerCache != undefined)
      {
         _loc3_.tabHandler = this.__tabHandlerCache;
         delete this.__tabHandlerCache;
      }
      _loc3_.defaultPushButtonEnabled = true;
      if(this.border_mc.hitTest(_root._xmouse,_root._ymouse) && !this.vScroller.hitTest(_root._xmouse,_root._ymouse) && !this.hScroller.hitTest(_root._xmouse,_root._ymouse))
      {
         this.dontEdit = true;
         this.releaseFocus();
         delete this.dontEdit;
      }
      delete this.cellEditor;
      delete _loc3_.activeGrid;
   }
   function editCell()
   {
      var _loc3_ = this.__focusedCell.itemIndex;
      var _loc4_ = this.columns[this.__focusedCell.columnIndex].columnName;
      var _loc2_ = this.__dataProvider.getEditingData(_loc3_,_loc4_);
      if(_loc2_ == undefined)
      {
         _loc2_ = this.__dataProvider.getItemAt(_loc3_)[_loc4_];
      }
      var _loc5_ = !this.cellEditor.isCellEditor ? this.cellEditor.text : this.cellEditor.getValue();
      if(_loc2_ != _loc5_)
      {
         this.editField(_loc3_,_loc4_,_loc5_);
         this.dispatchEvent({type:"cellEdit",itemIndex:_loc3_,columnIndex:this.__focusedCell.columnIndex,oldValue:_loc2_});
      }
      this.disposeEditor();
   }
   function invalidateStyle(propName)
   {
      if(propName == "headerColor" || propName == "styleName")
      {
         this.drawHeaderBG();
      }
      if(propName == "hGridLines" || propName == "hGridLineColor" || propName == "vGridLines" || propName == "vGridLineColor" || propName == "styleName" || propName == "backgroundColor")
      {
         this.invDrawCols = true;
         this.invalidate();
      }
      if(mx.styles.StyleManager.TextStyleMap[propName] != undefined)
      {
         super.changeTextStyleInChildren(propName);
      }
      if(propName == "styleName" || propName == "headerStyle")
      {
         this.invalidateHeaderStyle();
      }
      super.invalidateStyle(propName);
   }
   function notifyStyleChangeInChildren(sheetName, styleProp, newValue)
   {
      if(styleProp == "headerStyle")
      {
         this.invalidateHeaderStyle();
      }
      if(sheetName != undefined)
      {
         var _loc4_ = 0;
         while(_loc4_ < this.columns.length)
         {
            if(sheetName == this.columns[_loc4_].styleName)
            {
               this.invalidateStyle(styleProp);
               var _loc3_ = 0;
               while(_loc3_ < this.rows.length)
               {
                  this.rows[_loc3_].notifyStyleChangeInChildren(sheetName,styleProp,newValue);
                  _loc3_ = _loc3_ + 1;
               }
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      super.notifyStyleChangeInChildren(sheetName,styleProp,newValue);
   }
}
