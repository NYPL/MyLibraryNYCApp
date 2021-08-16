import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";

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


export default class SearchTeacherSets extends Component {

  constructor(props) {
    super(props);
  }
  
  render() {
    return (
      <>
        <AppBreadcrumbs />
        <main className="main">
          <div className="content-primary">
            <div className="search_teacher_sets">
              Teacher sets page
            </div>
          </div>
        </main>
      </>
    )
  }
}
