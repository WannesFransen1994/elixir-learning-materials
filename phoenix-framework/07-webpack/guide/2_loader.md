# Loader

## Installation
Make sure you have finished the installation of [hello_Webpack](1_hello_Webpack.md).



## Front-end code
Webpack allows you to include CSS in JS file, then preprocessed CSS file with CSS-loader.


Create a new folder for our loader demo. Within this folder create a new file named 'main.js'. with the following javascript code. This will be all our javascript code for this loader demo.

```js
require('./app.css');
```

As the javascripts requires a app.css file we have to make one. Create a new file named app.css and include the following code in this file.
```css
body {
  background-color: blue;
}
```

Besides javascript we need to serve some html content to the client. Next create a new file named 'index.html'.
This file should contain the code below.

```html
<html>
  <head>
    <script type="text/javascript" src="bundle.js"></script>
  </head>
  <body>
    <h1>Hello blue Webpack</h1>
  </body>
</html>
```

## Webpack config
For the final part we have to configure our webpack. Thus create a new file named 'webpack.config.js'. Within this file write the following code. 

```js
module.exports = {
  entry: './main.js',
  output: {
    filename: 'bundle.js'
  },
  module: {
    rules:[
      {
        test: /\.css$/,
        use: [ 'style-loader', 'css-loader' ]
      },
    ]
  }
};
```
In the code the entry point is our main.js because this is the file we want to include. As output we want a file named bundle.js. This is the same file we referred to in our .html file. Next we included a loader which matches against all .css files. When matches it uses both the style-loader and the css-loader.

For ease we create a package.json file that can be used to run webpack from a single command.

```json
{
  "name": "webpack-loader",
  "version": "1.0.0",
    "devDependencies": {
    "css-loader": "^0.28.9",
    "style-loader": "^0.19.1",
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
To let webpack run use the following command. If the browser does not open automatically, go to [this page](http://localhost:8080/) to visit your page. 

```bash
$ npm install #Install the devDependencies defined in package.json
$ npm run dev #run the script commands defined in package.json
```
You should see the page with a blue body. If you inspect the page you will see that webpack changed the html code so that the styling previously defined in the app.css file is now included in the html.
