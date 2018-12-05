import * as ReactDOM from 'react-dom';
import Main from './main.bs';
import view from './view/index';

console.warn("Main", Main);

const render = (container, m) => {
  const reactElem = view(m);
  ReactDOM.render(reactElem, container);
};

export const blocks = {
  root: Main.demo1
};

export const startAll = () => {
  console.log('Running interactive blocks', blocks);
  Object.keys(blocks).map(k => {
    const container = document.getElementById(k);
    if (container) {
      console.log('Running block ' + k)
      blocks[k](m => render(container, m));
    }
  });
};

startAll();
