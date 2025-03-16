class mx.controls.menuclasses.MenuBarItem extends mx.core.UIComponent
{
   var __initText;
   var cell;
   var owner;
   var __width;
   var __height;
   var border_mc;
   var menuBarIndex;
   var __cellHeightBuffer = 3;
   var __cellWidthBuffer = 20;
   var __isDown = false;
   var __isClosing = false;
   function MenuBarItem()
   {
      super();
   }
   function createChildren(Void)
   {
      super.createChildren();
      this.createLabel("cell",20);
      this.cell.setValue(this.__initText);
      this.createClassObject(mx.skins.halo.ActivatorSkin,"border_mc",0,{styleName:this.owner,borderStyle:"none"});
      this.useHandCursor = false;
      this.trackAsMenu = true;
   }
   function size(Void)
   {
      super.size();
      this.border_mc.setSize(this.__width,this.__height);
      this.cell.setSize(this.__width - this.__cellWidthBuffer,this.cell.getPreferredHeight());
      this.cell._x = this.__cellWidthBuffer / 2;
      this.cell._y = (this.__height - this.cell._height) / 2;
   }
   function getPreferredWidth(Void)
   {
      return this.cell.getPreferredWidth() + this.__cellWidthBuffer;
   }
   function setLabelBorder(style)
   {
      this.border_mc.borderStyle = style;
      this.border_mc.draw();
   }
   function setEnabled(state)
   {
      this.cell.enabled = state;
      if(!this.enabled)
      {
         this.setLabelBorder("none");
      }
   }
   function onPress(Void)
   {
      this.owner.onItemPress(this.menuBarIndex);
   }
   function onRelease(Void)
   {
      this.owner.onItemRelease(this.menuBarIndex);
   }
   function onRollOver(Void)
   {
      this.owner.onItemRollOver(this.menuBarIndex);
   }
   function onRollOut(Void)
   {
      this.owner.onItemRollOut(this.menuBarIndex);
   }
   function onDragOver(Void)
   {
      this.owner.onItemDragOver(this.menuBarIndex);
   }
   function onDragOut(Void)
   {
      this.owner.onItemDragOut(this.menuBarIndex);
   }
}
