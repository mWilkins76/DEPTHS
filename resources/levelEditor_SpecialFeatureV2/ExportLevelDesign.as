package  {
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.display.DisplayObjectContainer;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ExportLevelDesign extends MovieClip {
		
		private var content:Object;
		private var file: FileReference;
		private var level:String;
		private const GRID_SCALE:Number = 100;
		private const GRID_NAME:String = "Map_";
		private var levelNumber:int;
		private var totalMap:int = 2;
		private var currentMap:int = 0;
		
		public function ExportLevelDesign() {
			stop();
			browse();
		}
		
		private function browse (pEvent:Event = null):void {
			if (pEvent!=null) nextFrame();
			browseLevel(); 
		}
		
		private function getScaleAndRotation(pItem:DisplayObjectContainer):Object {
			var lObject:Object= {scaleX: pItem.scaleX, scaleY:pItem.scaleY, rotation:pItem.rotation};
			if (pItem.rotation==0 || pItem.rotation == 180) {
				lObject.scaleX = pItem.transform.matrix.a;
				lObject.scaleY = pItem.transform.matrix.d;
				lObject.rotation = 0;
			}
			return lObject;
		}
		
		private function browseLevel (): void 
		{
			file = new FileReference();	

			content={};
					
			
			/*content[GRID_NAME+currentMap] = {};
			content[GRID_NAME+currentMap].cols = Math.floor(width / GRID_SCALE);
			content[GRID_NAME+currentMap].rows = Math.floor(height / GRID_SCALE);
			content[GRID_NAME+currentMap].scale = GRID_SCALE;*/
			
			var lItem;
			var lName:String;
			var lScaleAndRotation:Object;
			var HC:String;
			
			for (var i:int = 0; i<numChildren;i++) {
				lItem=getChildAt(i);
				if (lItem is DisplayObjectContainer) {
					lName=lItem.name;
					content[lName]={};
					content[lName].index = i;
					content[lName].type=getQualifiedClassName(lItem);
					content[lName].x=Math.floor(lItem.x/100);
					content[lName].y=Math.floor(lItem.y/100);
					content[lName].globalX=lItem.x;
					content[lName].globalY=lItem.y;
					//content[lName].HC = lItem.getChild[0];
					//trace(lItem.getChildByName("HC").text);
					lScaleAndRotation=getScaleAndRotation(lItem);
					
					content[lName].scaleX=lScaleAndRotation.scaleX;
					content[lName].scaleY=lScaleAndRotation.scaleY;
					content[lName].rotation = lScaleAndRotation.rotation;
					
					content[lName].width=lItem.width/100;
					content[lName].height=lItem.height/100;
					content[lName].globalWidth=lItem.width;
					content[lName].globalHeight=lItem.height;
				}
			}

			var lData:ByteArray = new ByteArray();
			lData.writeMultiByte(JSON.stringify(content,null,"\t"), "utf-8" );

			if (currentFrame<totalFrames) file.addEventListener(Event.COMPLETE,browse);
			
			file.save(lData, "Map"+currentFrame+".json" );
			
			
		}
		
	}
	
}
