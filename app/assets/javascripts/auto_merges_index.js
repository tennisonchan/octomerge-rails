$(function() {
  var clip = new Clipboard('#ref-copy-button');
  var dataset = document.querySelector('body').dataset;

  if (dataset.width && dataset.height) {
    window.parent.postMessage({
      message: 'popup-resize',
      width: dataset.width,
      height: dataset.height
    }, CHROME_EXTENSION_URL);
  }
});