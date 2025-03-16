class com.gskinner.controls.SimpleTab extends MovieClip
{
   var __width;
   var dispatchEvent;
   var _label;
   var labelFld;
   static var CLASS_REF = com.gskinner.controls.SimpleTab;
   static var LINKAGE_ID = "SimpleTab";
   var height = 19;
   var __enabled = true;
   var _selected = false;
   function SimpleTab()
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.configUI();
   }
   function onLoad()
   {
   }
   function get width()
   {
      return this.__width;
   }
   function set width(p_width)
   {
      this.__width = p_width;
   }
   function get enabled()
   {
      return this.__enabled;
   }
   function set enabled(p_enabled)
   {
      if(this.__enabled == p_enabled)
      {
         return;
      }
      this.__enabled = p_enabled;
      this.dispatchEvent({type:"change"});
      this.draw();
   }
   function get label()
   {
      return this._label;
   }
   function set label(p_label)
   {
      this._label = p_label;
      this.labelFld.textColor = !this.enabled ? 10066329 : 0;
      this.dispatchEvent({type:"change"});
   }
   function get selected()
   {
      return this._selected;
   }
   function set selected(p_selected)
   {
      this._selected = p_selected;
      this.draw();
   }
   function configUI()
   {
      this.labelFld._width = this.labelFld.textWidth + 5;
      this.labelFld._height = this.labelFld.textHeight + 2;
      this.width = Math.ceil(this.labelFld._x + this.labelFld._width + 5);
      this.draw();
   }
   function draw()
   {
      this.clear();
      if(this.enabled)
      {
         this.beginFill(!this.selected ? 15658734 : 16777215);
         this.labelFld.textColor = 0;
      }
      else
      {
         this.beginFill(14540253);
         this.labelFld.textColor = 10066329;
      }
      this.lineStyle(0,10066329);
      this.moveTo(0,this.height);
      this.lineTo(0,0);
      this.lineTo(this.width - 4,0);
      this.lineTo(this.width + 8,this.height);
      this.lineStyle(0,16777215);
      this.endFill();
   }
   function onRelease()
   {
      if(!this.enabled)
      {
         return undefined;
      }
      this.dispatchEvent({type:"click"});
   }
}
