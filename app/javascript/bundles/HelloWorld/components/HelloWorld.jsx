import PropTypes from 'prop-types';
import React, { useState } from 'react';

import "../../../styles/application.scss"

import {
  Button,
  ButtonTypes,
  Modal,
  Card,
} from '@nypl/design-system-react-components';


const HelloWorld = (props) => {
  const [name, setName] = useState(props.name);

  return (
    <div>
      <h3>Hello, {name}!</h3>
      <hr />
       <Button
            buttonType={ButtonTypes.Secondary}
            className="button"
          >
            Log off
          </Button>

      <form>
        <label htmlFor="name">
          Say hello to:
          <input id="name" type="text" value={name} onChange={(e) => setName(e.target.value)} />
        </label>
      </form>
    </div>
  );
};

HelloWorld.propTypes = {
  name: PropTypes.string.isRequired, // this is passed from the Rails view
};

export default HelloWorld;
