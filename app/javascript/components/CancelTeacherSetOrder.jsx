import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, ButtonTypes,
  SearchBar, Select, Input, SearchButton, Heading, Image, List, Link, LinkTypes, TextInput, Label, DSProvider,
  TemplateAppContainer
} from '@nypl/design-system-react-components';



export default class TeacherSetOrder extends React.Component {

  constructor(props) {
    super(props);
    this.state = { access_key: this.props.match.params.id, hold: "",  teacher_set: "", comment: ""};
  }


  componentDidMount() {
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
  }


  handleSubmit = event => {
    event.preventDefault();
    axios.put('/holds/'+ this.state.access_key, { hold_change: { status: 'cancelled', comment: this.state.comment } 
     }).then(res => {
        if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
          window.location = res.request.responseURL;
          return false;
        } else {
          this.props.history.push("/ordered_holds/"+ this.state.access_key)
        }
      })
      .catch(function (error) {
        console.log(error)
    })
  }


  render() {  
    return (
      <DSProvider>
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <div className="cancel-header" >Please Confirm, Are you sure you want to cancle this order for </div>{<br/>}
              <Label htmlFor="inputID-attrs" id={"label"} className="cancel-button-label">
                Reason For cancelling (optional)
              </Label>
              <TextInput id="cancel-order-button" value={this.state.comment} showLabel showOptReqLabel type="text" onChange={this.handleCancelComment}/>
              <Button className="cancel-button" buttonType={ButtonTypes.NoBrand} onClick={this.handleSubmit}> Cancel My Order </Button>
            </>
          }
          contentSidebar={<></>}
          sidebar="right"
        />
      </DSProvider>
  )}
}