package asunit.core {
    
    import asunit.asserts.*;
    import asunit.framework.IAsync;
    import asunit.printers.TextPrinter;
    import asunit.support.CustomTestRunner;
    import asunit.support.SuiteWithCustomRunner;
    import asunit.support.SucceedAssertTrue;

    import flash.display.Sprite;
    import flash.events.Event;

	public class AsUnitCoreTest {

        [Inject]
        public var async:IAsync;

        [Inject]
		public var core:AsUnitCore;

        [Inject]
        public var context:Sprite;

        [After]
        public function cleanUpStatics():void {
            CustomTestRunner.runCalledCount = 0;
        }

        [Test]
		public function shouldBeInstantiated():void {
			assertTrue("core is AsUnitCore", core is AsUnitCore);
		}

        [Test]
        public function startShouldWork():void {
            core.start(SucceedAssertTrue);
        }

        [Test]
        public function setVisualContextShouldWork():void {
            core.visualContext = context;
            assertEquals(context, core.visualContext);
        }

        [Test]
        public function textPrinterShouldWork():void {
            var printer:TextPrinter = new TextPrinter();
            printer.traceOnComplete = false;
            core.addObserver(printer);

            // Wait for the complete event:
            var handler:Function = function(event:Event):void {
                var output:String = printer.toString();
                assertTrue("should include test summary", output.indexOf('OK (1 test)') > -1);
                assertTrue("should include provided test name", output.indexOf('asunit.support::SucceedAssertTrue') > -1);
            }

            core.addEventListener(Event.COMPLETE, async.add(handler));
            core.start(SucceedAssertTrue);
        }

        [Test]
        public function testRunWithOnASuite():void {
            core.addEventListener(Event.COMPLETE, async.add(verifyCustomRunnerCalled));
            core.start(SuiteWithCustomRunner);
        }

        private function verifyCustomRunnerCalled():void {
            var message:String = "CustomRunner.run was NOT called with correct count";
            assertEquals(message, 3, CustomTestRunner.runCalledCount);
        }
	}
}

