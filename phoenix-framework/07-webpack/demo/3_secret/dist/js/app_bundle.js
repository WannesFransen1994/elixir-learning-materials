/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/*!*******************!*\
  !*** ./js/app.js ***!
  \*******************/
/*! no exports provided */
/*! all exports used */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("Object.defineProperty(__webpack_exports__, \"__esModule\", { value: true });\n/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__selector_js__ = __webpack_require__(/*! ./selector.js */ 1);\n\r\n\r\nvar showSecret = false;\r\n\r\n__WEBPACK_IMPORTED_MODULE_0__selector_js__[\"a\" /* btn */].addEventListener('click', toggleSecretState);\r\nupdateSecretParagraph();\r\n\r\nfunction toggleSecretState() {\r\n    showSecret = !showSecret;\r\n    updateSecretParagraph();\r\n    updateSecretButton()\r\n}\r\n\r\nfunction updateSecretButton() {\r\n    if (showSecret) {\r\n        __WEBPACK_IMPORTED_MODULE_0__selector_js__[\"a\" /* btn */].textContent = 'Hide the Secret';\r\n    } else {\r\n        __WEBPACK_IMPORTED_MODULE_0__selector_js__[\"a\" /* btn */].textContent = 'Show the Secret';\r\n    }\r\n}\r\n\r\nfunction updateSecretParagraph() {\r\n    if (showSecret) {\r\n        __WEBPACK_IMPORTED_MODULE_0__selector_js__[\"b\" /* para */].style.display = 'block';\r\n    } else {\r\n        __WEBPACK_IMPORTED_MODULE_0__selector_js__[\"b\" /* para */].style.display = 'none';\r\n    }\r\n}//# sourceURL=[module]\n//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiMC5qcyIsInNvdXJjZXMiOlsid2VicGFjazovLy8uL2pzL2FwcC5qcz9jOTllIl0sInNvdXJjZXNDb250ZW50IjpbImltcG9ydCB7YnRuLCBwYXJhfSBmcm9tICcuL3NlbGVjdG9yLmpzJ1xyXG5cclxudmFyIHNob3dTZWNyZXQgPSBmYWxzZTtcclxuXHJcbmJ0bi5hZGRFdmVudExpc3RlbmVyKCdjbGljaycsIHRvZ2dsZVNlY3JldFN0YXRlKTtcclxudXBkYXRlU2VjcmV0UGFyYWdyYXBoKCk7XHJcblxyXG5mdW5jdGlvbiB0b2dnbGVTZWNyZXRTdGF0ZSgpIHtcclxuICAgIHNob3dTZWNyZXQgPSAhc2hvd1NlY3JldDtcclxuICAgIHVwZGF0ZVNlY3JldFBhcmFncmFwaCgpO1xyXG4gICAgdXBkYXRlU2VjcmV0QnV0dG9uKClcclxufVxyXG5cclxuZnVuY3Rpb24gdXBkYXRlU2VjcmV0QnV0dG9uKCkge1xyXG4gICAgaWYgKHNob3dTZWNyZXQpIHtcclxuICAgICAgICBidG4udGV4dENvbnRlbnQgPSAnSGlkZSB0aGUgU2VjcmV0JztcclxuICAgIH0gZWxzZSB7XHJcbiAgICAgICAgYnRuLnRleHRDb250ZW50ID0gJ1Nob3cgdGhlIFNlY3JldCc7XHJcbiAgICB9XHJcbn1cclxuXHJcbmZ1bmN0aW9uIHVwZGF0ZVNlY3JldFBhcmFncmFwaCgpIHtcclxuICAgIGlmIChzaG93U2VjcmV0KSB7XHJcbiAgICAgICAgcGFyYS5zdHlsZS5kaXNwbGF5ID0gJ2Jsb2NrJztcclxuICAgIH0gZWxzZSB7XHJcbiAgICAgICAgcGFyYS5zdHlsZS5kaXNwbGF5ID0gJ25vbmUnO1xyXG4gICAgfVxyXG59XG5cblxuLy8vLy8vLy8vLy8vLy8vLy8vXG4vLyBXRUJQQUNLIEZPT1RFUlxuLy8gLi9qcy9hcHAuanNcbi8vIG1vZHVsZSBpZCA9IDBcbi8vIG1vZHVsZSBjaHVua3MgPSAwIl0sIm1hcHBpbmdzIjoiQUFBQTtBQUFBO0FBQUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EiLCJzb3VyY2VSb290IjoiIn0=\n//# sourceURL=webpack-internal:///0\n");

/***/ }),
/* 1 */
/*!************************!*\
  !*** ./js/selector.js ***!
  \************************/
/*! exports provided: btn, para */
/*! exports used: btn, para */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, \"a\", function() { return btn; });\n/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, \"b\", function() { return para; });\nvar btn = document.querySelector('#button');\r\nvar para = document.querySelector('#paragraph');//# sourceURL=[module]\n//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiMS5qcyIsInNvdXJjZXMiOlsid2VicGFjazovLy8uL2pzL3NlbGVjdG9yLmpzPzQ0YjciXSwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0IHZhciBidG4gPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCcjYnV0dG9uJyk7XHJcbmV4cG9ydCB2YXIgcGFyYSA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJyNwYXJhZ3JhcGgnKTtcblxuXG4vLy8vLy8vLy8vLy8vLy8vLy9cbi8vIFdFQlBBQ0sgRk9PVEVSXG4vLyAuL2pzL3NlbGVjdG9yLmpzXG4vLyBtb2R1bGUgaWQgPSAxXG4vLyBtb2R1bGUgY2h1bmtzID0gMCJdLCJtYXBwaW5ncyI6IkFBQUE7QUFBQTtBQUFBO0FBQ0EiLCJzb3VyY2VSb290IjoiIn0=\n//# sourceURL=webpack-internal:///1\n");

/***/ })
/******/ ]);