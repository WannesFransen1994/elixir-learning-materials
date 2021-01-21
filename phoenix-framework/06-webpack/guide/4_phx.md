# Phoenix

## Installation

Make sure you have finished the installation of [hello_Webpack](1_hello_webpack.md).

## Create phoenix project

```bash
mix phx.new a_webpack_demo --umbrella --database mysql
```

## Front-end code

Copy the selector.js and app.js javascript files from the [3_secret](3_secret.md) demo. We will reuse those files in this demo to get webpack working with the phoenix framework. Navigate to 'apps/a_webpack_demo_web/assets/js' and paste both the selector.js and the app.js files in here, do **NOT** overwrite the 'app.js' file but rename your file to 'secret.js'.

Next navigate to the template folder and open the 'index.html.eex' file. This is our html code we have to change to show a button and a paragraph section. Add the code below between the .phx-hero and the .row sections.

```html
  <button id="button">Show the Secret</button>
  <p id="paragraph">The answer to life the universe and everything = 42</p>
```

Next ze open the webpack.config.js file again in 'apps/a_webpack_demo_web/assets/js'. Here we can see full configuration. If you want you can alter the webpack configuration in this file. You will do so later on in this guide. For now it is important to see the entry point webpack will use to build its internal dependency graph, open this entry point file and add the following line at the bottom of this file. This imports our secret.js file so now the app.js file depends on secret.js so this will be included in our dependencie graph and eventually included in our output bundle.

```js
import './secret.js'
```

## Run

As phoenix already configured the webpack config file, we dont have to do this ourselves. We can just build webpack and run our server with the following commands.

Build webpack in the apps/a_webpack_demo_web/assets folder.

```bash
webpack -d # Build webpack in the apps/a_webpack_demo_web/assets folder.
mix phx.server
```

## Multiple bundles

Until now webpack has build everything in a single bundle. Your task now is to reconfigure the nessecary .js and .html.eex files to build and include two seperate bundles. The one original bundle including the app.css and app.js (prebuild by phoenix) and another bundle which is responsible for the secret button.
