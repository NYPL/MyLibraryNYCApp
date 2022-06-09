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
  List, Link, DSProvider, TemplateAppContainer, HorizontalRule, Text, Form, FormRow, FormField, Icon, ImageRatios
} from '@nypl/design-system-react-components';
import mlnImage from '../images/mln.svg'
import bookImage from '../images/book.png'
import TeacherSetOrder from "./TeacherSetOrder";

export default class TeacherSetBooks extends React.Component {

  constructor(props) {
    super(props);
    this.state = {book: "", teacher_sets: ""};
  }

  componentDidMount() {
    axios.get('/books/'+ this.props.match.params.id)
      .then(res => {
        this.setState({
          book: res.data.book, teacher_sets: res.data.teacher_sets, 
        });
      })
      .catch(function (error) {
        console.log(error);
    })    
  }


  IsBookTitlePresent() {
    return (this.state.book["title"] == null) ? false : true
  }

  IsBookSubTitlePresent() {
    return (this.state.book["sub_title"] == null) ? false : true
  }

  IsBookDescriptionPresent() {
    return (this.state.book["description"] == null) ? false : true
  }

  IsBookStatementOfResponsibilityPresent() {
    return (this.state.book["statement_of_responsibility"] == null) ? false : true
  }

  IsBookNotesPresent(){
    return (this.state.book["notes"] == null) ? false : true
  }

  BookCoverUri() {
    return <div>
      book.cover_uri
    </div>
  }


  BookImage(book) {
    if (book.cover_uri) {
      return book.cover_uri
    } else {
      return mlnImage
    }
  }


  TeacherSetDetails() {
    if (this.state.teacher_sets) {
      return this.state.teacher_sets.map((ts, i) => {
        return <div>
          <div id="book-page-ts-details" className="bookPageTSBorder">
            <Card id="book-page-ts-card-details" layout="row" imageSrc={bookImage} imageAlt="Book Details" aspectRatio="square" size="xxsmall">
              <CardHeading level="three" id="book-page-ts-title">
                <ReactRouterLink to={"/teacher_set_details/" + ts.id}>
                  {ts.title}
                </ReactRouterLink>
              </CardHeading>
              <CardContent id="book-page-ts-suitabilities"> {ts.suitabilities_string} </CardContent>
              <CardContent id="book-page-ts-availability"> {ts.availability} </CardContent>
              <CardContent id="book-page-ts-description"> {ts.description} </CardContent>
            </Card>
          </div>
        </div>
      })
    }
  }

  render() {
    let book = this.state.book;
    let teacher_sets = this.state.teacher_sets

    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
              // additionalStyles={{background: "#F2F2F0", padding: "1px", position: "initial"}}
            <>
              <Card id="book-page-card-details" layout="row"  imageComponent={<Image id="book-page-image" src={this.BookImage(book)} alt="Alt text" aspectRatio="threeByFour" size="small" />} >

                 { this.IsBookTitlePresent() ? (
                  <CardHeading id="book-page-title" level="three">
                    {this.state.book.title}
                  </CardHeading>
                ) : (<></>) }

                 { this.IsBookSubTitlePresent() ? (
                  <CardHeading id="book-page-sub_title" level="four">
                    {this.state.book.sub_title}
                  </CardHeading>
                ) : (<></>) }

                { this.IsBookStatementOfResponsibilityPresent() ? (
                  <CardContent id="book-page-statement_of_responsibility" level="three">
                    {this.state.book.statement_of_responsibility}{<br/>}
                  </CardContent>
                ) : (<></>) }

                { this.IsBookDescriptionPresent() ? (
                  <CardContent id="book-page-desc">
                    {this.state.book.description}{<br/>}
                  </CardContent>
                ) : (<></>) }
              </Card>
              {<br/>}{<br/>}

              <List id="book-page-list-details" type="dl" className="listType">
                { book.publication_date ? (<>
                  <dt id="book-page-publication-date-text" className="font-weight-500 orderDetails">
                    Publication Date
                  </dt> 
                  <dd id="book-page-publication-date" className="orderDetails">
                    {book.publication_date}
                  </dd> </>) : (<></>) }

                { book.call_number ? (<>
                  <dt id="book-page-call-number-text" className="font-weight-500 orderDetails">
                    Call Number
                  </dt> 
                  <dd id="book-page-call-number" className="orderDetails">
                    {book.call_number}
                  </dd> </>) : (<></>) }

                { book.physical_description ? (<>
                  <dt id="book-page-physical-desc-text" className="font-weight-500 orderDetails">
                    Physical Description
                  </dt> 
                  <dd id="book-page-physical-desc" className="orderDetails">
                    {book.physical_description}
                  </dd></>) : (<></>) }

                { book.primary_language ? (<>
                  <dt id="book-page-primary-language-text" className="font-weight-500 orderDetails">
                    Primary Language
                  </dt> 
                  <dd id="book-page-primary-language" className="orderDetails">
                    {book.primary_language}
                  </dd></>) : (<></>) }

                { book.notes ? (<>
                  <dt id="book-page-isbn-text" className="font-weight-500 orderDetails">
                    ISBN
                  </dt> 
                  <dd id="book-page-isbn" className="orderDetails">
                    {book.isbn}
                  </dd></>) : (<></>) }

                { book.notes ? (<>
                  <dt id="book-page-notes-text" className="font-weight-500 orderDetails">
                    Notes
                  </dt> 
                  <dd id="book-page-notes" className="orderDetails">
                    {book.notes}
                  </dd></>) : (<></>) }
                  <dt id="book-page-catalog" className="font-weight-500 orderDetails">
                    <a id="book-page-catalog-link" target='_blank' href={book.details_url}>View in catalog</a>{<br/>}
                  </dt>
              </List>{<br/>}

              <Heading id="appears-in-ts-text" level="three">Appears in These Sets</Heading>
              {this.TeacherSetDetails()}
            </>
          }
          contentSidebar={<></>}
          sidebar="right"
        />
    )
  }
}