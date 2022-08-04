import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import TeacherSetOrderDetails from "./TeacherSetOrderDetails";
import axios from 'axios';
import {
  Button,
  SearchBar, Select, Input, SearchButton, Heading, Image, List, Link, TextInput, Label, DSProvider, HStack,
  TemplateAppContainer, Text, HorizontalRule
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
        if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + ":3000/signin") {
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

  cancelConfirmation() {
    if (this.state.hold["status"] !== "cancelled") {
      return <>
        <Heading marginTop="l" id="ts-cancellation-confirmation-text" level="one" size="tertiary" text="Confirm Cancellation" />
        <TextInput id="ts-cancel-order-button" labelText="Reason For cancelling order" type="textarea" value={this.state.comment} showLabel showOptReqLabel onChange={this.handleCancelComment}/>
        <Label marginTop="m" htmlFor="id-of-input-element" id="confirm-teacher-set-order-label">Are you sure you want to cancel your teacher set order?</Label>
        <HStack spacing="s">
          <Button id="ts-cancel-button-id" buttonType="noBrand" onClick={this.handleSubmit}> Cancel My Order </Button>
          <Button id="keep-my-order-button" className="cancel-button" buttonType="secondary" >
            <Link className="cancelOrderButton" href={"/ordered_holds/" + this.state.access_key } > No, keep my order </Link>
          </Button>
        </HStack>
      </>
    }
  }


  render() {
    return (
      <TemplateAppContainer
        breakout={<AppBreadcrumbs />}
        contentPrimary={
          <>
            <Heading id="ts-cancellation-confirmation-text" level="two" size="secondary" text="Cancel Order" />
            <HorizontalRule id="ts-cancel-order-horizontal=line" className="teacherSetHorizontal" />
            <div>Review your order details below and verify this is the order you would like cancel.</div>
            <TeacherSetOrderDetails  teacherSetDetails={this.state.teacher_set} orderDetails={this.state.hold}/>
            {this.cancelConfirmation()}
          </>
        }
        contentSidebar={<div className="have_questions_section"><HaveQuestions /></div>}
        sidebar="right"
      />
  )}
}