window.onload = function() {
  var dataset = document.querySelector('body').dataset;

  if (dataset.width && dataset.height) {
    window.parent.postMessage({
      message: 'popup-resize',
      width: dataset.width,
      height: dataset.height
    }, 'chrome-extension://immoginlcccndojojknbkfkfdbjmecge');
  }
}