import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import { Route, BrowserRouter as Router, Switch , Redirect} from "react-router-dom";

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
  List
} from '@nypl/design-system-react-components';

import TeacherSetOrder from "./TeacherSetOrder";


export default class TeacherSetDetails extends React.Component {

  constructor(props) {
    super(props);
    this.state = { ts_details: {}, allowed_quantities: [], teacher_set: "", active_hold: "", books: [], quantity: "", access_key: "", hold: {} };
  }


  componentDidMount() {
    axios.get('/teacher_sets/'+ this.props.match.params.id)
      .then(res => {
        this.setState({ allowed_quantities: res.data.allowed_quantities, 
                        teacher_set: res.data.teacher_set, 
                        books: res.data.books, 
                        active_hold: res.data.active_hold

                      });

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
        teacher_set_id: this.props.match.params.id
     }).then(res => {
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
    return <div>{this.state.books.length > 0 ? this.state.books.length + " Titles" : ""}</div>
  }


  TeacherSetBooks() {
    return this.state.books.map((data, i) => {
      return <div><Image style={{ height: 170, width: 150, margin: 1 }} src={data.cover_uri} /></div>      
    })
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
    let notes = teacher_set.teacher_set_notes
    let access_key = this.state.access_key;


    return (
      <>
        <AppBreadcrumbs />
        <div className="layout-container nypl-ds">
          <main className="main main--with-sidebar">
            <div className="content-primary content-primary--with-sidebar-right">
              <div className="content-top card_details">
                <div style={{ display: "grid", "grid-gap": "2rem", "grid-template-columns": "repeat(1, 1fr)" }}>

                  <Card layout={CardLayouts.Horizontal} border className="faq_list">

                    <CardHeading level={3} id="heading1">
                     { this.TeacherSetTitle() }
                    </CardHeading>

                    <CardHeading level={4} id="heading4">
                     { this.AvailableCopies() }
                    </CardHeading>

                    <CardContent className="italic" >
                      Note : Available Teacher Sets will deliver to your school within 2 weeks. For Teacher Sets that are currently in use by other educators, please allow 60 days or more for delivery. If you need materials right away, contact us at help@mylibrarynyc.org
                    </CardContent>

                    <CardHeading level={5} id="heading5">
                      <div id="teacher_set_details">
                        <SearchBar onSubmit={this.handleSubmit}>
                          <Select ariaLabel="Filter Search" id="select-searchBar" onChange={this.handleQuantity} selectedOption={this.state.field} name="search_scope">
                            {allowed_quantities}      
                          </Select>
                          <Button buttonType={ButtonTypes.Primary} id="button" type="submit"> Place Order </Button> 
                        </SearchBar> 
                      </div>
                    </CardHeading>
                  </Card>
                </div>
              </div>{<br/>}
              <div>
                <Heading id="heading2" level={2} text="What is in the box" />
                <div> { this.TeacherSetDescription() } </div>{<br/>}
                <div> { this.BooksCount() } </div>
                <div className="bookImage"> { this.TeacherSetBooks() } </div>
              </div>

              <List id="nypl-list2" title="" type="dl">
                <dt>
                  Suggested Grade Range [New]
                </dt>
                <dd>
                  {suitabilities_string}
                </dd>

                <dt>
                  Primary Language
                </dt>
                <dd>
                  {primary_language}
                </dd>

                <dt>
                  Type
                </dt>
                <dd>
                  {set_type}
                </dd>

                <dt>
                  Physical Description
                </dt>
                <dd>
                  {physical_description}
                </dd>

                <dt>
                  Notes
                </dt>
                <dd>
                  {notes}
                </dd>
              </List>
            </div>

            

            <div className="content-secondary content-secondary--with-sidebar-right">
            
            </div>

          </main>

        </div>

      </>
    )
  }

}