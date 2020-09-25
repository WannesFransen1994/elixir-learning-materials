# Hello webpack

## Installation

First, install [Webpack](https://www.npmjs.com/package/webpack) and [webpack-dev-server](https://www.npmjs.com/package/webpack-dev-server) globally.

```bash
npm i -g webpack webpack-dev-server
npm i -D -g webpack-cli
```

## Front-end code

After installing webpack and webpack-dev-server we will create a new folder for our hello webpack demo. Within this folder create a new file named 'myjsfile.js'. with the following javascript code. This will be all our javascript code for this hello world demo.

```js
document.write('<h1>Hello Webpack</h1>');
```

Besides javascript we need to serve some html content to the client. Next create a new file named 'index.html'.
This file should contain the code below.

```html
<html>
  <body>
    <script type="text/javascript" src="bundle.js"></script>
  </body>
</html>
```

Notice the src of the script tag, this is pointing to bundle.js, not to our myjsfile.js!

## Webpack config

For the final part we have to configure our webpack. Thus create a new file named 'webpack.config.js'. Within this file write the following code. 

```js
module.exports = {
  entry: './myjsfile.js',
  output: {
    filename: 'bundle.js'
  }
};
```

In the code the entry point is our myjsfile.js because this is the file we want to include. As output we want a file named bundle.js. This is the same file we referred to in our .html file. Because this hello webpack demo only contains javascript code we do not need any other loaders.

For ease we create a package.json file that can be used to run webpack from a single command.

```json
{
  "name": "hello_webpack",
  "version": "1.0.0",
  "main": "myjsfile.js",
  "scripts": {
    "dev": "webpack -d && webpack-dev-server --open",
    "build": "webpack -p"
  },
  "license": "MIT",
  "devDependencies": {
    "webpack-cli": "^3.3.11"
  }
}
```

## Run

<!-- markdown-link-check-disable -->

To let webpack run use the following command, this triggers the package.json script. If the browser does not open automatically, go to [this page](http://localhost:8080/) to visit your page.

```bash
npm run dev
```

<!-- markdown-link-check-enable -->

If you open the folder you'll see that webpack created a new file named bundle.js. You can open this file and see a lot of non-human-understandable javascript which loaded by the client.
