class mx.controls.treeclasses.TreeDataProvider extends Object
{
   var childNodes;
   var appendChild;
   var insertBefore;
   var parentNode;
   var removeNode;
   static var mixinProps = ["addTreeNode","addTreeNodeAt","getTreeNodeAt","removeTreeNodeAt","getRootNode","getDepth","removeAll","removeTreeNode","updateViews"];
   static var evtDipatcher = mx.events.EventDispatcher;
   static var mixins = new mx.controls.treeclasses.TreeDataProvider();
   static var blankXML = new XML();
   static var largestID = 0;
   function TreeDataProvider()
   {
      super();
   }
   static function Initialize(obj)
   {
      obj = obj.prototype;
      if(obj.addTreeNode != undefined)
      {
         return false;
      }
      var _loc4_ = mx.controls.treeclasses.TreeDataProvider.mixinProps;
      var _loc5_ = _loc4_.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc5_)
      {
         obj[_loc4_[_loc2_]] = mx.controls.treeclasses.TreeDataProvider.mixins[_loc4_[_loc2_]];
         _global.ASSetPropFlags(obj,_loc4_[_loc2_],1);
         _loc2_ = _loc2_ + 1;
      }
      mx.events.EventDispatcher.initialize(obj);
      _global.ASSetPropFlags(obj,"addEventListener",1);
      _global.ASSetPropFlags(obj,"removeEventListener",1);
      _global.ASSetPropFlags(obj,"dispatchEvent",1);
      _global.ASSetPropFlags(obj,"dispatchQueue",1);
      _global.ASSetPropFlags(obj,"createEvent",1);
      return true;
   }
   function createProp(obj, propName, setter)
   {
      var p = propName.charAt(0).toUpperCase() + propName.substr(1);
      var _loc2_ = null;
      var _loc3_ = function(Void)
      {
         return this["get" + p]();
      };
      if(setter)
      {
         _loc2_ = function(val)
         {
            this["set" + p](val);
         };
      }
      obj.addProperty(propName,_loc3_,_loc2_);
   }
   static function convertToNode(tag, arg, data)
   {
      if(typeof arg == "string")
      {
         var _loc2_ = mx.controls.treeclasses.TreeDataProvider.blankXML.createElement(tag);
         _loc2_.attributes.label = arg;
         if(data != undefined)
         {
            _loc2_.attributes.data = data;
         }
         return _loc2_;
      }
      if(arg instanceof XML)
      {
         return arg.firstChild.cloneNode(true);
      }
      if(arg instanceof XMLNode)
      {
         return arg;
      }
      if(typeof arg == "object")
      {
         _loc2_ = mx.controls.treeclasses.TreeDataProvider.blankXML.createElement(tag);
         for(var _loc3_ in arg)
         {
            _loc2_.attributes[_loc3_] = arg[_loc3_];
         }
         if(data != undefined)
         {
            _loc2_.attributes.data = data;
         }
         return _loc2_;
      }
   }
   function addTreeNode(arg, data)
   {
      return this.addTreeNodeAt(this.childNodes.length,arg,data);
   }
   function addTreeNodeAt(index, arg, data)
   {
      if(index > this.childNodes.length)
      {
         return undefined;
      }
      var _loc2_ = undefined;
      if(arg instanceof XMLNode)
      {
         _loc2_ = arg.removeTreeNode();
      }
      else
      {
         _loc2_ = mx.controls.treeclasses.TreeDataProvider.convertToNode("node",arg,data);
      }
      if(index >= this.childNodes.length)
      {
         this.appendChild(_loc2_);
      }
      else
      {
         this.insertBefore(_loc2_,this.childNodes[index]);
      }
      this.updateViews({eventName:"addNode",node:_loc2_,parentNode:this,index:index});
      return _loc2_;
   }
   function getTreeNodeAt(index)
   {
      return this.childNodes[index];
   }
   function removeTreeNodeAt(index)
   {
      var _loc2_ = this.childNodes[index];
      _loc2_.removeNode();
      this.updateViews({eventName:"removeNode",node:_loc2_,parentNode:this,index:index});
      return _loc2_;
   }
   function removeTreeNode()
   {
      var _loc4_ = this.parentNode;
      var _loc7_ = undefined;
      var _loc3_ = 0;
      var _loc2_ = this.parentNode.firstChild;
      while(_loc2_ != undefined)
      {
         if(_loc2_ == this)
         {
            _loc7_ = _loc3_;
            break;
         }
         _loc3_ = _loc3_ + 1;
         _loc2_ = _loc2_.nextSibling;
      }
      if(_loc7_ != undefined)
      {
         var _loc5_ = this.getRootNode();
         this.removeNode();
         _loc4_.updateViews({eventName:"removeNode",node:this,parentNode:_loc4_,index:_loc7_});
      }
      return this;
   }
   function removeAll()
   {
      while(this.childNodes.length > 0)
      {
         this.removeTreeNodeAt(this.childNodes.length - 1);
      }
      var _loc2_ = this.getRootNode();
      this.updateViews({eventName:"updateTree"});
   }
   function getRootNode()
   {
      var _loc2_ = this;
      while(_loc2_.parentNode != undefined && _loc2_.isTreeRoot == undefined)
      {
         _loc2_ = _loc2_.parentNode;
      }
      return _loc2_;
   }
   function updateViews(eventObj)
   {
      var _loc2_ = this;
      eventObj.target = this;
      eventObj.type = "modelChanged";
      while(_loc2_ != undefined)
      {
         if(_loc2_.isTreeRoot || _loc2_.parentNode == undefined)
         {
            _loc2_.dispatchEvent(eventObj);
         }
         _loc2_ = _loc2_.parentNode;
      }
   }
}
