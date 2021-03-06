/*
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * @author Ben Johnson
 */
package melomel.commands
{
import melomel.core.Type;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import melomel.errors.MelomelError;

/**
 *	This class represents an action of returning a property from an object.
 *	
 *	@see melomel.commands.parsers.GetPropertyCommandParser
 */
public class GetPropertyCommand implements ICommand
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 *	
	 *	@param object     The object to retrieve from.
	 *	@param property   The name of the property to retrieve.
	 *	@param throwable  A flag stating if missing property errors are thrown.
	 */
	public function GetPropertyCommand(object:Object=null,
									   property:String=null,
									   throwable:Boolean=true)
	{
		this.object    = object;
		this.property  = property;
		this.throwable = throwable;
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The object to retrieve the property from.
	 */
	public var object:Object;

	/**
	 *	The name of the property to retrieve.
	 */
	public var property:String;

	/**
	 *	A flag stating if the command will throw an error for missing
	 *	properties.
	 */
	public var throwable:Boolean;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Retrieves the value of the property on a given object.
	 *	
	 *	@return  The value of the property on the object.
	 */
	public function execute():Object
	{
		// Verify object exists
		if(object == null) {
			throw new MelomelError("Cannot retrieve property from a null object");
		}
		// Verify property exists
		if(property == null || property == "") {
			throw new MelomelError("Property name cannot be null or blank.");
		}


		// If this is an array accessor, treat it like an array.
		if(property.search(/^\[\d+\]$/) != -1) {
			if(!(object is Array)) {
				throw new MelomelError("Cannot use an array accessor on a non-Array object.");
			}
			var index:int = parseInt(property.slice(1, property.length-1));
			return object[index];
		}
		// Try to access as property.
		else if(Type.hasProperty(object, property, Type.READ)) {
			return object[property];
		}
		// Otherwise try a zero-arg method.
		else if(Type.hasMethod(object, property) &&
		        Type.getMethodParameterCount(object, property) == 0)
		{
			return object[property]();
		}
		// Finally, if nothing works then act like we're trying to access a
		// property so we throw the appropriate error.
		else {
			// If this method throws errors, attempt the accessor.
			if(throwable) {
				// Flash doesn't throw an error on missing properties of a
				// Class because classes are dynamic. Throw our own.
				if(object is Class) {
					throw new ReferenceError("No such static property on " + object + ": " + property);
				}
				else {
					return object[property];
				}
			}
			// Otherwise just silently return null.
			else {
				return null;
			}
		}
	}
}
}