Ensures form submissions are coming in from the same application (same origin) that loaded the form, thus providing protection from [cross site request forgeries](http://en.wikipedia.org/wiki/Cross-site_request_forgery).

A successor to [cfsameorigin](https://github.com/michaelsharman/cfsameorigin), as this CFC doesn't store any actual values in session (however it does require session management to be enabled). This means you're not reliant on sticky sessions, and you're safe from server/application restarts.

Loosely based off the CsrfProvider as part of the [Symfony package](https://github.com/symfony/symfony/blob/master/src/Symfony/Component/Form/Extension/Csrf/CsrfProvider/DefaultCsrfProvider.php)

##Usage (request headers):
```
// This can be instantiated as a singleton or at runtime
csrf = new CSRFProvider();

// Use ColdFusion to write/send the token to the browser based, off a unique `intention` (best to be unique per form)
var _token = csrf.generateToken(intention="my_unique_form_name");

// Use JavaScript to write the token to a custom header during form submission, eg:
xhr.setRequestHeader('X-CSRF-Token', '#_token#');

// On form submission, verify the token from CGI scope
validSubmission = csrf.verifyToken(intention="my_unique_form_name", token=CGI["X-CSRF-Token"]);
```

##Alternate Usage (hidden form fields):
```
// Writes a hidden form field to your view, you must pass an `intention` which should be unique per form, per application
#csrf.renderToken(intention="my_unique_form_name")#

// On form submission, the application must verify the token using the same `intention`
validSubmission = csrf.verifyToken(intention="my_unique_form_name", token=form._token);
```

A sample hidden field looks like:

```
<input type="hidden" name="_token" value="EF757303CC54FF71A4D3D0C47F039124AF08F2D2">
```

```
Options:
// Override the hidden field name (which is `_token` by default)
#csrf.renderToken(intention="my_unique_form_name", inputName="anotherName")#

// Add a custom css class to the hidden field
#csrf.renderToken(intention="my_unique_form_name", className="myCssClass")#
```

###Note:
The CSRFProvider.cfml.cfc in this repo was a modification of CSRFProvider.cfc to be loaded into a ColdFusion 7 application. In this version the session requirement in the constructor has been removed (however session management is still required). It is NOT recommended to use this version.

