import PropTypes from 'prop-types';
import React, { useState } from 'react';

import "../../../styles/application.scss"

import {
  Button,
  ButtonTypes,
  Modal,
  Card,
} from '@nypl/design-system-react-components';


const SearchTeacherSets = (props) => {
  const [name, setName] = useState(props.name);
  console.log("asdasas")
  return (
    <div className="maintenance-banner-color">
      <h3>Hello, {name}!</h3>
      <hr />
       <Button
            buttonType={ButtonTypes.Primary}
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

SearchTeacherSets.propTypes = {
  name: PropTypes.string.isRequired, // this is passed from the Rails view
};

export default SearchTeacherSets;
