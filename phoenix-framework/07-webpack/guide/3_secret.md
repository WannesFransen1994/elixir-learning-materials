# Secret

## Installation

Make sure you have finished the installation of [hello_Webpack](1_hello_webpack.md).

## Front-end code

Create a new folder for our secret demo. Within this folder create a js folder to store our javascript files. Within this js folder create 2 new javascript files. A selector file which uses ordinary queryselectors to select the correct html element.

selector.js

```js
var btn = document.querySelector('#button');
var para = document.querySelector('#paragraph');
```

And an app file which is responsible for the application logic. This javascript should hide or show a secret message when the button is clicked.

app.js

```js
  
var showSecret = false;

btn.addEventListener('click', toggleSecretState);
updateSecretParagraph();

function toggleSecretState() {
    showSecret = !showSecret;
    updateSecretParagraph();
    updateSecretButton()
}

function updateSecretButton() {
    if (showSecret) {
        btn.textContent = 'Hide the Secret';
    } else {
        btn.textContent = 'Show the Secret';
    }
}

function updateSecretParagraph() {
    if (showSecret) {
        para.style.display = 'block';
    } else {
        para.style.display = 'none';
    }
}
```

As you probably have noticed is that the app.js file depends on the selector.js file. The app.js file reference to two parameters called 'btn' and another parameter called 'para' who are defined in the selector.js file. This means that our app.js file can only run when it is placed **after** importing the selector.js file. This is what we will do in the index.html file.

index.html

```html
<!doctype html>
  <body>
    <button id="button">Show the Secret</button>
    <p id="paragraph">The answer to life the universe and everything = 42.</p>
    <script src="js/selector.js"></script>
    <script src="js/app.js"></script>
  </body>
</html>
```

To verify that everything is working correctly at this point, go to your folder and double click the index.html file so it will be displayed in the browser. Click on the button to make the secret message appear and disappear.

To prove that the order of importing the scripts is important, try to swap them and check if the button is still working correctly. Check the console to see any error messages.

As you might have guessed, it won't work as the import order is important. For this small and easy demo this is not a problem, but for big projects this can cause severe problems. This is a reason to use webpack as webpack can bundle the dependend files so the import order isn't important anymore.

To make use of webpack we have to change our index.html file to use the app_bundle.js file that webpack will create for us.

index.html

```html
<!doctype html>
  <body>
    <button id="button">Show the Secret</button>
    <p id="paragraph">The answer to life the universe and everything = 42</p>
    <script src="dist/js/app_bundle.js"></script>
  </body>
</html>
```

Besides changing the index.html we have to change both the js files. This to let webpack know what dependecies to use. In the selector.js file export the used variables.

selector.js

```js
export var btn = document.querySelector('#button');
export var para = document.querySelector('#paragraph');
```

In the app.js specify the imports at the top of the file.

app.js

```js
import {btn, para} from './selector.js'
```

## Webpack config

For the final part we have to configure our webpack. Thus create a new file named 'webpack.config.js'. Within this file write the following code.

```js
module.exports = {
  entry: {
  app_bundle: './js/app.js',
  },
  output: {
    filename: './dist/js/[name].js'
  }
};
```

For ease we create a package.json file that can be used to run webpack from a single command.

```json
{
  "name": "webpack-demo3",
  "version": "1.0.0",
  "devDependencies": {
    "webpack": "^3.10.0",
    "webpack-dev-server": "^2.11.1"
  },
  "scripts": {
    "dev": "webpack -d && webpack-dev-server --open",
    "build": "webpack -p"
  },
  "license": "MIT"
}
```

## Run

<!-- markdown-link-check-disable -->

To let webpack run use the following command. If the browser does not open automatically, go to [this page](http://localhost:8080/) to visit your page.

```bash
npm install # Install the devDependencies defined in package.json
npm run dev # Run the script commands defined in package.json
```

<!-- markdown-link-check-enable -->
