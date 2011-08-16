package melomel.core
{
import melomel.core.uiClasses.MenuHelpersSandbox;
import melomel.core.MenuHelpers;

import org.flexunit.Assert;
import org.flexunit.async.Async;
import org.fluint.uiImpersonation.UIImpersonator;

import spark.components.Button;
import spark.components.ComboBox;
import spark.components.TextInput;
import mx.collections.ArrayList;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.CursorBookmark;
import mx.controls.ComboBox;
import mx.controls.DataGrid;
import mx.controls.MenuBar;
import mx.controls.menuClasses.MenuBarItem;
import mx.containers.Panel;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.NativeWindow;
import flash.display.NativeWindowInitOptions;
import flash.desktop.NativeApplication;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import flash.utils.getQualifiedClassName;

public class MenuHelpersTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var sandbox:MenuHelpersSandbox;
	private var window:NativeWindow;
	
	[Before(async)]
	public function setUp():void
	{
		sandbox = new MenuHelpersSandbox();
		Async.proceedOnEvent(this, sandbox, FlexEvent.CREATION_COMPLETE, 500);
		UIImpersonator.addChild(sandbox);
	}
	
	[After]
	public function tearDown():void
	{
		UIImpersonator.removeChild(sandbox);
		sandbox = null;
		
		if(window) {
			window.close();
		}
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Static methods
	//
	//---------------------------------------------------------------------

	[Test(timeout="1000")]
	public function shouldMakeCollectionOfXmlsFromXMLListDp():void
	{
        var mb: MenuBar = sandbox.mbWithXMLListDp.getChildAt(0) as MenuBar;
		var collection: ICollectionView =
				MenuHelpers.makeCollectionFromDataProvider( mb.dataProvider );

		Assert.assertNotNull( collection );

		for ( var cursor: IViewCursor = collection.createCursor();
			  cursor.afterLast == false;
			  cursor.moveNext() ) {

			Assert.assertEquals( "XML", getQualifiedClassName( cursor.current ) );
		}

        Assert.assertEquals( 4, collection.length );
	}

	[Test(timeout="1000")]
	public function shouldMakeCollectionOfXmlsFromXmlDp():void
	{
        var mb: MenuBar = sandbox.mbWithXMLDp.getChildAt(0) as MenuBar;
		var collection: ICollectionView =
				MenuHelpers.makeCollectionFromDataProvider( mb.dataProvider );

		Assert.assertNotNull( collection );

		for ( var cursor: IViewCursor = collection.createCursor();
			  cursor.afterLast == false;
			  cursor.moveNext() ) {

			Assert.assertEquals( "XML", getQualifiedClassName( cursor.current ) );
		}

        Assert.assertEquals( 3, collection.length );
	}


	[Test(timeout="1000")]
	public function shouldMakeCollectionOfXmlsFromXMLListColnDp():void
	{
        var mb: MenuBar = sandbox.mbWithXMLListColnDp.getChildAt(0) as MenuBar;
		var collection: ICollectionView =
				MenuHelpers.makeCollectionFromDataProvider( mb.dataProvider );

		Assert.assertNotNull( collection );

		for ( var cursor: IViewCursor = collection.createCursor();
			  cursor.afterLast == false;
			  cursor.moveNext() ) {

			Assert.assertEquals( "XML", getQualifiedClassName( cursor.current ) );
		}

        Assert.assertEquals( 5, collection.length );
	}


	[Test(timeout="1000")]
	public function shouldMakeCollectionOfXmlsFromStringDp():void
	{
        var mb: MenuBar = sandbox.mbWithStringDp.getChildAt(0) as MenuBar;
		var collection: ICollectionView =
				MenuHelpers.makeCollectionFromDataProvider( mb.dataProvider );

		Assert.assertNotNull( collection );

		for ( var cursor: IViewCursor = collection.createCursor();
			  cursor.afterLast == false;
			  cursor.moveNext() ) {

			Assert.assertEquals( "XML", getQualifiedClassName( cursor.current ) );
		}

        Assert.assertEquals( 5, collection.length );
	}


	[Test(timeout="1000")]
	public function shouldMakeCollectionOfObjectsFromArrayColnDp():void
	{
        var mb: MenuBar = sandbox.mbWithArrayColnDp.getChildAt(0) as MenuBar;
		var collection: ICollectionView =
				MenuHelpers.makeCollectionFromDataProvider( mb.dataProvider );

		Assert.assertNotNull( collection );

		for ( var cursor: IViewCursor = collection.createCursor();
			  cursor.afterLast == false;
			  cursor.moveNext() ) {

			Assert.assertEquals( "Object", getQualifiedClassName( cursor.current ) );
		}

        Assert.assertEquals( 3, collection.length );
	}


	[Test(timeout="1000")]
	public function shouldMakeCollectionOfObjectsFromArrayDp():void
	{
        var mb: MenuBar = sandbox.mbWithArrayDp.getChildAt(0) as MenuBar;
		var collection: ICollectionView =
				MenuHelpers.makeCollectionFromDataProvider( mb.dataProvider );

		Assert.assertNotNull( collection );

		for ( var cursor: IViewCursor = collection.createCursor();
			  cursor.afterLast == false;
			  cursor.moveNext() ) {

			Assert.assertEquals( "Object", getQualifiedClassName( cursor.current ) );
		}

        Assert.assertEquals( 3, collection.length );
	}


	[Test(timeout="1000")]
	public function shouldMakeCollectionOfObjectsFromObjectDp():void
	{
        var mb: MenuBar = sandbox.mbWithObjectDp.getChildAt(0) as MenuBar;
		var collection: ICollectionView =
				MenuHelpers.makeCollectionFromDataProvider( mb.dataProvider );

		Assert.assertNotNull( collection );

		for ( var cursor: IViewCursor = collection.createCursor();
			  cursor.afterLast == false;
			  cursor.moveNext() ) {

			Assert.assertEquals( "Object", getQualifiedClassName( cursor.current ) );
		}

        Assert.assertEquals( 1, collection.length );
	}

}
}
