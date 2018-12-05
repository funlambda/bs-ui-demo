const React = require('react');
const dynamic = require('uilibrary-view/src/dynamic/index');

console.warn({dynamic: dynamic});

const getTag = model => {
  if (model && model.__tag) return model.__tag;
  return "";
};

// const debugView = require('uilibrary-view/src/debugView')(getTag);

const viewSet = {
  Button: (m, view) =>
    <button>BUTTON</button>,
  PersonEditor: (m, view) =>
    <div>
      <div>Name: {view(m.name)}</div>
      <div>Age: {view(m.age)}</div>
      <div>Animal: {view(m.animal)}</div>
    </div>,
  Textbox: (m, view) => 
    <input type="text" value={m.value} onChange={ce => m.onChange(ce.target.value)} 
           onMouseEnter={m.onMouseEnter} onMouseLeave={m.onMouseLeave} />,
  ShowValue: (m, view) =>
    <div>
      {view(m.inner)}
      {/* {debugView(m.value)} */}
      {(() => console.log('YO', m.value))()}
    </div>,
  WithValueViewer: (m, view) =>
    <div>
      {view(m.inner)}
      {view(m.value)}
    </div>,
  Validated: (m, view) =>
    <div>
      {view(m.state)}
      {m.value === 0 ? "None" : view(m.value)}
    </div>,
  PersonView: (m, view) =>
    <div style={{padding: 4}}>
      Name: {view(m.name)}<br />
      Age: {view(m.age)}<br />
      Animal: {view(m.animal)}<br />
    </div>
};

export default dynamic.mkView({ viewSet, getTag });
