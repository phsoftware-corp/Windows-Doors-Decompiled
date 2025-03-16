class mx.controls.menuclasses.MenuDataProvider extends Object
{
   var addTreeNode;
   var addTreeNodeAt;
   var removeTreeNode;
   var getTreeNodeAt;
   var childNodes;
   static var mixinProps = ["addMenuItem","addMenuItemAt","getMenuItemAt","removeMenuItem","removeMenuItemAt","normalize","indexOf"];
   static var mixins = new mx.controls.menuclasses.MenuDataProvider();
   function MenuDataProvider()
   {
      super();
   }
   static function Initialize(obj)
   {
      obj = obj.prototype;
      var _loc3_ = mx.controls.menuclasses.MenuDataProvider.mixinProps;
      var _loc5_ = _loc3_.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc5_)
      {
         obj[_loc3_[_loc2_]] = mx.controls.menuclasses.MenuDataProvider.mixins[_loc3_[_loc2_]];
         _global.ASSetPropFlags(obj,_loc3_[_loc2_],1);
         _loc2_ = _loc2_ + 1;
      }
      return true;
   }
   function addMenuItem(arg)
   {
      return this.addTreeNode(mx.controls.treeclasses.TreeDataProvider.convertToNode("menuitem",arg));
   }
   function addMenuItemAt(index, arg)
   {
      return this.addTreeNodeAt(index,mx.controls.treeclasses.TreeDataProvider.convertToNode("menuitem",arg));
   }
   function removeMenuItem(Void)
   {
      return this.removeTreeNode();
   }
   function removeMenuItemAt(index)
   {
      return this.getTreeNodeAt(index).removeTreeNode();
   }
   function getMenuItemAt(index)
   {
      return this.getTreeNodeAt(index);
   }
   function indexOf(item)
   {
      var _loc2_ = 0;
      while(_loc2_ < this.childNodes.length)
      {
         if(this.childNodes[_loc2_] == item)
         {
            return _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      return undefined;
   }
}
