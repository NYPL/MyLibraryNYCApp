import React, { Component } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import { Link as ReactRouterLink} from "react-router-dom";
import axios from 'axios';
import { titleCase } from "title-case";
import {
  Card,
  CardHeading,
  CardContent,
  Heading,
  Image,
  List, TemplateAppContainer, HorizontalRule, StatusBadge, Flex, Spacer
} from '@nypl/design-system-react-components';
import mlnImage from '../images/mln.svg'


export default class TeacherSetBooks extends React.Component {

  constructor(props) {
    super(props);
    this.state = {book: "", teacherSets: ""};
  }

  componentDidMount() {
    axios.get('/books/'+ this.props.match.params.id)
      .then(res => {
        this.setState({
          book: res.data.book, teacherSets: res.data.teacher_sets, 
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
    if (this.state.teacherSets) {
      return this.state.teacherSets.map((ts, i) => {
        let availability_status_badge =  (ts.availability == "available") ? "medium" : "low"
        let availability = ts.availability !== undefined ? ts.availability : ""
        return <div>
            <Card id="book-page-ts-card-details" layout="row">
              <CardHeading level="four" id="book-page-ts-title">
                <ReactRouterLink to={"/teacher_set_details/" + ts.id}>
                  {ts.title}
                </ReactRouterLink>
              </CardHeading>
              <CardContent id="book-page-ts-suitabilities"> {ts.suitabilities_string} </CardContent>
              <CardContent id="book-page-ts-availability"> 
                <StatusBadge level={availability_status_badge}>{availability}</StatusBadge>
              </CardContent>
              <CardContent id="book-page-ts-description"> {ts.description} </CardContent>
            </Card>
            <HorizontalRule />
        </div>
      })
    }
  }


  render() {
    let book = this.state.book;
    let bookTitle = this.state.book.title
    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <Flex alignItems="baseline">
                <Heading id="heading-id" level="two" size="secondary" text={"" + bookTitle} />
                <Spacer />
                <a id="book-page-catalog-link" target='_blank' href={this.state.book.details_url}>View in catalog</a>
              </Flex>

              <HorizontalRule style={{"margin-top": "0px"}} id="ts-book-details-horizontal-rule" className="teacherSetHorizontal" />

              <Card id="book-page-card-details" layout="row" imageProps={{ alt: 'Book Details', aspectRatio: 'square', isAtEnd: false, size: 'default', src: this.BookImage(book) }} >

                { this.IsBookSubTitlePresent() ? (
                  <CardHeading id="book-page-sub_title" level="three">
                    {this.state.book.sub_title}
                  </CardHeading>
                ) : (<></>) }

                { this.IsBookStatementOfResponsibilityPresent() ? (
                  <CardContent id="book-page-statement_of_responsibility" level="three">
                    {this.state.book.statement_of_responsibility}
                  </CardContent>
                ) : (<></>) }

                { this.IsBookDescriptionPresent() ? (
                  <CardContent id="book-page-desc">
                    {this.state.book.description}
                  </CardContent>
                ) : (<></>) }
              </Card>
              

              <List id="book-page-list-details" type="dl" title="Details" marginTop="s">
                { book.publication_date ? (<>
                  <dt id="book-page-publication-date-text">
                    Publication Date
                  </dt> 
                  <dd id="book-page-publication-date">
                    {book.publication_date}
                  </dd> </>) : (<></>) }

                { book.call_number ? (<>
                  <dt id="book-page-call-number-text">
                    Call Number
                  </dt> 
                  <dd id="book-page-call-number">
                    {book.call_number}
                  </dd> </>) : (<></>) }

                { book.physical_description ? (<>
                  <dt id="book-page-physical-desc-text">
                    Physical Description
                  </dt> 
                  <dd id="book-page-physical-desc">
                    {book.physical_description}
                  </dd></>) : (<></>) }

                { book.primary_language ? (<>
                  <dt id="book-page-primary-language-text">
                    Primary Language
                  </dt> 
                  <dd id="book-page-primary-language">
                    {book.primary_language}
                  </dd></>) : (<></>) }

                { book.isbn ? (<>
                  <dt id="book-page-isbn-text">
                    ISBN
                  </dt> 
                  <dd id="book-page-isbn">
                    {book.isbn}
                  </dd></>) : (<></>) }

                { book.notes ? (<>
                  <dt id="book-page-notes-text">
                    Notes
                  </dt> 
                  <dd id="book-page-notes">
                    {book.notes}]
                  </dd></>) : (<></>) }
              </List>

              <Heading marginTop="s" id="appears-in-ts-text" size="tertiary" level="three">Appears in These Sets</Heading>
              {this.TeacherSetDetails()}
            </>
          }
          contentSidebar={<HaveQuestions />}
          sidebar="right"
        />
    )
  }
}