import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import { Route, BrowserRouter as Router, Switch , Redirect, Link as ReactRouterLink} from "react-router-dom";
import { titleCase } from "title-case";

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
  Heading,
  Image, Flex, Spacer, 
  List, Link, DSProvider, TemplateAppContainer, Text, Form, FormRow, FormField, SimpleGrid, ButtonGroup, Box, HorizontalRule, StatusBadge, VStack, Icon, Breadcrumbs, Hero, Notification
} from '@nypl/design-system-react-components';

import TeacherSetOrder from "./TeacherSetOrder";
import mlnImage from '../images/mln.svg'

export default class TeacherSetDetails extends React.Component {

  constructor(props) {
    super(props);
    this.state = { ts_details: {}, allowed_quantities: [], teacher_set: "", active_hold: "", books: [], value: "",
                   quantity: "1", access_key: "", hold: {}, teacher_set_notes: [], disableOrderButton: true, errorMessage: "", maxCopiesRequestable: "", bookImageHeight: "", bookImageWidth: "" };
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

          if (res.data.status === 'created') {
            this.props.handleTeacherSetOrderedData(res.data.hold, this.state.teacher_set)
            this.props.history.push("/ordered_holds/"+ res.data.hold["access_key"])
          } else {
            this.setState({ errorMessage: res.data.message})
          }
        }
      })
      .catch(function (error) {
       console.log(error)
    })
  }

  teacherSetTitle() {
    return <>{this.state.teacher_set["title"]}</>
  }


  TeacherSetDescription() {
    return <div id="ts-page-desc">{this.state.teacher_set["description"]}</div>
  }

  AvailableCopies() {
    return <div color="var(--nypl-colors-ui-black)">{this.state.teacher_set["available_copies"]} of {this.state.teacher_set["total_copies"]} Available</div>
  }

  BooksCount() {
    return <div className="bookTitlesCount">{this.state.books.length > 1 ? this.state.books.length + " Titles" : this.state.books.length >= 1 ?  this.state.books.length + " Title" : ""}</div>
  }

  TeacherSetBooks() {
    return this.state.books.map((data, i) => {
      return <ReactRouterLink id={"ts-books-" + i} to={"/book_details/" + data.id} >
          {this.BookImage(data)}
        </ReactRouterLink>
    })
  }

  bookImageDimensions = ({target:img}) => {
    this.setState({bookImageHeight: img.offsetHeight, bookImageWidth: img.offsetWidth});
  }

  BookImage(data) {
    if (data.cover_uri) {
      if (this.state.bookImageHeight === 1 && this.state.bookImageWidth === 1) {
        return <img src={mlnImage} />
      }
      return <img onLoad={this.bookImageDimensions} src={data.cover_uri} />
    } else {
      return <Image additionalImageStyles={{height: "auto"}} id={"ts-books-" + data.id} src={mlnImage} aspectRatio="square" size="default" alt="Book image"/>
    }
  }

  TeacherSetNotesContent() {
    return this.state.teacher_set_notes.map((note, i) => {
      return <div id={"ts-notes-content-" + i}>{note.content}</div> 
    })
  }

  teacherSetUnAvailable() {
    if (this.state.teacher_set <= 0) {
      return <Text sixe="default">This Teacher Set is unavailable. As it is currently being used by other educators, please allow 60 days or more for availability. If you would like to be placed on the wait list for this Teacher Set, contact us at help@mylibrarynyc.org.</Text>
    }
  }

  OrderTeacherSets() {
    if (this.state.teacher_set && this.state.teacher_set.available_copies <= 0 ) {
      return <Text width="m" size="default"><b>This Teacher Set is unavailable.</b> <i>As it is currently being used by other educators, please allow 60 days or more for availability. If you would like to be placed on the wait list for this Teacher Set, contact us at <a target='_blank' href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org.</a></i></Text>
    } else if(this.state.allowed_quantities.length <= 0) {
      return <Text width="m" size="default"><b>Unable to order additional Teacher Sets.</b> <i>You have <Link href='/account_details' id="ts-page-account-details-link" type="action" target='_blank'>requested</Link> the maximum allowed quantity of this Teacher Set. If you need more copies of this Teacher Set, contact us at <a target='_blank' href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org.</a></i></Text>
    }
    else {
      return <div>
        <Form gap="grid.xs" id="ts-order-form" onSubmit={this.handleSubmit} >
          <FormField id="ts-order-field">
            <Select id="ts-order-allowed-quantities" showLabel={false} onChange={this.handleQuantity} value={this.state.quantity}>
              { this.state.allowed_quantities.map((item, i) => {
                  return (
                    <option id={"ts-quantity-" + i} key={i} value={item}>{item}</option>
                  )
                }, this)
              }
            </Select>
            <Button id="ts-order-submit" buttonType="noBrand" onClick={this.handleSubmit}> Place Order </Button>
          </FormField>
        </Form>
        <Text isItalic size="default" marginTop="s">Note: Available Teacher Sets will deliver to your school within 2 weeks. For Teacher Sets that are currently in use by other educators, please allow 60 days or more for delivery. If you need materials right away, contact us at <a target='_blank' href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org.</a></Text>
      </div>
    }
  }

  truncateTitle( str, n, useWordBoundary ){
    if (str.length <= n) { return str; }
    const subString = str.substr(0, n-1); // the original check
    return (useWordBoundary 
      ? subString.substr(0, subString.lastIndexOf(" ")) 
      : subString) + "...";
  };

  breadcrumbTitle(title) {
    if (title.length >= 60) {
      return this.truncateTitle( title, 60, true )
    } else {
      return this.truncateTitle( title, 60, false )
    }
  }

  errorMessage() {
    if (this.state.errorMessage) {
      return <Notification ariaLabel="Hold creation error" id="hold-error-message"
                           notificationType="warning" notificationContent={this.state.errorMessage} />
    } else {
      return <></>
    }
  }

  render() {
    let teacher_set =  this.state.teacher_set
    let suitabilities_string = teacher_set.suitabilities_string;
    let primary_language = teacher_set.primary_language;
    let set_type =  teacher_set.set_type;
    let physical_description = teacher_set.physical_description;
    let call_number = teacher_set.call_number;
    let access_key = this.state.access_key;
    let details_url = teacher_set.details_url? teacher_set.details_url : "";
    let availability = teacher_set.availability !== undefined ? teacher_set.availability : ""
    let availability_status_badge =  (teacher_set.availability == "available") ? "medium" : "low"
    let legacy_detail_url = "http://legacycatalog.nypl.org/record="+ teacher_set.bnumber +"~S1"
    let breadcrumbs_location_path = window.location.pathname.split(/\/|\?|&|=|\./g)[1]
    let location_path = window.location.pathname.split(/\/|\?|&|=|\./g)[1]
    let title = teacher_set.title? this.state.teacher_set.title : ""
    
    return (
      <DSProvider>
        <TemplateAppContainer
          breakout={<>
            <Breadcrumbs id={"mln-breadcrumbs-ts-details"}
                         breadcrumbsData={[{ url: "//"+ process.env.MLN_INFO_SITE_HOSTNAME, text: "Home" }, 
                                           { url: "//"+ window.location.hostname + '/teacher_set_data', text: "Teacher Sets" },
                                           { url: "//"+ window.location.hostname + window.location.pathname, text: this.breadcrumbTitle(title) }]}

                         breadcrumbsType="booksAndMore" />
            <Hero heroType="tertiary"
              backgroundColor="var(--nypl-colors-brand-primary)"
              heading={<Heading level="one" id={"hero-"+breadcrumbs_location_path} text="Teacher Sets"  />} />
          </>}
          contentTop={this.errorMessage()}
          contentPrimary={
            <>
              <Flex alignItems="baseline">
                <Heading id="heading-secondary" level="one" size="secondary" text={ this.teacherSetTitle() } />
                <Spacer />
                <StatusBadge level={availability_status_badge}>{titleCase(availability)}</StatusBadge>
              </Flex>
              <HorizontalRule id="ts-detail-page-horizontal-rulel" className="teacherSetHorizontal" />

              <VStack align="left" spacing="s">
                <Heading id="ts-header-desc-text" level="three" size="tertiary" text="What is in the box" />                
                 { this.TeacherSetDescription() }
                <div id="ts-page-books-count"> { this.BooksCount() } </div>
                <SimpleGrid id="ts-page-books-panel" columns={5} gap="xxs"> { this.TeacherSetBooks() } </SimpleGrid>
              </VStack>

              <List id="ts-list-details" type="dl" title="Details" marginTop="s">
                <dt id="ts-suggested-grade-range-text">
                  Suggested Grade Range [New]
                </dt>
                <dd id="ts-page-suitabilities">
                  {suitabilities_string}
                </dd>

                <dt id="ts-page-primary-language-text">
                  Primary Language
                </dt>
                <dd id="ts-page-primary-language">
                  {primary_language}
                </dd>

                <dt id="ts-page-set-type-text">
                  Type
                </dt>
                <dd id="ts-page-set-type">
                  {set_type}
                </dd>

                <dt id="ts-page-physical-desc-text">
                  Physical Description
                </dt>
                <dd id="ts-page-physical-desc">
                  {physical_description}
                </dd>

                <dt id="ts-page-notes-content-text">
                  Notes
                </dt>
                <dd id="ts-page-notes-content">
                  {this.TeacherSetNotesContent()}
                </dd>

                <dt id="ts-page-call-number-text">
                  Call Number
                </dt>
                <dd id="ts-page-call-number">
                  {call_number}
                </dd>
              </List>
              <Link className="tsDetailUrl" href={legacy_detail_url} id="ts-page-details_url" type="action" target='_blank'>
                View in catalog
                <Icon name="actionLaunch" iconRotation="rotate0" size="medium" align="left" />
              </Link>

            </>
          }
          contentSidebar={
            <VStack align="left" spacing="s">
              <Box id="teacher-set-details-order-page" bg="var(--nypl-colors-ui-gray-x-light-cool)" color="var(--nypl-colors-ui-black)" padding="m" borderWidth="1px" borderRadius="sm" overflow="hidden">
                <Heading id="ts-order-set" textAlign="center" noSpace level="three" size="secondary" text="Order Set!" />
                <Heading id="ts-available-copies" textAlign="center" size="callout" level="four" text={this.AvailableCopies()} />
                {this.OrderTeacherSets()}

              </Box>
              <HaveQuestions />
            </VStack>
          }
          sidebar="right"
        />
      </DSProvider>
    )
  }
}