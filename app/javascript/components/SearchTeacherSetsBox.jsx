import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';

import {
  Button,
  ButtonTypes,
  SearchBar,
  Select,
  Input,
  SearchButton,
  InputTypes,
  Icon,
  IconNames,
  HelperErrorText,
  LibraryExample
} from '@nypl/design-system-react-components';


export default class SearchTeacherSetsBox extends Component {

  constructor(props) {
    super(props);
  }
  
  render() {
    return (
      <>
        <div className="search_teacher_sets">
          <SearchBar showHelperText showSelect>
            <Input
              id="input"
              placeholder="Enter teacher-set"
              required={true}
              type={InputTypes.text}
            />
            <Button
              buttonType={ButtonTypes.Primary}
              id="button"
              type="submit"
            >
              Submit
            </Button>
          </SearchBar>
        </div>
      </>
    )
  }
}

