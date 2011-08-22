/*
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * @author Jeff Lasslett
 */
package melomel.core
{
import melomel.errors.MelomelError;

import mx.containers.TabNavigator;

import mx.controls.menuClasses.MenuBarItem;
import mx.controls.MenuBar;

import mx.collections.IViewCursor;
import mx.collections.ICollectionView;
import mx.collections.CursorBookmark;
import mx.collections.XMLListCollection;
import mx.collections.ArrayCollection;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 *	This class provides 'helper' methods that assist in querying MenuBars and
 *  Menus.
 */
public class MenuHelpers
{
	//--------------------------------------------------------------------------
	//
	//	Static Properties
	//
	//--------------------------------------------------------------------------


	//--------------------------------------------------------------------------
	//
	//	Static methods
	//
	//--------------------------------------------------------------------------

	/**
	 * From the Flex language reference entry for MenuBar dataProvider:-
	 *
	 * The hierarchy of objects that are displayed as MenuBar items and menus.
	 * The top-level children all become MenuBar items, and their children
	 * become the items in the menus and submenus. The MenuBar control handles
	 * the source data object as follows:
	 * 
	 *   - A String containing valid XML text is converted to an XML object.
	 *   - An XMLNode is converted to an XML object.
	 *   - An XMLList is converted to an XMLListCollection.
	 *   - Any object that implements the ICollectionView interface is cast to
	 *	 an ICollectionView.
	 *   - An Array is converted to an ArrayCollection.
	 *   - Any other type object is wrapped in an Array with the object as its
	 *	 sole entry.
	 * 
	 */
	static public function makeCollectionFromDataProvider( dp: * ): ICollectionView
	{
		if ( dp is ICollectionView ) return dp as ICollectionView;

		if ( dp is String ) {
			var xml: XML = new XML( dp )
			return ( new XMLListCollection( xml.children ) as ICollectionView );
		}

		if ( dp is XML ) {
			return ( new XMLListCollection( dp.children ) as ICollectionView );
		}

		if ( dp is XMLList ) {
			return ( new XMLListCollection( dp ) as ICollectionView );
		}

		if ( dp is Array ) {
			return ( new ArrayCollection( dp ) as ICollectionView );
		}

		return ( new ArrayCollection( [ dp ] ) as ICollectionView );
	}

	/**
	 *  Get the label string from a MenuBarItem's data.
	 *
	 *  @param menuBar
	 *  The MenuBar containing the item.
	 *
	 *  @param itemData
	 *  The itemData used to create the label for a particular menu item.
	 *  
	 *  @return
	 *  A string representing a menu bar item label, or null if the string 
	 *  could not be found.
	 */
	static public function  getMenuBarItemLabel( menuBar: MenuBar, itemData: * ): String
	{
		if ( menuBar.labelFunction != null ) {
			return menuBar.labelFunction( itemData );
			if ( label == itemLabel ) return menuBarItem;
		}
		else if ( menuBar.labelField.length ) {
			return getLabelFieldValue( itemData, menuBar.labelField );
		}

		return null;
	}

	/**
	 *	Get the value of the 'label field' from a data provider object,
	 *  regardless of the object's type.
	 *
	 *	@param itemData
	 *	An object, or XML, that is used as the source of a label for a 
	 *	menu item.  
	 *
	 *	@param labelField
	 *	A string representing a property name or E4X expression that 
	 *	identifies where, within itemData, a menu label is stored.
	 *
	 *	@return
	 *	The desired label field value.
	 */
	static public function getLabelFieldValue( itemData: *, labelField: String ): *
	{
		var typeName: String = getQualifiedClassName( itemData );
		var labelValue: * = null;

		trace( "getLabelFieldValue: itemData type is " + typeName );

		switch( getQualifiedClassName( typeName ) ) {

		case "XML":
			labelValue = getLabelFieldValueFromXML( itemData as XML, labelField );
			break;
			
		case "Object":
		default:
			labelValue = getLabelFieldValueFromObject( itemData as Object, labelField );
			break;
		}

		return labelValue;
	}

	static public function getLabelFieldValueFromXML( xml: XML, labelField: String ): *
	{
		trace( "getLabelFieldValueFromXML: xml == " + xml.toString() + " labelField == " + labelField );
		if ( labelField.charAt(0) == "@" ) return xml.attribute( labelField.slice(1) )[0].toString();
		else return xml.child( labelField ).text();
		return null;
	}

	static public function getLabelFieldValueFromObject( obj: Object, labelField: String ): *
	{
		if ( obj == null ) return null;

		if ( obj.hasOwnProperty( labelField ) ) return obj[ labelField ];

		return null;
	}

}
}
