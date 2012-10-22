Ensures form submissions are coming in from the same application (same origin) that loaded the form, thus providing protection from cross site request forgeries.

A successor to [cfsameorigin](https://github.com/michaelsharman/cfsameorigin), as this doesn't store values in session. This means you're not reliant on sticky sessions, and you're safe from server/application restarts.

Loosely based off the CsrfProvider as part of the [Symfony package](https://github.com/symfony/symfony/blob/master/src/Symfony/Component/Form/Extension/Csrf/CsrfProvider/DefaultCsrfProvider.php)

##Usage:
```
// This can be instantiated as a singleton or used at runtime
csrf = new CSRFProvider();

// Writes a hidden form field to your view, you must pass an `intention` which should be unique per form, per application
#csrf.renderToken(intention="my_unique_form_name")#

// On form submission, the application must verify the token using the same `intention`
validSubmission = csrf.verifyToken(intention="my_unique_form_name", form._token);
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
The CSRFProvider.cfml.cfc was a modification of CSRFProvider.cfc to be loaded into a ColdFusion 7 application. In this version the session requirement in the constructor has been removed. It is not recommended to use this version.
