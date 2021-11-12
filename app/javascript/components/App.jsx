import React, { Component, useState } from 'react';
import Routes from "../routes/routes";
import "../styles/application.scss"


export default class App extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
    	<Routes userSignedIn={this.props.userSignedIn}/>
    )
  }
}