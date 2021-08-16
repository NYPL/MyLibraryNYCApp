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
              ariaLabelledBy="buttonBasic"
              attributes={{
                'aria-describedby': 'helperTextBasic'
              }}
              id="inputBasic"
              placeholder="Item Search"
              required
              type="text"
            />
            <Button
              buttonType="filled"
              id="buttonBasic"
              type="submit"
            >
              <Icon
                decorative
                modifiers={[
                  'small',
                  'icon-left'
                ]}
                name="search"
              />
              Search
            </Button>
          </SearchBar>
        </div>
      </>
    )
  }
}
