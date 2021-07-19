import React, { Component, useState } from 'react';

import "../../../styles/application.scss"
import AppBreadcrumbs from "../../../components/AppBreadcrumbs";


import {
  Button,
  ButtonTypes,
  Modal,
  Card,
} from '@nypl/design-system-react-components';


export default class SearchTeacherSets extends Component {

  constructor(props) {
    super(props);
    this.state = { faqs: [], collapsed: true, clicked: {} };
  }

render() {
    return (
      <div>
        <AppBreadcrumbs />
        <div className="faq_list">
          this is teacher set
        </div>
      </div>
    )
  }
}