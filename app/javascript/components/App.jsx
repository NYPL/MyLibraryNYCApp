import React, { Component, useState, useEffect } from 'react';
import axios from 'axios';
import Routes from "../routes/routes";
import "../styles/application.scss"

import { DSProvider } from '@nypl/design-system-react-components';

export default class App extends React.Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <Routes userSignedIn={this.props.userSignedIn}/>
    )
  } 
}