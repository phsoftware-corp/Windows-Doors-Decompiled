class mx.skins.halo.ActivatorSkin extends mx.skins.RectBorder
{
   var drawRoundRect;
   static var symbolName = "ActivatorSkin";
   static var symbolOwner = mx.skins.halo.ActivatorSkin;
   var className = "ActivatorSkin";
   var backgroundColorName = "buttonColor";
   static var classConstructed = mx.skins.halo.ActivatorSkin.classConstruct();
   static var UIObjectExtensionsDependency = mx.core.ext.UIObjectExtensions;
   function ActivatorSkin()
   {
      super();
   }
   function init()
   {
      super.init();
   }
   function size()
   {
      this.drawHaloRect(this.width,this.height);
   }
   function drawHaloRect(w, h)
   {
      var _loc5_ = this.getStyle("borderStyle");
      var _loc4_ = this.getStyle("themeColor");
      this.clear();
      switch(_loc5_)
      {
         case "none":
            this.drawRoundRect(this.x,this.y,w,h,0,16777215,0);
            break;
         case "falsedown":
            this.drawRoundRect(this.x,this.y,w,h,0,9542041,100);
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,0,[3355443,16579836],100,-90,"radial");
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,0,_loc4_,50);
            this.drawRoundRect(this.x + 3,this.y + 3,w - 6,h - 6,0,16777215,100);
            this.drawRoundRect(this.x + 3,this.y + 4,w - 6,h - 7,0,_loc4_,20);
            break;
         case "falserollover":
            this.drawRoundRect(this.x,this.y,w,h,0,9542041,100);
            this.drawRoundRect(this.x,this.y,w,h,0,_loc4_,50);
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,0,[3355443,16777215],100,0,"radial");
            this.drawRoundRect(this.x + 3,this.y + 3,w - 6,h - 6,0,16777215,100);
            this.drawRoundRect(this.x + 3,this.y + 4,w - 6,h - 7,0,16316664,100);
      }
   }
   static function classConstruct()
   {
      mx.core.ext.UIObjectExtensions.Extensions();
      _global.skinRegistry.ActivatorSkin = true;
      return true;
   }
}
