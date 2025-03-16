class mx.controls.gridclasses.DataGridColumn extends mx.styles.CSSStyleDeclaration
{
   var columnName;
   var parentGrid;
   var colNum;
   var __header;
   var headerCell;
   var __cellRenderer;
   var __headerRenderer;
   var __labelFunction;
   var styleName;
   var editable = true;
   var sortable = true;
   var resizable = true;
   var sortOnHeaderRelease = true;
   var __width = 50;
   function DataGridColumn(colName)
   {
      super();
      this.columnName = colName;
      this.headerText = colName;
   }
   function get width()
   {
      return this.__width;
   }
   function set width(w)
   {
      delete this.parentGrid.invSpaceColsEqually;
      if(this.parentGrid != undefined && this.parentGrid.hasDrawn)
      {
         var _loc2_ = this.resizable;
         this.resizable = false;
         this.parentGrid.resizeColumn(this.colNum,w);
         this.resizable = _loc2_;
      }
      else
      {
         this.__width = w;
      }
   }
   function set headerText(h)
   {
      this.__header = h;
      this.headerCell.setValue(h);
   }
   function get headerText()
   {
      return this.__header != undefined ? this.__header : this.columnName;
   }
   function set cellRenderer(cR)
   {
      this.__cellRenderer = cR;
      this.parentGrid.invColChange = true;
      this.parentGrid.invalidate();
   }
   function get cellRenderer()
   {
      return this.__cellRenderer;
   }
   function set headerRenderer(hS)
   {
      this.__headerRenderer = hS;
      this.parentGrid.invInitHeaders = true;
      this.parentGrid.invalidate();
   }
   function get headerRenderer()
   {
      return this.__headerRenderer;
   }
   function set labelFunction(f)
   {
      this.__labelFunction = f;
      this.parentGrid.invUpdateControl = true;
      this.parentGrid.invalidate();
   }
   function get labelFunction()
   {
      return this.__labelFunction;
   }
   function getStyle(prop)
   {
      var _loc3_ = this[prop];
      if(_loc3_ == undefined)
      {
         if(this.styleName != undefined)
         {
            if(this.styleName instanceof mx.styles.CSSStyleDeclaration)
            {
               _loc3_ = this.styleName.getStyle(prop);
            }
            else
            {
               _loc3_ = _global.styles[this.styleName].getStyle(prop);
            }
         }
         if((_loc3_ == undefined || _loc3_ == _global.style[prop] || _loc3_ == _global.styles[this.parentGrid.className][prop]) && prop != "backgroundColor")
         {
            _loc3_ = this.parentGrid.getStyle(prop);
         }
      }
      return _loc3_;
   }
   function __getTextFormat(tf, bAll, fieldInst)
   {
      var _loc4_ = undefined;
      if(this.parentGrid.header_mc[fieldInst._name] != undefined)
      {
         _loc4_ = this.getStyle("headerStyle").__getTextFormat(tf,bAll,fieldInst);
         if(_loc4_ != false)
         {
            _loc4_ = this.parentGrid.getStyle("headerStyle").__getTextFormat(tf,bAll,fieldInst);
         }
         if(_loc4_ == false)
         {
            return _loc4_;
         }
      }
      if(this.styleName != undefined)
      {
         var _loc8_ = typeof this.styleName != "string" ? this.styleName : _global.styles[this.styleName];
         _loc4_ = _loc8_.__getTextFormat(tf,bAll);
         if(!_loc4_)
         {
            return _loc4_;
         }
      }
      _loc4_ = super.__getTextFormat(tf,bAll,fieldInst);
      if(_loc4_)
      {
         return this.parentGrid.__getTextFormat(tf,bAll);
      }
      return _loc4_;
   }
}
