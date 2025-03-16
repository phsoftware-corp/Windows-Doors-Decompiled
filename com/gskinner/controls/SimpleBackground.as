class com.gskinner.controls.SimpleBackground extends MovieClip
{
   var __width;
   var __height;
   static var CLASS_REF = com.gskinner.controls.SimpleBackground;
   static var LINKAGE_ID = "SimpleBackground";
   var loaded = false;
   function SimpleBackground()
   {
      super();
   }
   function onLoad()
   {
      this.configUI();
   }
   function setSize(p_width, p_height)
   {
      this.__width = p_width;
      this.__height = p_height;
      this.draw();
   }
   function get width()
   {
      return this.__width;
   }
   function get height()
   {
      return this.__height;
   }
   function configUI()
   {
      if(this.width == undefined)
      {
         this.setSize(this._width,this._height);
      }
      this.gotoAndStop(2);
      this.loaded = true;
      this.draw();
   }
   function draw()
   {
      if(!this.loaded)
      {
         return undefined;
      }
      this.clear();
      this.moveTo(0,0);
      this.lineStyle(0,10066329);
      this.beginFill(16777215);
      this.lineTo(this.width,0);
      this.lineTo(this.width,this.height);
      this.lineTo(0,this.height);
      this.lineTo(0,0);
      this.endFill();
      this.lineStyle(0,14540253);
      this.moveTo(2,2);
      this.lineTo(this.width - 2,2);
      this.lineTo(this.width - 2,this.height - 2);
      this.lineTo(2,this.height - 2);
      this.lineTo(2,2);
   }
}
