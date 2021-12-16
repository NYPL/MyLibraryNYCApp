import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import { Route, BrowserRouter as Router, Switch , Redirect, Link as ReactRouterLink} from "react-router-dom";

import axios from 'axios';
import {
  Button,
  ButtonTypes,
  SearchBar,
  Select,
  Input,
  SearchButton,
  Card,
  CardHeading,
  CardLayouts,
  CardContent,
  MDXCreateElement,
  Heading,
  Image,
  List, Link, LinkTypes, DSProvider, TemplateAppContainer, Text, Form, FormRow, FormField
} from '@nypl/design-system-react-components';

import TeacherSetOrder from "./TeacherSetOrder";



export default class TeacherSetDetails extends React.Component {

  constructor(props) {
    super(props);
    this.state = { ts_details: {}, allowed_quantities: [], teacher_set: "", active_hold: "", books: [], value: "",
                   quantity: "", access_key: "", hold: {}, teacher_set_notes: [], disableOrderButton: true };
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
    console.log("okokokokoko")
    this.setState({
      quantity: event.target.value
    })
  }

  handleSubmit = event => {
    console.log("order submit")
    event.preventDefault();

    axios.post('/holds', {
        teacher_set_id: this.props.match.params.id
     }).then(res => {
      
        console.log(res.request.responseURL + " plpl")
        console.log(process.env.MLN_INFO_SITE_HOSTNAME + " oookok")

        if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + ":3000/users/start") {
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


  onFieldChange(e) {
    const newFieldVal = e.target.value;
    this.setState({ quantity: newFieldVal });
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
      return <div>
        <ReactRouterLink to={"/book_details/" + data.id} >
          <Image imageSize="small" src={data.cover_uri} />
        </ReactRouterLink>
      </div>      
    })
  }

  TeacherSetNotesContent() {
    return this.state.teacher_set_notes.map((note, i) => {
      return <div>{note.content}</div> 
    })
  }

  ViewCatalogLink() {
    return 
  }

  render() {
    let allowed_quantities = this.state.allowed_quantities.map((item, i) => {
      return (
        <option key={i} value={item}>{item}</option>
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
                  <Card layout="row" border className="order-list">
                    <CardHeading level={3} className="ts-details">
                     { this.TeacherSetTitle() }
                    </CardHeading>

                    <CardHeading level={4} className="ts-details">
                     { this.AvailableCopies() }
                    </CardHeading>

                    <CardContent>
                       <Text isItalic>Note : Available Teacher Sets will deliver to your school within 2 weeks. For Teacher Sets that are currently in use by other educators, please allow 60 days or more for delivery. If you need materials right away, contact us at help@mylibrarynyc.org</Text>
                    </CardContent>

                    <CardContent level={5}>

                      <Form onSubmit={this.handleSubmit} className="order_select">
                        <FormRow >
                          <Select labelText="What is your favorite color?" showLabel={false} onChange={this.handleQuantity} value="" >
                            {allowed_quantities}
                          </Select>
                          <Button buttonType={ButtonTypes.NoBrand} onClick={this.handleSubmit}> Place Order </Button>
                        </FormRow>
                      </Form>
                      
                    </CardContent>
                  </Card>
                </div>{<br/>}

              <div>
                <Heading id="heading2" level={2} text="What is in the box" />
                <div> { this.TeacherSetDescription() } </div>{<br/>}
                <div> { this.BooksCount() } </div>
                <div className="bookImage"> { this.TeacherSetBooks() } </div>
              </div>

              <div className="tsDetails">
                <List type="dl">
                  <dt className="font-weight-500 orderDetails">
                    Suggested Grade Range [New]
                  </dt>
                  <dd className="orderDetails">
                    {suitabilities_string}
                  </dd>

                  <dt className="font-weight-500 orderDetails">
                    Primary Language
                  </dt>
                  <dd className="orderDetails">
                    {primary_language}
                  </dd>

                  <dt className="font-weight-500 orderDetails">
                    Type
                  </dt>
                  <dd className="orderDetails">
                    {set_type}
                  </dd>

                  <dt className="font-weight-500 orderDetails">
                    Physical Description
                  </dt>
                  <dd className="orderDetails">
                    {physical_description}
                  </dd>

                  <dt className="font-weight-500 orderDetails">
                    Notes
                  </dt>
                  <dd className="orderDetails">
                    {this.TeacherSetNotesContent()}
                  </dd>

                  <dt className="font-weight-500 orderDetails">
                    Call Number
                  </dt>
                  <dd className="orderDetails">
                    {call_number}
                  </dd>
                </List>
              </div>

              <a target='_blank' href={this.state.teacher_set['details_url']}>View in catalog</a>           
            </>
          }
          contentSidebar={<></>}
          sidebar="right"
        />
      </DSProvider>
    )
  }
}