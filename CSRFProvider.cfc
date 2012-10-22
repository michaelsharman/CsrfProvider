/**
 * CSRF (Cross Site Request Forgery) Protection Provider
 * @author Michael Sharman (michael[at]chapter31.com)
 * http://learnosity.com/
 *
 * v0.1 - 22 October 2012
 *
 * Ensures form submissions are coming in from the same application (same origin) that loaded the form,
 * thus providing protection from cross site request forgeries.
 * You must have session management enabled, as well as an application name in Application.cfc
 * As nothing is actually stored in session, this works well across a cluster (with or without sticky sessions) as well as server/application restarts
 *
 * Usage:
 * 	// This can be instantiated as a singleton or used at runtime
 * 	csrf = new CSRFProvider();
 *
 * 	// Writes a hidden form field to your view, you must pass an `intention` which should be unique per form, per application
 *	#csrf.renderToken(intention="my_unique_form_name")#
 *
 * 	// On form submission, the application must verify the token using the same `intention`
 * 	validSubmission = csrf.verifyToken(intention="my_unique_form_name", form._token);
 *
 * Options:
 * 	// Override the hidden field name (which is `_token` by default)
 * 	#csrf.renderToken(intention="my_unique_form_name", inputName="anotherName")#
 *
 * 	// Add a custom css class to the hidden field
 * 	#csrf.renderToken(intention="my_unique_form_name", className="myCssClass")#
 */
component output="false"
{

	public function init()
	{
		if (!isDefined("application.applicationName") || !len(application.applicationName))
		{
			throw(type="csrf.error", message="No application name found");
		}
		if (!isDefined("session") || !structKeyExists(session, "sessionId"))
		{
			throw(type="csrf.error", message="No session found");
		}
		variables.instance.hashAlgorithm = "SHA-1";
		variables.instance.secret = hash(application.applicationName, variables.instance.hashAlgorithm);
		return this;
	}

	/**
	* @hint Generates a secure token to use in a form as a hidden field to make sure the form submission came from the correct source
	* @param {String} intention A unique name (per application/website) for the form. Will be used as part of the token hash.
	*/
	private string function generateToken(required String intention)
	{
		return hash(variables.instance.secret & arguments.intention & getSessionId(), variables.instance.hashAlgorithm);
	}

	/**
	* @hint Returns a specific users session Id. Will be used as part of the token hash.
	*/
	private string function getSessionId()
	{
		return session.sessionId;
	}

	/**
	* @hint Renders a hidden form field with a secure token
	* @param {String} intention A unique name (per application/website) for the form. Will be used as part of the token hash.
	* @param {String} inputName The name of the hidden form field (defaults to `_token`)
	* @param {String} className A space delimited list of css classnames to add to the form field
	*/
	public string function renderToken(required String intention, String inputName = "_token", String className)
	{
		var _css = "";
		var _name = "#trim(arguments.inputName)#";
		var _token = "#generateToken(jsStringFormat(trim(arguments.intention)))#";

		if (structKeyExists(arguments, "className") && len(trim(arguments.className)))
		{
			_css = ' class="#trim(arguments.className)#"';
		}

		return '<input type="hidden" name="#_name#" value="#_token#"#_css#>';
	}

	/**
	* @hint Verifies that a secure token has been generated by the application that loaded the form (same origin)
	* @param {String} intention A unique name (per application/website) for the form. Will be appended to the token
	* @param {String} token The token that came through in the form submission
	*/
	public boolean function verifyToken(required String intention, required String token)
	{
		return arguments.token == generateToken(jsStringFormat(trim(arguments.intention)));
	}

}