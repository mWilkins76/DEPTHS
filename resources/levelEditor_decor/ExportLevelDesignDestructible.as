package  {
	
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.display.DisplayObjectContainer;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ExportLevelDesignDestructible extends MovieClip {
		
		private var content:Object;
		private var finalJSON:Object;
		private var file: FileReference;
		private var level:String;
		private const GRID_SCALE:Number = 100;
		private const GRID_NAME:String = "Grid";
		
		public function ExportLevelDesignDestructible() {
			stop();
			browse();
		}
		
		private function browse (pEvent:Event=null):void {
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
		
		private function browseLevel (): void {
			trace("ca se lance");
			trace("currentFrame" + currentFrame);
			content={};
			finalJSON = {};
			file = new FileReference();
			
			var lItem;
			var lName:String;
			var lScaleAndRotation:Object;
			
			for (var i:int = 0; i<numChildren;i++) {
				trace(i);
				lItem=getChildAt(i);
				if (lItem is DisplayObjectContainer) {
					lName=lItem.name;
					content[lName]={};
					content[lName].type=getQualifiedClassName(lItem);
					content[lName].x=Math.round(lItem.x/100);
					content[lName].y=Math.round(lItem.y/100);
					content[lName].globalX=lItem.x;
					content[lName].globalY=lItem.y;
					
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
			
			//trace (JSON.stringify(content,null,"\t"));
			
			
			var lData:ByteArray = new ByteArray();
			lData.writeMultiByte(JSON.stringify(content,null,"\t"), "utf-8" );

			file.save(lData, "Config"+currentFrame+".json" );
			if (currentFrame<totalFrames) file.addEventListener(Event.COMPLETE,browse);
			
			
			
		}
		
	}
	
}
