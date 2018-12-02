import * as React from 'react';
import * as ReactDOM from 'react-dom';
import Main from './Main.bs';
const view = require('./view/index');

const render = (container, m) => {
  const reactElem = view(m);
  ReactDOM.render(reactElem, container);
};

export const blocks = {
  demo1: Main.demo1,
};

export const startAll = () => {
  console.log('Running interactive blocks', blocks);
  Object.keys(blocks).map(k => {
    const container = document.getElementById('block-' + k);
    if (container) {
      console.log('Running block ' + k)
      blocks[k](m => render(container, m));
    }
  });
};
