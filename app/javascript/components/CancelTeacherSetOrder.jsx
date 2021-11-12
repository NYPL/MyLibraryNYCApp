import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, ButtonTypes,
  SearchBar, Select, Input, SearchButton, Heading, Image, List, Link, LinkTypes, TextInput, Label
} from '@nypl/design-system-react-components';



export default class TeacherSetOrder extends React.Component {

  constructor(props) {
    super(props);
    this.state = { access_key: this.props.match.params.id, hold: "",  teacher_set: "", comment: ""};
  }


  componentDidMount() {
    console.log(this.props.match.params)

    axios({method: 'get', url: '/holds/'+ this.props.match.params.id + '/cancel_details'}).then(res => {
      this.setState({ teacher_set: res.data.teacher_set, hold: res.data.hold });
    })
    .catch(function (error) {
      console.log(error); 
    })
  }


  handleCancelComment = event => {
    this.setState({
      comment: event.target.value
    })
    console.log(event.target.value + "pppppppp")
  }


  handleSubmit = event => {
    console.log("cancel order")
    event.preventDefault();
    axios.put('/holds/'+ this.state.access_key, { hold_change: { status: 'cancelled', comment: this.state.comment } 
     }).then(res => {
        if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/users/start") {
          window.location = res.request.responseURL;
          return false;
        } else {
          this.props.history.push("/ordered_holds/"+ this.state.access_key)
        }
      })
      .catch(function (error) {
        console.log("cancel order fail")
        console.log(error)
    })
  }


  render() {  
    return (
      <>
        <AppBreadcrumbs />
        <div className="layout-container nypl-ds">
          <main className="main main--with-sidebar nypl-ds">
            <div className="content-primary content-primary--with-sidebar-right main-content">
              <div className="cancel-header" >Please Confirm, Are you sure you want to cancle this order for </div>{<br/>}
              <Label htmlFor="inputID-attrs" id={"label"} className="cancel-button-label">
                Reason For cancelling (optional)
              </Label>
              <TextInput id="cancel-order-button" value={this.state.comment} showLabel showOptReqLabel type="text" onChange={this.handleCancelComment}/>
              <Button className="button-color cancel-button" buttonType="primary" onClick={this.handleSubmit}> Cancel My Order </Button>
            </div>

            <div className="content-secondary content-secondary--with-sidebar-right"></div>
          </main>
        </div>
      </>
  )}
  
}