import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, ButtonTypes,
  SearchBar, Select, Input,
  SearchButton, Card, CardHeading, CardLayouts,
  CardContent, CardActions,
  MDXCreateElement,
  Heading,
  Image,
  List,
  Link, LinkTypes
} from '@nypl/design-system-react-components';



export default class TeacherSetOrder extends React.Component {

  constructor(props) {
    super(props);
    this.state = { access_key: this.props.match.params.id, hold: "",  teacher_set: ""};
  }


  componentDidMount() {
      console.log(this.props.match.params)

      axios({method: 'get', url: '/holds/'+ this.props.match.params.id + '/cancel_details'}).then(res => {
        this.setState({ teacher_set: res.data.teacher_set, hold: res.data.hold });
        console.log(this.state.hold + "kkkkk")
      })
      .catch(function (error) {
        console.log(error); 
      })
    }

  render() {  
    return (
      <>
        <AppBreadcrumbs />
        <div className="layout-container nypl-ds">
          <main className="main main--with-sidebar nypl-ds">
            <div className="content-primary content-primary--with-sidebar-right">
              asdasdasd
            </div>
          </main>
        </div>
      </>
  )}
  
}