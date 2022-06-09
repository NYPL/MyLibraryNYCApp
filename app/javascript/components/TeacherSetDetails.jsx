import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import { Route, BrowserRouter as Router, Switch , Redirect, Link as ReactRouterLink} from "react-router-dom";

import axios from 'axios';
import {
  Button,
  SearchBar,
  Select,
  Input,
  SearchButton,
  Card,
  CardHeading,
  CardContent,
  MDXCreateElement,
  Heading,
  Image,
  List, Link, DSProvider, TemplateAppContainer, Text, Form, FormRow, FormField, SimpleGrid, ButtonGroup
} from '@nypl/design-system-react-components';

import TeacherSetOrder from "./TeacherSetOrder";
import mlnImage from '../images/mln.svg'



export default class TeacherSetDetails extends React.Component {

  constructor(props) {
    super(props);
    this.state = { ts_details: {}, allowed_quantities: [], teacher_set: "", active_hold: "", books: [], value: "",
                   quantity: "1", access_key: "", hold: {}, teacher_set_notes: [], disableOrderButton: true };
  }


  componentDidMount() {
    axios.get('/teacher_sets/'+ this.props.match.params.id)
      .then(res => {
        this.setState({ allowed_quantities: res.data.allowed_quantities, 
                        teacher_set: res.data.teacher_set, 
                        books: res.data.books, 
                        active_hold: res.data.active_hold,
                        teacher_set_notes: res.data.teacher_set_notes
                      });

        if (res.data.allowed_quantities.length > 0) {
          this.setState({ disableOrderButton: false })
        }
      })
      .catch(function (error) {
        console.log(error);
    })    
  }


  handleQuantity = event => {
    this.setState({
      quantity: event.target.value
    })
  }

  handleSubmit = event => {
    event.preventDefault();
    axios.post('/holds', {
        teacher_set_id: this.props.match.params.id, query_params: {quantity: this.state.quantity}
     }).then(res => {

        if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
          window.location = res.request.responseURL;
          return false;
        } else {
          this.props.handleTeacherSetOrderedData(res.data.hold, this.state.teacher_set)
          this.props.history.push("/ordered_holds/"+ res.data.hold["access_key"])
        }
      })
      .catch(function (error) {
       console.log(error)
    })
  }


  TeacherSetTitle() {
    return <div>{this.state.teacher_set["title"]}</div>
  }


  TeacherSetDescription() {
    return <div>{this.state.teacher_set["description"]}</div>
  }

  AvailableCopies() {
    return <div>ORDER NOW! {this.state.teacher_set["available_copies"]} of {this.state.teacher_set["total_copies"]} Available</div>
  }

  BooksCount() {
    return <div className="bookTitlesCount">{this.state.books.length > 0 ? this.state.books.length + " Titles" : ""}</div>
  }


  TeacherSetBooks() {
    return this.state.books.map((data, i) => {
      return <ReactRouterLink id={"ts-books-" + i} to={"/book_details/" + data.id} >
          {this.BookImage(data)}
        </ReactRouterLink>
    })
  }


  BookImage(data) {
    if (data.cover_uri) {
      return <Image id={"ts-books-" + data.id} src={data.cover_uri} aspectRatio="square" size="default"  />
    } else {
      return <Image id={"ts-books-" + data.id} src={mlnImage} size="default" />
    }
  }


  TeacherSetNotesContent() {
    return this.state.teacher_set_notes.map((note, i) => {
      return <div id={"ts-notes-content-" + i}>{note.content}</div> 
    })
  }

  render() {
    let allowed_quantities = this.state.allowed_quantities.map((item, i) => {
      return (
        <option id={"ts-quantity-" + i} key={i} value={item}>{item}</option>
      )
    }, this);


    let teacher_set =  this.state.teacher_set
    let suitabilities_string = teacher_set.suitabilities_string;
    let primary_language = teacher_set.primary_language;
    let set_type =  teacher_set.set_type;
    let physical_description = teacher_set.physical_description;
    let call_number = teacher_set.call_number;
    let access_key = this.state.access_key;
    let details_url = teacher_set.details_url;


    return (
      <DSProvider>
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <div className="content-top card_details">
                <Card id="ts-card-details" layout="row" border className="order-list">
                  <CardHeading id="ts-card-title" level={3} className="ts-details">
                   { this.TeacherSetTitle() }
                  </CardHeading>

                  <CardHeading  id="ts-card-available-copies" level={4} className="ts-details">
                   { this.AvailableCopies() }
                  </CardHeading>

                  <CardContent id="ts-card-desc">
                     <Text isItalic>Note : Available Teacher Sets will deliver to your school within 2 weeks. For Teacher Sets that are currently in use by other educators, please allow 60 days or more for delivery. If you need materials right away, contact us at help@mylibrarynyc.org</Text>
                  </CardContent>

                  <CardContent level={5} id="ts-allowed-quantity-details-form">
                    <Form id="ts-order-form" onSubmit={this.handleSubmit} className="order_select">
                      <FormField id="ts-order-field">
                        <ButtonGroup>
                          <Select id="ts-order-allowed_quantities" showLabel={false} onChange={this.handleQuantity} value={this.state.quantity}>
                            {allowed_quantities}
                          </Select>
                          <Button id="ts-order-submit" buttonType="noBrand" onClick={this.handleSubmit}> Place Order </Button>
                        </ButtonGroup>
                      </FormField>
                    </Form>
                  </CardContent>
                </Card>
              </div>{<br/>}

              <div>
                <Heading id="ts-header-desc-text" level={2} text="What is in the box" />
                <div id="ts-page-desc"> { this.TeacherSetDescription() } </div>{<br/>}
                <div id="ts-page-books-count"> { this.BooksCount() } </div> {<br/>}
                <SimpleGrid id="ts-page-books-panel" columns={5} gap="xxs"> { this.TeacherSetBooks() } </SimpleGrid>
              </div>{<br/>}

              <div className="tsDetails">
                <List id="ts-list-details" type="dl" className="listType">
                  <dt id="ts-suggested-grade-range-text" className="font-weight-500 orderDetails">
                    Suggested Grade Range [New]
                  </dt>
                  <dd id="ts-page-suitabilities" className="orderDetails">
                    {suitabilities_string}
                  </dd>

                  <dt id="ts-page-primary-language-text" className="font-weight-500 orderDetails">
                    Primary Language
                  </dt>
                  <dd id="ts-page-primary-language" className="orderDetails">
                    {primary_language}
                  </dd>

                  <dt id="ts-page-set-type-text" className="font-weight-500 orderDetails">
                    Type
                  </dt>
                  <dd id="ts-page-set-type" className="orderDetails">
                    {set_type}
                  </dd>

                  <dt id="ts-page-physical-desc-text" className="font-weight-500 orderDetails">
                    Physical Description
                  </dt>
                  <dd id="ts-page-physical-desc" className="orderDetails">
                    {physical_description}
                  </dd>

                  <dt id="ts-page-notes-content-text" className="font-weight-500 orderDetails">
                    Notes
                  </dt>
                  <dd id="ts-page-notes-content" className="orderDetails">
                    {this.TeacherSetNotesContent()}
                  </dd>

                  <dt id="ts-page-call-number-text" className="font-weight-500 orderDetails">
                    Call Number
                  </dt>
                  <dd id="ts-page-call-number" className="orderDetails">
                    {call_number}
                  </dd>
                </List>
              </div>

              <a id="ts-page-details_url" target='_blank' href={this.state.teacher_set['details_url']}>View in catalog</a>           
            </>
          }
          contentSidebar={<></>}
          sidebar="right"
        />
      </DSProvider>
    )
  }
}