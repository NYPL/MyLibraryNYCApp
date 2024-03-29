import PropTypes from 'prop-types';
import React, { useState } from 'react';

import "../../../styles/application.scss"

import {
  Button,
  Modal,
  Card,
} from '@nypl/design-system-react-components';


const HelloWorld = (props) => {
  const [name, setName] = useState(props.name);

  return (
    <div className="maintenance-banner-color">
      <h3>Hello, {name}!</h3>
      <hr />
       <Button
            buttonType="primary"
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
