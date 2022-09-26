import React, { Component, useState, useEffect } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import { Link as ReactRouterLink, useParams} from "react-router-dom";
import axios from 'axios';
import { titleCase } from "title-case";
import {
  Card,
  CardHeading,
  CardContent,
  Heading,
  Image,
  List, TemplateAppContainer, HorizontalRule, StatusBadge, Flex, Spacer,Link, Icon, Breadcrumbs
} from '@nypl/design-system-react-components';
import mlnImage from '../images/mln.svg'


export default function TeacherSetBooks(props) {

  const params = useParams();
  const [book, setBook] = useState("")
  const [teacherSets, setTeacherSets] = useState([])
  const [bookImageHeight, setBookImageHeight] = useState([])
  const [bookImageWidth, setBookImageWidth] = useState([])

  useEffect(() => {
    axios.get('/books/'+ params["id"])
      .then(res => {
        setTeacherSets(res.data.teacher_sets)
        setBook(res.data.book)
      })
      .catch(function (error) {
        console.log(error);
    })    
  }, []);


  const IsBookTitlePresent = () => {
    return (book["title"] == null) ? false : true
  }

  const IsBookSubTitlePresent = () => {
    return (book["sub_title"] == null) ? false : true
  }

  const IsBookDescriptionPresent = () => {
    return (book["description"] == null) ? false : true
  }

  const IsBookStatementOfResponsibilityPresent = () => {
    return (book["statement_of_responsibility"] == null) ? false : true
  }

  const IsBookNotesPresent = () => {
    return (book["notes"] == null) ? false : true
  }

  const BookCoverUri = () => {
    return <div>
      book.cover_uri
    </div>
  }

  const truncateTitle = ( str, n, useWordBoundary ) => {
    if (str.length <= n) { return str; }
    const subString = str.substr(0, n-1); // the original check
    return (useWordBoundary 
      ? subString.substr(0, subString.lastIndexOf(" ")) 
      : subString) + "...";
  };

  const breadcrumbTitle = (title) => {
    if (title.length >= 60) {
      return truncateTitle( title, 60, true )
    } else {
      return truncateTitle( title, 60, false )
    }
  }


  const TeacherSetDetails = () => {
    if (teacherSets) {
      return teacherSets.map((ts, i) => {
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
                <StatusBadge level={availability_status_badge}>{titleCase(availability)}</StatusBadge>
              </CardContent>
              <CardContent id="book-page-ts-description"> {ts.description} </CardContent>
            </Card>
            <HorizontalRule />
        </div>
      })
    }
  }

  const BookImage = (data) => {
    if (data.cover_uri) {
      if (bookImageHeight === 1 && bookImageWidth === 1) {
        return <Image src={mlnImage} aspectRatio="original" size="medium" alt="Book image"/>
      } else if (bookImageHeight === 189 && bookImageWidth === 189){
        return <Image id={"ts-books-" + data.id} src={data.cover_uri} aspectRatio="original" size="medium" alt="Book image"/>
      } else {
        return <img onLoad={bookImageDimensions} src={data.cover_uri} />
      }
    } else {
      return <Image id={"ts-books-" + data.id} src={mlnImage} aspectRatio="original" size="medium" alt="Book image"/>
    }
  }

  const bookImageDimensions = ({target: img }) => {
    if ((img.offsetHeight === 1) || (img.offsetWidth === 1)) {
      setBookImageHeight(img.offsetHeight)
      setBookImageWidth(img.offsetWidth)
    } else {
      setBookImageHeight(189)
      setBookImageWidth(189)
    }
  }

   // let book = this.state.book;
    let bookTitle = book.title? book.title : "Book Title"
    let legacy_detail_url = "http://legacycatalog.nypl.org/record="+ book.bnumber +"~S1"
    
    return (
        <TemplateAppContainer
          breakout={<Breadcrumbs id={"mln-breadcrumbs-ts-details"}
                         breadcrumbsData={[{ url: "//"+ process.env.MLN_INFO_SITE_HOSTNAME, text: "Home" }, 
                                           { url: "//"+ window.location.hostname + window.location.pathname, text: "Book Details" },
                                           { url: "//"+ window.location.hostname + window.location.pathname, text: breadcrumbTitle(bookTitle) }]}
                         breadcrumbsType="booksAndMore" />}
          contentPrimary={
            <>
              <Flex alignItems="baseline">
                <Heading id="heading-id" level="two" size="secondary" text={"" + bookTitle} />
              </Flex>

              <HorizontalRule id="ts-book-details-horizontal-rule" className="teacherSetHorizontal" />

              <Card id="book-page-card-details" layout="row" imageProps={{ component: BookImage(book) }} >
                { IsBookSubTitlePresent() ? (
                  <CardHeading id="book-page-sub_title" level="three">
                    {book.sub_title}
                  </CardHeading>
                ) : (<></>) }

                { IsBookStatementOfResponsibilityPresent() ? (
                  <CardContent id="book-page-statement_of_responsibility" level="three">
                    {book.statement_of_responsibility}
                  </CardContent>
                ) : (<></>) }

                { IsBookDescriptionPresent() ? (
                  <CardContent id="book-page-desc">
                    {book.description}
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

              <Link className="tsDetailUrl" href={legacy_detail_url} id="ts-book-page-details_url" type="action" target='_blank'>
                View in catalog
                <Icon name="actionLaunch" iconRotation="rotate0" size="medium" align="left" />
              </Link>
              <Heading marginTop="l" id="appears-in-ts-text" size="tertiary" level="three">Appears in These Sets</Heading>
              {TeacherSetDetails()}
            </>
          }
          contentSidebar={<div><HaveQuestions /></div>}
          sidebar="right"
        />
    )
}