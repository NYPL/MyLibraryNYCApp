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
  List, Link, LinkTypes, DSProvider, TemplateAppContainer, HorizontalRule, Text, Form, FormRow, FormField, Icon, ImageSizes, HeadingLevels, ImageRatios
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


  TeacherSets() {
    return this.state.teacher_sets.map((data, i) => {
      return <div>
        <ReactRouterLink to={"/book_details/" + data.id} >
          <Image imageSize="small" src={data.cover_uri} />
        </ReactRouterLink>
      </div>      
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
        return <div> {<br/>}
            <Card layout={CardLayouts.Row} imageSrc={bookImage} imageAlt="Alt text" imageAspectRatio={ImageRatios.Square} imageSize={ImageSizes.ExtraExtraSmall}>
              <CardHeading level={HeadingLevels.Three} id="row2-heading1">
                <ReactRouterLink to={"/teacher_set_details/" + ts.id}>
                  {ts.title}
                </ReactRouterLink>
              </CardHeading>

              
              <CardContent> {ts.suitabilities_string} </CardContent>
              <CardContent> {ts.availability} </CardContent>
              <CardContent> {ts.description} </CardContent>
            </Card>
            <HorizontalRule align="left" height="3px" width="856px" />
        </div>
      })
    }
  }

  render() {
    let book = this.state.book;
    let teacher_sets = this.state.teacher_sets

    return (
      <DSProvider>
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <Card layout={CardLayouts.Row}  imageComponent={<div className=""><Image className="bookPageImage" src={this.BookImage(book)} alt="Alt text" imageAspectRatio={ImageRatios.threeByFour} imageSize={ImageSizes.Default} /></div>} >

                 { this.IsBookTitlePresent() ? (
                  <CardHeading level={HeadingLevels.Three}>
                    {this.state.book.title}
                  </CardHeading>
                ) : (<></>) }

                 { this.IsBookSubTitlePresent() ? (
                  <CardHeading level={HeadingLevels.Four}>
                    {this.state.book.sub_title}
                  </CardHeading>
                ) : (<></>) }

                { this.IsBookStatementOfResponsibilityPresent() ? (
                  <CardContent level={HeadingLevels.Three}>
                    {this.state.book.statement_of_responsibility}{<br/>}
                  </CardContent>
                ) : (<></>) }

                { this.IsBookDescriptionPresent() ? (
                  <CardContent>
                    {this.state.book.description}{<br/>}
                  </CardContent>
                ) : (<></>) }
              </Card>
              {<br/>}{<br/>}

              <List type="dl">
                { book.publication_date ? (<>
                  <dt className="font-weight-500 orderDetails">
                    Publication Date
                  </dt> 
                  <dd className="orderDetails">
                    {book.publication_date}
                  </dd> </>) : (<></>) }

                { book.call_number ? (<>
                  <dt className="font-weight-500 orderDetails">
                    Call Number
                  </dt> 
                  <dd className="orderDetails">
                    {book.call_number}
                  </dd> </>) : (<></>) }

                { book.physical_description ? (<>
                  <dt className="font-weight-500 orderDetails">
                    Physical Description
                  </dt> <dd className="orderDetails">
                    {book.physical_description}
                  </dd></>) : (<></>) }

                { book.primary_language ? (<>
                  <dt className="font-weight-500 orderDetails">
                    Primary Language
                  </dt> <dd className="orderDetails">
                    {book.primary_language}
                  </dd></>) : (<></>) }

                { book.notes ? (<>
                  <dt className="font-weight-500 orderDetails">
                    ISBN
                  </dt> <dd className="orderDetails">
                    {book.isbn}
                  </dd></>) : (<></>) }

                { book.notes ? (<>
                  <dt className="font-weight-500 orderDetails">
                    Notes
                  </dt> <dd className="orderDetails">
                    {book.notes}
                  </dd></>) : (<></>) }
                  <dt className="font-weight-500 orderDetails">
                    <a target='_blank' href={book.details_url}>View in catalog</a>{<br/>}
                  </dt>
              </List>{<br/>}

              <Heading level={HeadingLevels.Three}>Appears in These Sets:</Heading>
              {this.TeacherSetDetails()}
            </>
          }
          contentSidebar={<></>}
          sidebar="right"
        />
      </DSProvider>
    )
  }
}