﻿package asunit4.async {
	
	/**
	 *
	 */
	//TODO: failureHandler:Function=null
	public function addAsync(test:Object, handler:Function, duration:int = -1):Function {
		return Async.instance.addAsync(test, handler, duration);
	}
	
}
