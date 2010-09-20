package melomel.commands.parsers
{
import melomel.commands.InvokeFunctionCommand;
import melomel.core.ObjectProxyManager;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.display.Stage;

public class InvokeFunctionCommandParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:ICommandParser;
	private var command:InvokeFunctionCommand;
	private var manager:ObjectProxyManager;
	
	[Before]
	public function setUp():void
	{
		manager = new ObjectProxyManager();
		parser = new InvokeFunctionCommandParser(manager);
	}

	[After]
	public function tearDown():void
	{
		parser  = null;
		command = null;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Parse
	//-----------------------------

	[Test]
	public function parseWithFunctionAndArgs():void
	{
		// Assign actual proxy id to the message
		var message:XML = <invoke-function name="foo"><args><arg value="John"/><arg value="12" dataType="int"/></args></invoke-function>;

		// Parse message
		command = parser.parse(message) as InvokeFunctionCommand;
		Assert.assertEquals(command.functionName, "foo");
		Assert.assertEquals(command.methodArgs.length, 2);
		Assert.assertEquals(command.methodArgs[0], "John");
		Assert.assertEquals(command.methodArgs[1], 12);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithoutMessageThrowsError():void
	{
		parser.parse(null);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithInvalidActionThrowsError():void
	{
		var message:XML = <foo property="foo"><arg value="bar"/></foo>;
		parser.parse(message);
	}
	
	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithMissingFunctionThrowsError():void
	{
		parser.parse(<invoke-function property="foo"><args><arg value="bar"/></args></invoke-function>);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithNoParametersThrowsError():void
	{
		parser.parse(<invoke-function/>);
	}
}
}