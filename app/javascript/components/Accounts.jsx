import React, { Component, useState } from 'react';

import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input, TextInput, List
} from '@nypl/design-system-react-components';



export default class Accounts extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <>
      <AppBreadcrumbs />
		    <main className="main">
		      <div className="content-primary">
      			Accounts page
      		</div>
      	</main>
      </>
    )
  }
}