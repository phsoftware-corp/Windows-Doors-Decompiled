class mx.controls.Label extends mx.core.UIObject
{
   var labelField;
   var _color;
   var initText;
   var __autoSize;
   var __width;
   var __height;
   static var symbolName = "Label";
   static var symbolOwner = Object(mx.controls.Label);
   var className = "Label";
   static var version = "2.0.2.127";
   var initializing = true;
   var clipParameters = {text:1,html:1,autoSize:1};
   static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.Label.prototype.clipParameters,mx.core.UIObject.prototype.clipParameters);
   function Label()
   {
      super();
   }
   function init(Void)
   {
      super.init();
      this._xscale = this._yscale = 100;
      this.labelField.selectable = false;
      this.labelField.styleName = this;
      this.tabEnabled = false;
      this.tabChildren = false;
      this.useHandCursor = false;
      this._color = mx.core.UIObject.textColorList;
   }
   function get html()
   {
      return this.getHtml();
   }
   function set html(value)
   {
      this.setHtml(value);
   }
   function getHtml()
   {
      return this.labelField.html;
   }
   function setHtml(value)
   {
      if(value != this.labelField.html)
      {
         this.labelField.html = value;
      }
   }
   function get text()
   {
      return this.getText();
   }
   function set text(t)
   {
      this.setText(t);
   }
   function getText()
   {
      if(this.initializing)
      {
         return this.initText;
      }
      var _loc2_ = this.labelField;
      if(_loc2_.html == true)
      {
         return _loc2_.htmlText;
      }
      return _loc2_.text;
   }
   function setText(t)
   {
      if(this.initializing)
      {
         this.initText = t;
      }
      else
      {
         var _loc2_ = this.labelField;
         if(_loc2_.html == true)
         {
            _loc2_.htmlText = t;
         }
         else
         {
            _loc2_.text = t;
         }
         this.adjustForAutoSize();
      }
   }
   function get autoSize()
   {
      return this.__autoSize;
   }
   function set autoSize(v)
   {
      if(_global.isLivePreview == true)
      {
         v = "none";
      }
      this.__autoSize = v;
      if(!this.initializing)
      {
         this.draw();
      }
   }
   function draw(Void)
   {
      var _loc2_ = this.labelField;
      if(this.initializing)
      {
         var _loc4_ = this.text;
         this.initializing = false;
         this.setText(_loc4_);
         delete this.initText;
      }
      if(_loc2_.html)
      {
         _loc4_ = _loc2_.htmlText;
      }
      var _loc3_ = this._getTextFormat();
      _loc2_.embedFonts = _loc3_.embedFonts == true;
      if(_loc3_ != undefined)
      {
         _loc2_.setTextFormat(_loc3_);
         _loc2_.setNewTextFormat(_loc3_);
      }
      if(_loc2_.html)
      {
         _loc2_.htmlText = _loc4_;
      }
      this.adjustForAutoSize();
   }
   function adjustForAutoSize()
   {
      var _loc2_ = this.labelField;
      var _loc3_ = this.__autoSize;
      if(_loc3_ != undefined && _loc3_ != "none")
      {
         _loc2_._height = _loc2_.textHeight + 3;
         var _loc4_ = this.__width;
         this.setSize(_loc2_.textWidth + 4,_loc2_._height);
         if(_loc3_ == "right")
         {
            this._x += _loc4_ - this.__width;
         }
         else if(_loc3_ == "center")
         {
            this._x += (_loc4_ - this.__width) / 2;
         }
         else if(_loc3_ == "left")
         {
            this._x += 0;
         }
      }
      else
      {
         _loc2_._x = 0;
         _loc2_._width = this.__width;
         _loc2_._height = this.__height;
      }
   }
   function size(Void)
   {
      var _loc2_ = this.labelField;
      _loc2_._width = this.__width;
      _loc2_._height = this.__height;
   }
   function setEnabled(enable)
   {
      var _loc2_ = this.getStyle(!enable ? "disabledColor" : "color");
      if(_loc2_ == undefined)
      {
         _loc2_ = !enable ? 8947848 : 0;
      }
      this.setColor(_loc2_);
   }
   function setColor(col)
   {
      this.labelField.textColor = col;
   }
   function get styleSheet()
   {
      return this.labelField.styleSheet;
   }
   function set styleSheet(v)
   {
      this.labelField.styleSheet = v;
   }
}
